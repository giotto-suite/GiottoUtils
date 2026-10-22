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
2 %null% 1

"test" %na% 10
NA_character_ %na% "missing"

c() %none% 20
list() %none% "a"
logical(5) %none% 10
```
