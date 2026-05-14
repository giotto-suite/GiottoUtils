# Abbreviate a string

Abbreviates a string in the format of `head`\[...\]`tail` when it
exceeds the length specified by `width`. Useful for shortening how
filepaths are displayed.

## Usage

``` r
str_abbreviate(string, width = 60L, head = 15L, tail = 35L)
```

## Arguments

- string:

  character. Input string

- width:

  numeric. Strings longer than this many characters will be abbreviated

- head:

  numeric. Number of characters to include before abbreviated section

- tail:

  numeric. Number of characters to include after abbreviated section

## Value

character

## Examples

``` r
a <- "/short/file/path/"
b <- "/much/longer/foooooooooooooooooooo/baaaaaaaaaaaaaaaaaaaar/file/path/"
str_abbreviate(c(a, b))
#> [1] "/short/file/path/"                                       
#> [2] "/much/longer/fo[...]oo/baaaaaaaaaaaaaaaaaaaar/file/path/"
str_abbreviate(c(a, b), width = 10, head = 3, tail = 3)
#> [1] "/sh[...]ath/" "/mu[...]ath/"
```
