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
str_locate2(fruit, "a")
str_locate2(fruit, "e")
str_locate2(fruit, c("a", "b", "p", "p"))
```
