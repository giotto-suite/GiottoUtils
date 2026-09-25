#' @title determine_cores
#' @description guesses how many cores to use
#' @return numeric
#' @keywords internal
#' @examples
#' determine_cores()
#' @export
determine_cores <- function(
        cores = getOption("giotto.cores", default = NA),
        min_cores = 1,
        max_cores = 10) {
    if (is.na(cores) ||
        !is.numeric(cores) ||
        (is.numeric(cores) && cores <= 0)) {
        package_check("parallel")
        cores <- parallel::detectCores()

        if (cores <= 2) {
            cores <- ifelse(cores < min_cores, cores, min_cores)
        } else {
            cores <- cores - 2
            cores <- ifelse(cores > max_cores, max_cores, cores)
        }
        options("giotto.cores" = cores)
        return(cores)
    } else {
        cores <- cores
        return(cores)
    }
}




#' @title get_os
#' @description return the type of operating system,
#' see https://conjugateprior.org/2015/06/identifying-the-os-from-r/
#' @return character osx, linux or windows
#' @keywords internal
#' @returns character
#' @examples
#' get_os()
#' @export
get_os <- function() {
    if (.Platform[["OS.type"]] == "windows") {
        os <- "windows"
    } else {
        sysinf <- Sys.info()
        if (!is.null(sysinf)) {
            os <- sysinf["sysname"]
            if (os == "Darwin") {
                os <- "osx"
            }
        } else { ## mystery machine
            os <- .Platform$OS.type
            if (grepl("^darwin", R.version$os)) {
                os <- "osx"
            }
            if (grepl("linux-gnu", R.version$os)) {
                os <- "linux"
            }
        }
    }
    return(tolower(os))
}


# keep awake ####

# Command to hold a "do not idle sleep" assertion, or NULL when the platform
# has no mechanism we can use. Kept separate from execution so the choice is
# testable without spawning anything.
#
# Every branch binds the helper to `pid` so the assertion is self-cleaning: it
# cannot outlive the session even if teardown never runs.
#
# macOS has a flag for it: `caffeinate -w <pid>` exits when that pid exits.
# systemd-inhibit instead holds its lock for as long as the command it is given
# keeps running, so the binding has to be the command itself. `tail --pid` is
# the usual way to spell "block until that process exits".
.awake_cmd <- function(os = get_os(), pid = Sys.getpid()) {
    switch(os,
        "osx" = list(
            cmd = "caffeinate",
            # -d display, -i idle sleep, -m disk, -s system (AC only), -u active
            args = c("-dimsu", "-w", as.character(pid))
        ),
        "linux" = if (nzchar(Sys.which("systemd-inhibit"))) {
            list(
                cmd = "systemd-inhibit",
                args = c(
                    "--what=idle:sleep",
                    "--who=Giotto",
                    "--why=long-running Giotto computation",
                    "--mode=block",
                    "tail", "--pid", as.character(pid), "-f", "/dev/null"
                )
            )
        } else {
            NULL
        },
        NULL
    )
}

# The helper this session started, if any.
#
# This used to be rediscovered by matching the command line with `pgrep -f`,
# which false-positived on Linux: `.awake_pid()` reported a hold when there was
# none, so `keep_awake(TRUE)` took the "already holding" branch and never
# started anything. Sleep prevention silently did nothing while reporting
# success. Remembering the pid we were handed removes the guesswork -- there is
# no pattern left to mismatch.
.awake_state <- new.env(parent = emptyenv())
.awake_state$pid <- NA_integer_

# `system2(wait = FALSE)` does not report the pid it started, so background the
# helper through the shell and have it tell us. stdin and both output streams
# are detached, otherwise the helper holds the pipe open and `intern = TRUE`
# blocks waiting for an EOF that only arrives when the helper exits.
.awake_spawn <- function(cmd) {
    line <- paste(shQuote(c(cmd$cmd, cmd$args)), collapse = " ")
    out <- suppressWarnings(tryCatch(
        system(paste(line, "</dev/null >/dev/null 2>&1 & echo $!"),
            intern = TRUE
        ),
        error = function(e) character(0)
    ))
    out <- suppressWarnings(as.integer(out))
    out <- out[!is.na(out)]
    if (!length(out)) NA_integer_ else out[[1L]]
}

# A helper that has been killed can linger as a zombie: the pid stays in the
# process table, so signal 0 still reports success, until the parent reaps it.
# Our helpers are orphans -- the shell that started them exits immediately --
# and container inits often do not reap, so liveness has to read the process
# state rather than infer it from the pid existing.
.awake_alive <- function(pid) {
    if (is.na(pid)) return(FALSE)
    state <- suppressWarnings(tryCatch(
        system2("ps", c("-o", "state=", "-p", as.character(pid)),
            stdout = TRUE, stderr = FALSE
        ),
        error = function(e) character(0)
    ))
    state <- trimws(state)
    state <- state[nzchar(state)]
    length(state) > 0L && !startsWith(state[[1L]], "Z")
}

# pid of the helper this session started and that is still running, else NA.
# Reaps the record if the helper has since died, so a stale pid is never
# reported as a live hold.
.awake_pid <- function() {
    if (!.awake_alive(.awake_state$pid)) .awake_state$pid <- NA_integer_
    .awake_state$pid
}

#' @title keep_awake
#' @name keep_awake
#' @description
#' Prevent the machine from going to sleep during a long computation, and allow
#' it again afterwards.
#'
#' This exists because a system sleep is invisible to every in-process
#' measurement. While the machine is asleep wall clock advances and CPU time
#' does not, so a step that spans a sleep appears many times slower while doing
#' identical work: recorded pipeline timings have been inflated 5-14x this way,
#' with CPU-seconds, memory and I/O counters all looking entirely normal.
#'
#' **Nothing in Giotto holds a sleep assertion unless you call `keep_awake()` or
#' [gwith_awake()].** Attaching the package changes no power settings.
#'
#' @param on logical. `TRUE` holds the assertion, `FALSE` releases it.
#' @details
#' Uses `caffeinate` on macOS and `systemd-inhibit` on Linux; on other platforms,
#' or when neither is available, it reports that it cannot help and does nothing.
#' No sleep assertion can outlive the R session: on both platforms the helper is
#' bound to this process and exits with it. For the same reason, sessions running
#' side by side on one machine hold and release independently.
#'
#' Idempotent within a session — calling it repeatedly with `on = TRUE` leaves a
#' single helper. A session only ever tracks and releases the helper it started
#' itself, so it cannot report another session's hold as its own.
#' @section Options:
#' \describe{
#'   \item{`giotto.prevent_sleep`}{when `FALSE`, `keep_awake(TRUE)` and
#'     [gwith_awake()] become no-ops (default `TRUE`). This is a kill switch for
#'     shared machines, cluster nodes and CI, where holding a power assertion is
#'     unwanted; it does **not** cause anything to hold one on its own. It gates
#'     taking an assertion only — `keep_awake(FALSE)` still releases one that is
#'     already held, so setting the option partway through cannot strand it.}
#' }
#' @returns `TRUE` if an assertion is held after the call, otherwise `FALSE`,
#' invisibly
#' @examples
#' \dontrun{
#' keep_awake(TRUE)
#' # ... long pipeline ...
#' keep_awake(FALSE)
#' }
#' @seealso [gwith_awake()] to scope it to a block of code
#' @export
keep_awake <- function(on = TRUE) {
    # the kill switch blocks taking an assertion, never releasing one: setting
    # it after a hold is in place must not strand that hold
    if (isTRUE(on) && !isTRUE(getOption("giotto.prevent_sleep", TRUE))) {
        vmsg(.v = NULL, "keep_awake: disabled by option `giotto.prevent_sleep`")
        return(invisible(FALSE))
    }

    cmd <- .awake_cmd()
    if (is.null(cmd)) {
        vmsg(
            .v = NULL,
            sprintf(
                "keep_awake: no sleep-prevention mechanism on this platform (%s).
                Long runs may be paused by the system.",
                get_os()
            )
        )
        return(invisible(FALSE))
    }

    held <- .awake_pid()

    if (isTRUE(on)) {
        if (!is.na(held)) return(invisible(TRUE)) # already holding
        .awake_state$pid <- .awake_spawn(cmd)
        # a helper that cannot do its job exits at once rather than failing to
        # start, so give it a moment before asking whether it is still alive
        Sys.sleep(0.2)
        ok <- !is.na(.awake_pid())
        if (!ok) {
            warning("keep_awake: could not start ", cmd$cmd, call. = FALSE)
        }
        return(invisible(ok))
    }

    if (!is.na(held)) {
        tools::pskill(held)
        .awake_state$pid <- NA_integer_
    }
    invisible(FALSE)
}
