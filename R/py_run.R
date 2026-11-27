#' @title Run a Python tool in a worker R session
#' @name py_run
#' @description
#' Runs `fun` in a fresh worker R session (callr) whose Python environment
#' holds `requirements`, built and cached by uv through
#' [reticulate::py_require()]. The calling session never starts Python, so
#' tools with conflicting requirements can run in the same analysis, side by
#' side, and a crash in Python does not end the calling session.
#' The first run of a set of requirements says that its environment is
#' being installed, and how to use an own Python instead.
#' @param fun function run in the worker with `args`. By default it must be
#'   self-contained: its environment is replaced by the worker's global
#'   environment, so it reaches packages with `::` and gets its data only
#'   through `args`. The calling session's `giotto.*` options are set in the
#'   worker.
#' @param package logical. `TRUE` keeps the namespace of a `fun` defined in a
#'   package (as for [callr::r()]): the worker loads that package, and `fun`
#'   can use its internal functions and imports. Loading a package also loads
#'   its dependencies; data.table's OpenMP runtime, for example, crashes
#'   PyTorch, so tools built on PyTorch keep the default `FALSE`.
#' @param args named list of arguments for `fun`. They are copied into the
#'   worker; pass large data as file paths.
#' @param requirements character. Python packages, as for
#'   [reticulate::py_require()] (e.g. `"anndata==0.12.6"`).
#' @param python_version character or `NULL`. Python version constraint, as
#'   for [reticulate::py_require()].
#' @param isolate logical. `TRUE` (default, option `giotto.py_isolate`) runs
#'   in a worker session; `FALSE` runs in this session, which then starts
#'   Python and cannot change its requirements afterwards.
#' @param background logical. Return a [callr::r_bg()] process instead of
#'   waiting; collect the result with [py_result()].
#' @param name character or `NULL`. The tool's name, used to look up an own
#'   Python installation in option `giotto.py_python`.
#' @param python character or `NULL`. Path of a Python executable to use
#'   instead of a uv environment (its packages are then the user's own
#'   responsibility). `NULL` (default) uses option `giotto.py_python`, either
#'   one path for every tool or a named list of paths per tool (`name`), and
#'   otherwise a uv environment.
#' @param verbose show the worker's output
#' @returns The value of `fun`, with attribute `"py_versions"`: the Python
#'   version and the installed version of each requirement. With
#'   `background = TRUE`, a `callr` process.
#' @examples
#' \dontrun{
#' res <- py_run(
#'     function(n) reticulate::import("numpy")$arange(n),
#'     args = list(n = 5L), requirements = "numpy"
#' )
#' attr(res, "py_versions")
#' }
#' @export
py_run <- function(fun, args = list(), requirements = character(),
    python_version = NULL, isolate = getOption("giotto.py_isolate", TRUE),
    background = FALSE, name = NULL, python = NULL, package = FALSE,
    verbose = FALSE) {
    checkmate::assert_function(fun)
    checkmate::assert_list(args)
    checkmate::assert_character(requirements, any.missing = FALSE)
    checkmate::assert_string(python_version, null.ok = TRUE)
    package_check("reticulate", repository = "CRAN")
    if (utils::packageVersion("reticulate") < "1.41") {
        stop("[py_run] reticulate >= 1.41 is needed (py_require())",
            call. = FALSE)
    }
    # a namespace is serialized by name and loaded in the worker; any other
    # environment would be copied along with the function
    if (!(isTRUE(package) && isNamespace(environment(fun)))) {
        environment(fun) <- globalenv()
    }
    task <- .py_run_task
    environment(task) <- globalenv()
    python <- python %null% .py_user_python(name)
    checkmate::assert_string(python, null.ok = TRUE)
    opts <- options()
    targs <- list(fun = fun, args = args, requirements = requirements,
        python_version = python_version, python = python,
        options = opts[startsWith(names(opts), "giotto.")])

    if (!isTRUE(isolate) && isTRUE(background)) {
        stop("[py_run] background = TRUE needs isolate = TRUE", call. = FALSE)
    }
    first_use <- is.null(python) &&
        .py_first_use(requirements, python_version, name)

    if (!isTRUE(isolate)) {
        out <- do.call(task, targs)
    } else {
        package_check("callr", repository = "CRAN")
        if (isTRUE(background)) {
            proc <- callr::r_bg(task, args = targs, package = FALSE,
                supervise = TRUE)
            if (first_use) .py_mark_used(requirements, python_version)
            return(proc)
        }
        out <- .py_run_rethrow(callr::r(task, args = targs, package = FALSE,
            show = isTRUE(verbose)))
    }
    if (first_use) .py_mark_used(requirements, python_version)
    .py_run_unwrap(out)
}

#' @rdname py_run
#' @param x a process returned by `py_run(background = TRUE)`
#' @export
py_result <- function(x) {
    x$wait()
    .py_run_unwrap(.py_run_rethrow(x$get_result()))
}

#' @rdname py_run
#' @description
#' `py_run_cli()` runs a Python tool's command line program the same way: the
#' program installed with `requirements` (next to the worker's Python) is
#' run with `args`.
#' @param program character. Name of the command line program.
#' @param log_file character or `NULL`. File for the program's output; when it
#'   fails, the error shows the end of this file. `NULL` sends the output to
#'   the worker's console (shown with `verbose = TRUE`).
#' @param ... further arguments for `py_run()`
#' @export
py_run_cli <- function(program, args = character(), requirements,
    python_version = NULL, log_file = NULL, name = program, ...) {
    checkmate::assert_string(program)
    checkmate::assert_string(log_file, null.ok = TRUE)
    py_run(.py_cli_worker,
        args = list(program = program, args = as.character(args),
            log_file = log_file),
        requirements = requirements, python_version = python_version,
        name = name, ...)
}

# Runs in the worker, self-contained: the program sits next to the worker's
# Python (or in Scripts/ of a conda environment on Windows).
.py_cli_worker <- function(program, args, log_file = NULL) {
    bin <- dirname(reticulate::py_exe())
    exe <- if (.Platform$OS.type == "windows") paste0(program, ".exe") else
        program
    cand <- file.path(c(bin, file.path(bin, "Scripts")), exe)
    exe <- cand[file.exists(cand)][1L]
    if (is.na(exe)) {
        stop("program '", program, "' not found next to ",
            reticulate::py_exe(), call. = FALSE)
    }
    out <- if (is.null(log_file)) "" else log_file
    status <- system2(exe, shQuote(args), stdout = out, stderr = out)
    if (!identical(as.integer(status), 0L)) {
        tail_log <- if (!is.null(log_file) && file.exists(log_file)) {
            paste0(":\n", paste(utils::tail(readLines(log_file, warn = FALSE),
                15L), collapse = "\n"))
        }
        stop(program, " failed (status ", status, ")", tail_log, call. = FALSE)
    }
    TRUE
}

# a worker's error as one plain error in the calling session
.py_run_rethrow <- function(expr) {
    tryCatch(expr, callr_error = function(e) {
        msg <- if (!is.null(e$parent)) conditionMessage(e$parent) else
            conditionMessage(e)
        stop("[py_run] the Python worker failed: ", msg, call. = FALSE)
    })
}

# First use of a set of requirements on this machine: say that its
# environment is being installed, and how to use an own Python instead.
# Recorded per set of requirements in the user cache directory.
.py_used_file <- function(requirements, python_version) {
    key <- paste(c(sort(requirements), python_version), collapse = " ")
    f <- tempfile()
    on.exit(unlink(f))
    writeLines(key, f)
    file.path(tools::R_user_dir("GiottoUtils", "cache"), "py_run",
        unname(tools::md5sum(f)))
}

.py_first_use <- function(requirements, python_version, name = NULL) {
    if (!length(requirements) && is.null(python_version)) return(FALSE)
    used <- tryCatch(file.exists(.py_used_file(requirements, python_version)),
        error = function(e) TRUE)
    if (used) return(FALSE)
    tool <- name %null% paste(requirements, collapse = ", ")
    own <- if (is.null(name)) {
        "options(giotto.py_python = \"/path/to/python\")"
    } else {
        sprintf("options(giotto.py_python = list(%s = \"/path/to/python\"))",
            if (make.names(name) == name) name else sprintf("`%s`", name))
    }
    message(sprintf(paste0(
        "Installing the Python environment for %s (first use only).\n",
        "This needs internet and can take a few minutes; later runs reuse it.\n",
        "To use your own Python installation instead:\n  %s"), tool, own))
    TRUE
}

.py_mark_used <- function(requirements, python_version) {
    try({
        f <- .py_used_file(requirements, python_version)
        dir.create(dirname(f), recursive = TRUE, showWarnings = FALSE)
        writeLines(paste(requirements, collapse = "\n"), f)
    }, silent = TRUE)
    invisible()
}

# The user's own Python for a tool, from option giotto.py_python: one path,
# or a named list of paths per tool.
.py_user_python <- function(name = NULL) {
    opt <- getOption("giotto.py_python")
    if (is.null(opt)) return(NULL)
    if (is.character(opt) && length(opt) == 1L && is.null(names(opt))) {
        return(opt)
    }
    if (is.null(name)) return(NULL)
    p <- opt[[name]]
    if (is.null(p)) NULL else as.character(p)
}

# Runs in the worker (or in this session with isolate = FALSE): use the
# user's own Python or declare the requirements, run the tool, report the
# versions that were used.
.py_run_task <- function(fun, args, requirements, python_version,
    python = NULL, options = list()) {
    options(options)
    if (!is.null(python)) {
        reticulate::use_python(python, required = TRUE)
    } else if (length(requirements) || !is.null(python_version)) {
        reticulate::py_require(requirements, python_version = python_version)
    }
    # start Python now, so command line tools find their program next to
    # reticulate::py_exe()
    tryCatch(invisible(reticulate::py_config()), error = function(e) {
        stop("no Python environment could be made for ",
            paste(requirements, collapse = ", "),
            if (!is.null(python_version)) paste0(" (Python ", python_version,
                ")"), " on this platform: ", conditionMessage(e),
            call. = FALSE)
    })
    # a Python error holds Python objects that cannot be sent back to the
    # calling session: rethrow it as a plain R error
    value <- tryCatch(do.call(fun, args), error = function(e) {
        msg <- conditionMessage(e)
        if (!is.null(python) && grepl("ModuleNotFoundError", msg)) {
            msg <- paste0(msg, "\nThis tool uses your own Python (", python,
                "); install the module there: ",
                paste(requirements, collapse = " "))
        } else if (nzchar(Sys.getenv("UV_OFFLINE")) &&
            grepl("Python bindings not loaded|not found", msg)) {
            msg <- paste0("UV_OFFLINE is set and the uv cache does not hold ",
                paste(requirements, collapse = " "), ". Install them once ",
                "with internet (e.g. on a login node), then run offline.")
        }
        stop(msg, call. = FALSE)
    })
    versions <- character()
    if (reticulate::py_available(initialize = FALSE)) {
        md <- reticulate::import("importlib.metadata")
        dists <- unique(sub("[<>=!~;\\[ ].*$", "", requirements))
        versions <- vapply(dists, function(d) {
            tryCatch(md$version(d), error = function(e) NA_character_)
        }, character(1L))
        versions <- c(python = as.character(reticulate::py_config()$version), versions)
    }
    list(value = value, versions = versions)
}

.py_run_unwrap <- function(out) {
    value <- out$value
    if (!is.null(value)) {
        value <- tryCatch({
            attr(value, "py_versions") <- out$versions
            value
        }, error = function(e) value)
    }
    value
}
