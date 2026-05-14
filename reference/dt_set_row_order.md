# Set specific data.table row order

Set specific data.table row order

## Usage

``` r
dt_set_row_order(x, neworder)
```

## Arguments

- x:

  data.table

- neworder:

  numerical vector to reorder rows

## Value

A data.table

## Examples

``` r
x <- data.table::data.table(x = c("a", "b", "c"), y = 1:3, z = 5:7)
dt_set_row_order(x, neworder = c(1, 3, 2))
#>         x     y     z
#>    <char> <int> <int>
#> 1:      a     1     5
#> 2:      c     3     7
#> 3:      b     2     6
x
#>         x     y     z
#>    <char> <int> <int>
#> 1:      a     1     5
#> 2:      c     3     7
#> 3:      b     2     6
```
