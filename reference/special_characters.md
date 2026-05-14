# Special characters

Framework and functions for printing with special characters within R
packages.

## Usage

``` r
is_latex_output()

is_utf8_output()

box_chars()
```

## Value

boolean

## Details

Much inspiration taken from fs
[tree.R](https://rdrr.io/cran/fs/src/R/tree.R) These are derived from:
[code](https://github.com/r-lib/cli/blob/e9acc82b0d20fa5c64dd529400b622c0338374ed/R/tree.R#L111)

## Functions

- `is_latex_output()`: Determine if print is latex output

- `is_utf8_output()`: Determine if system is using UTF-8 encoding

- `box_chars()`: Helper function to print unicode box characters using
  escape codes.

## Examples

``` r
is_latex_output()
#> [1] FALSE

is_utf8_output()
#> [1] TRUE

box_chars()
#> $h
#> [1] "─"
#> 
#> $v
#> [1] "│"
#> 
#> $l
#> [1] "└"
#> 
#> $j
#> [1] "├"
#> 
#> $b
#> [1] "└──"
#> 
#> $t
#> [1] "├──"
#> 
#> $i
#> [1] "│  "
#> 
#> $s
#> [1] "   "
#> 
```
