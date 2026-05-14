# determine_cores

guesses how many cores to use

## Usage

``` r
determine_cores(
  cores = getOption("giotto.cores", default = NA),
  min_cores = 1,
  max_cores = 10
)
```

## Value

numeric

## Examples

``` r
determine_cores()
#> [1] 2
```
