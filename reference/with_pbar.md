# Track progress while evaluating an R expression

Track progress while evaluating an R expression. This is a wrapper
around
[`progressr::with_progress()`](https://progressr.futureverse.org/reference/with_progress.html).
progressr is useful because it handles progress reporting in parallel
contexts. However, it is worth noting that Giotto does not adhere to
progressr's guideline that `with_progress()` should not be used within
packages. The default behavior of displaying progress is more convenient
for end users of packages with many functions. This implementation may
shift over time.

## Usage

``` r
with_pbar(
  expr,
  handlers = progressr::handlers(),
  cleanup = TRUE,
  delay_terminal = NULL,
  delay_stdout = NULL,
  delay_conditions = NULL,
  interrupts = getOption("progressr.interrupts", TRUE),
  interval = NULL,
  enable = NULL
)
```

## Arguments

- expr:

  An R expression to evaluate.

- handlers:

  A progression handler or a list of them. If NULL or an empty list,
  progress updates are ignored.

- cleanup:

  If TRUE, all progression handlers will be shutdown at the end
  regardless of the progression is complete or not.

- delay_terminal:

  If TRUE, output and conditions that may end up in the terminal will
  delayed.

- delay_stdout:

  If TRUE, standard output is captured and relayed at the end just
  before any captured conditions are relayed.

- delay_conditions:

  A character vector specifying
  [base::condition](https://rdrr.io/r/base/conditions.html) classes to
  be captured and relayed at the end after any captured standard output
  is relayed.

- interrupts:

  Controls whether interrupts should be detected or not. If TRUE and a
  interrupt is signaled, progress handlers are asked to report on the
  current amount progress when the evaluation was terminated by the
  interrupt, e.g. when a user pressed Ctrl-C in an interactive session,
  or a batch process was interrupted because it ran out of time. Note
  that it's optional for a progress handler to support this and only
  some do.

- interval:

  (numeric) The minimum time (in seconds) between successive progression
  updates from handlers.

- enable:

  (logical) If FALSE, then progress is not reported. The default is to
  report progress in interactive mode but not batch mode. See below for
  more details.

## Value

the result of the evaluated code

## See also

[`pbar()`](https://drieslab.github.io/GiottoUtils/reference/pbar.md)

## Examples

``` r
a <- function(x = 10) {
    with_pbar({
        pb <- pbar(x)
        for (i in seq_len(x)) {
            Sys.sleep(0.1)
            pb()
        }
    })
}

a()
```
