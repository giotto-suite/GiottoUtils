# Find location of match in string

Implementation of stringr's `str_locate` with base R.

## Usage

``` r
str_locate2(string, pattern)
```

## Arguments

- string:

  Input vector. Either a character vector, or something coercible to
  one.

- pattern:

  Pattern to look for.

## Value

integer matrix with two columns and one row for each element of string.
The first column, start, gives the position at the start of the match,
and the second column, end, gives the position of the end.

## Examples

``` r
fruit <- c("apple", "banana", "pear", "pineapple")
str_locate2(fruit, "$")
#>      start end
#> [1,]     6   5
#> [2,]     7   6
#> [3,]     5   4
#> [4,]    10   9
str_locate2(fruit, "a")
#>      start end
#> [1,]     1   1
#> [2,]     2   2
#> [3,]     3   3
#> [4,]     5   5
str_locate2(fruit, "e")
#>      start end
#> [1,]     5   5
#> [2,]    NA  NA
#> [3,]     2   2
#> [4,]     4   4
str_locate2(fruit, c("a", "b", "p", "p"))
#>      start end
#> [1,]     1   1
#> [2,]     1   1
#> [3,]     1   1
#> [4,]     1   1
```
