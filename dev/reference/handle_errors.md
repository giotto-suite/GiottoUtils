# Error handling

Some errors may lock up the console for much longer than they should.
This can often be because R has difficulty figuring out the callstack to
generate the error message. This function is a simple wrapper to set up
a tryCatch evaluation that will return all enclosed errors with the
[`stop()`](https://rdrr.io/r/base/stop.html) arg `call. = FALSE`
setting.

## Usage

``` r
handle_errors(expr, prefix = "")
```

## Arguments

- expr:

  expression to evaluate

- prefix:

  string. An optional prefix to add before the error to help report
  where it was from.

## Value

Throws an error without processing stop calls.

## Examples

``` r
x <- function() {
    handle_errors(stop("this is an error"))
}
if (FALSE) {
    x()
}

y <- function() {
    handle_errors(
        stop("this is an error"),
        prefix = "error location:"
    )
}
if (FALSE) {
    y()
}
```
