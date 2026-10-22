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
x
```
