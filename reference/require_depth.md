# Coerce to AT LEAST specified nesting depth

Coerce to AT LEAST specified nesting depth

## Usage

``` r
require_depth(x, dnames = NULL, min_depth = 1L, count = 1L)
```

## Arguments

- x:

  object to evaluate

- dnames:

  character. vector of names to apply per depth level if not already
  named the name entries should match the depth they are intended for.
  NULL values

- min_depth:

  required minimum nesting depth are ignored.

- count:

  do not use

## Value

list

## Examples

``` r
x <- list(a = 1)
require_depth(x, min_depth = 2L)
#> [[1]]
#> [[1]]$a
#> [1] 1
#> 
#> 
```
