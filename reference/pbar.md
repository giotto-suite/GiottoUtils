# Create a progressr progress tracker.

Create a progressr progress tracker. This is a wrapper around
[`progressr::progressor()`](https://progressr.futureverse.org/reference/progressor.html).

## Usage

``` r
pbar(
  steps = length(along),
  along = NULL,
  offset = 0L,
  scale = 1L,
  transform = function(steps) scale * steps + offset,
  message = character(0L),
  label = NA_character_,
  trace = FALSE,
  initiate = TRUE,
  finalize = FALSE,
  auto_finish = TRUE,
  on_exit = !identical(envir, globalenv()),
  enable = getOption("progressr.enable", TRUE),
  envir = parent.frame()
)
```

## Arguments

- steps:

  (integer) Number of progressing steps.

- along:

  (vector; alternative) Alternative that sets `steps = length(along)`.

- offset, scale:

  (integer; optional) scale and offset applying transform
  `steps <- scale * steps + offset`.

- transform:

  (function; optional) A function that takes the effective number of
  `steps` as input and returns another finite and non-negative number of
  steps.

- message:

  (character vector or a function) If a character vector, then it is
  pasted together into a single string using an empty separator. If a
  function, then the message is constructed by `conditionMessage(p)`
  calling this function with the progression condition `p` itself as the
  first argument.

- label:

  (character) A label.

- trace:

  (logical) If TRUE, then the call stack is recorded, otherwise not.

- initiate:

  (logical) If TRUE, the progressor will signal a
  [progression](https://progressr.futureverse.org/reference/progression.html)
  'initiate' condition when created.

- finalize:

  (logical) If TRUE, the progressor signals a
  [progression](https://progressr.futureverse.org/reference/progression.html)
  'shutdown' condition when finalized by the garbage collector.

- auto_finish:

  (logical) If TRUE, then the progressor will signal a
  [progression](https://progressr.futureverse.org/reference/progression.html)
  'finish' condition as soon as the last step has been reached.

- on_exit, envir:

  (logical) If TRUE, then the created progressor will signal a
  [progression](https://progressr.futureverse.org/reference/progression.html)
  'finish' condition when the calling frame exits. This is ignored if
  the calling frame (`envir`) is the global environment.

- enable:

  (logical) If TRUE,
  [progression](https://progressr.futureverse.org/reference/progression.html)
  conditions are signaled when calling the progressor function created
  by this function. If FALSE, no
  [progression](https://progressr.futureverse.org/reference/progression.html)
  conditions is signaled because the progressor function is an empty
  function that does nothing.

## Value

a progressr progressor function

## See also

[`with_pbar()`](https://drieslab.github.io/GiottoUtils/reference/with_pbar.md)

## Examples

``` r
a <- function(x = 10) {
    pb <- pbar(steps = x)
}

a <- function(x = seq_len(10)) {
    pb <- pbar(along = x)
}
```
