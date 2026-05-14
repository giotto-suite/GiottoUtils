# Warning handling

Utility to gracefully handle expected warnings

## Usage

``` r
handle_warnings(expr)
```

## Arguments

- expr:

  expression to evaluate

## Value

`list` of "result" which is the output of `expr` and "warnings" which
are any warnings that were generated during eval.

## Examples

``` r
f <- function() {
    warning("this is a warning")
    return(TRUE)
}
handle_warnings(f())
#> $result
#> [1] TRUE
#> 
#> $warnings
#> [1] "this is a warning"
#> 
```
