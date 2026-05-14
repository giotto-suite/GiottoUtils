# Find depth of subnesting

Recursively determines how many max or min layers of subnesting there
is, with the end object (defined by param sig or a list of length 0)
being layer 0

## Usage

``` r
depth(this, method = c("max", "min"), sig = "data.frame")
```

## Arguments

- this:

  object to evaluate

- method:

  max (default) or min nesting to detect

- sig:

  signature or class to check for. Default is 'data.frame'

## Value

numeric

## Details

https://stackoverflow.com/questions/13432863/

## Examples

``` r
x <- list(a = 1)
depth(x)
#> [1] 1
```
