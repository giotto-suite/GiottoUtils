# Module-specific error message

Send an error message formatted with
[`wrap_txt()`](https://drieslab.github.io/GiottoUtils/reference/wrap_txt.md).
Prepends the Giotto module from which the error was triggered. This
function should not be used directly, but instead an internal `.gstop()`
function should be created using this framework for each module using
it. The `.n` param should be incremented to 2L for this wrapper function

## Usage

``` r
gstop(
  ...,
  sep = " ",
  strWidth = 100,
  errWidth = FALSE,
  .module,
  .prefix = " ",
  .initial = "",
  .n = 1L,
  .call = TRUE,
  .warn_nstack = getOption("giotto.warn_gstop_nstack", FALSE)
)
```

## Arguments

- ...:

  additional strings and/or elements to pass to wrap_msg

- sep:

  how to join elements of string (default is one space)

- strWidth:

  externally set wrapping width. (default value of 100 is not effected)

- errWidth:

  default = FALSE. Set strWidth to be compatible with error printout

- .module:

  character. Giotto module to send the error from

- .prefix:

  character. prefix for later lines

- .initial:

  character. prefix for first line

- .n:

  stack frames back where the error happened

- .call:

  logical, whether to include the call selected through .n as the
  location where the error was. Default is TRUE

- .warn_nstack:

  logical. whether to warn when there are insufficient stackframes for
  requested .n (default = FALSE)

## Value

character message

## Examples

``` r
try(
    gstop("My stop message", .module = "GiottoUtils"),
    silent = TRUE
)
```
