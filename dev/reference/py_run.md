# Run a Python tool in a worker R session

Runs `fun` in a fresh worker R session (callr) whose Python environment
holds `requirements`, built and cached by uv through
`reticulate::py_require()`. The calling session never starts Python, so
tools with conflicting requirements can run in the same analysis, side
by side, and a crash in Python does not end the calling session. The
first run of a set of requirements says that its environment is being
installed, and how to use an own Python instead.

`py_run_cli()` runs a Python tool's command line program the same way:
the program installed with `requirements` (next to the worker's Python)
is run with `args`.

## Usage

``` r
py_run(
  fun,
  args = list(),
  requirements = character(),
  python_version = NULL,
  isolate = getOption("giotto.py_isolate", TRUE),
  background = FALSE,
  name = NULL,
  python = NULL,
  package = FALSE,
  verbose = FALSE
)

py_result(x)

py_run_cli(
  program,
  args = character(),
  requirements,
  python_version = NULL,
  log_file = NULL,
  name = program,
  ...
)
```

## Arguments

- fun:

  function run in the worker with `args`. By default it must be
  self-contained: its environment is replaced by the worker's global
  environment, so it reaches packages with `::` and gets its data only
  through `args`. The calling session's `giotto.*` options are set in
  the worker.

- args:

  named list of arguments for `fun`. They are copied into the worker;
  pass large data as file paths.

- requirements:

  character. Python packages, as for `reticulate::py_require()` (e.g.
  `"anndata==0.12.6"`).

- python_version:

  character or `NULL`. Python version constraint, as for
  `reticulate::py_require()`.

- isolate:

  logical. `TRUE` (default, option `giotto.py_isolate`) runs in a worker
  session; `FALSE` runs in this session, which then starts Python and
  cannot change its requirements afterwards.

- background:

  logical. Return a
  [`callr::r_bg()`](https://callr.r-lib.org/reference/r_bg.html) process
  instead of waiting; collect the result with `py_result()`.

- name:

  character or `NULL`. The tool's name, used to look up an own Python
  installation in option `giotto.py_python`.

- python:

  character or `NULL`. Path of a Python executable to use instead of a
  uv environment (its packages are then the user's own responsibility).
  `NULL` (default) uses option `giotto.py_python`, either one path for
  every tool or a named list of paths per tool (`name`), and otherwise a
  uv environment.

- package:

  logical. `TRUE` keeps the namespace of a `fun` defined in a package
  (as for [`callr::r()`](https://callr.r-lib.org/reference/r.html)): the
  worker loads that package, and `fun` can use its internal functions
  and imports. Loading a package also loads its dependencies;
  data.table's OpenMP runtime, for example, crashes PyTorch, so tools
  built on PyTorch keep the default `FALSE`.

- verbose:

  show the worker's output

- x:

  a process returned by `py_run(background = TRUE)`

- program:

  character. Name of the command line program.

- log_file:

  character or `NULL`. File for the program's output; when it fails, the
  error shows the end of this file. `NULL` sends the output to the
  worker's console (shown with `verbose = TRUE`).

- ...:

  further arguments for `py_run()`

## Value

The value of `fun`, with attribute `"py_versions"`: the Python version
and the installed version of each requirement. With `background = TRUE`,
a `callr` process.

## Examples

``` r
if (FALSE) { # \dontrun{
res <- py_run(
    function(n) reticulate::import("numpy")$arange(n),
    args = list(n = 5L), requirements = "numpy"
)
attr(res, "py_versions")
} # }
```
