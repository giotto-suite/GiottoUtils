# Initialize an option

Set an option only if it does not exist yet.

## Usage

``` r
init_option(x, value)
```

## Arguments

- x:

  character. Option to initialize

- value:

  value to set

## Value

NULL invisibly

## Examples

``` r
init_option("dummy_option", 2)
init_option("dummy_option", 5)
getOption("dummy_option") # still 2
#> [1] 2
```
