# Test if missing or empty character

Convenient function to test if a character input is NULL, missing, or
has a length of 0 (empty)

## Usage

``` r
is_empty_char(x)
```

## Arguments

- x:

  character vector to test (may be NULL or contain NA values)

## Value

boolean

## Examples

``` r
is_empty_char(NULL)
#> [1] TRUE
is_empty_char(rep("test", 5))
#> [1] FALSE
is_empty_char(c(character(4L), "non-empty")) # example with empty
#>                                         non-empty 
#>      TRUE      TRUE      TRUE      TRUE     FALSE 
is_empty_char(c(NA_character_, "non-na")) # example with NA
#>   <NA> non-na 
#>   TRUE  FALSE 
```
