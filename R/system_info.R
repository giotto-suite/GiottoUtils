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
# On macOS `caffeinate -w <pid>` releases the assertion when that pid exits, so
# binding it to our own process makes it self-cleaning: the assertion cannot
# outlive the session even if teardown never runs.
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
                    "sleep", "infinity"
                )
            )
        } else {
            NULL
        },
        NULL
    )
}

# pid of a helper we started, or NA. Matched on the full command line, which is
# unambiguous because it embeds our own pid.
.awake_pid <- function(cmd = .awake_cmd()) {
    if (is.null(cmd)) return(NA_integer_)
    pat <- paste(c(cmd$cmd, cmd$args), collapse = " ")
    out <- suppressWarnings(tryCatch(
        system2("pgrep", c("-f", shQuote(pat)), stdout = TRUE, stderr = FALSE),
        error = function(e) character(0)
    ))
    out <- suppressWarnings(as.integer(out))
    out <- out[!is.na(out)]
    if (!length(out)) NA_integer_ else out[[1L]]
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
#' No sleep assertion can outlive the R session: on macOS the helper is bound to
#' this process and exits with it.
#'
#' Idempotent — calling it repeatedly with `on = TRUE` leaves a single helper.
#' @section Options:
#' \describe{
#'   \item{`giotto.prevent_sleep`}{when `FALSE`, `keep_awake()` and
#'     [gwith_awake()] become no-ops (default `TRUE`). This is a kill switch for
#'     shared machines, cluster nodes and CI, where holding a power assertion is
#'     unwanted; it does **not** cause anything to hold one on its own.}
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
    if (!isTRUE(getOption("giotto.prevent_sleep", TRUE))) {
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

    held <- .awake_pid(cmd)

    if (isTRUE(on)) {
        if (!is.na(held)) return(invisible(TRUE)) # already holding
        system2(cmd$cmd, cmd$args, wait = FALSE, stdout = FALSE, stderr = FALSE)
        Sys.sleep(0.2) # let it register before we look for it
        ok <- !is.na(.awake_pid(cmd))
        if (!ok) {
            warning("keep_awake: could not start ", cmd$cmd, call. = FALSE)
        }
        return(invisible(ok))
    }

    if (!is.na(held)) tools::pskill(held)
    invisible(FALSE)
}
