# Partial matching of character choices

Given an arg to match to, tries to partially match to the provided
character vector of choices. Matching ignores case and returns the first
match.

## Usage

``` r
g_match_arg(arg, choices, ...)
```

## Arguments

- arg:

  character. Argument to match

- choices:

  character vector of choices to match to

- ...:

  additional params passed to grep

## Value

character

## Examples

``` r
g_match_arg("raw", choices = c("raw", "normalized"))
#> [1] "raw"
```
