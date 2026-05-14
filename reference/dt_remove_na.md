# dt_remove_na

set NA values to 0 in a data.table object

## Usage

``` r
dt_remove_na(DT)
```

## Arguments

- DT:

  datatable

## Value

A data.table

## Examples

``` r
x <- data.table::data.table(x = 1:3, y = c(1, NA, 2))
dt_remove_na(x)
#>        x     y
#>    <int> <num>
#> 1:     1     1
#> 2:     2     0
#> 3:     3     2
x
#>        x     y
#>    <int> <num>
#> 1:     1     1
#> 2:     2     0
#> 3:     3     2
```
