# Set if

Set a default value if a test is true.

## Usage

``` r
x %null% y

x %na% y

x %none% y
```

## Arguments

- x:

  object to test

- y:

  default value to set

## Value

if `x` tests `TRUE`, `y` is returned if `x` tests `FALSE` `x` is
returned

## Examples

``` r
NULL %null% 1
#> [1] 1
2 %null% 1
#> [1] 2

"test" %na% 10
#> [1] "test"
NA_character_ %na% "missing"
#> [1] "missing"

c() %none% 20
#> [1] 20
list() %none% "a"
#> [1] "a"
logical(5) %none% 10
#> [1] FALSE FALSE FALSE FALSE FALSE
```
