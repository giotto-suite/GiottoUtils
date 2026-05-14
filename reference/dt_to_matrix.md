# dt_to_matrix

converts `data.table` to `Matrix`

## Usage

``` r
dt_to_matrix(x, chunked = FALSE)
```

## Arguments

- x:

  data.table object

- chunked:

  logical. Whether to chunk the ingestion to `Matrix`

## Value

A `Matrix`

## Details

When matrices are very large, `Matrix::Matrix(x)` and `as(x, "Matrix")`
may throw `Error: vector memory exhausted (limit reached?)`. To get
around this, we chunk the conversion to `Matrix` by chunks of up to
roughly 2e+08 matrix cells.

## Examples

``` r
x <- data.table::data.table(x = c("a", "b", "c"), y = 1:3, z = 5:7)
dt_to_matrix(x)
#> 3 x 2 Matrix of class "dgeMatrix"
#>   y z
#> a 1 5
#> b 2 6
#> c 3 7
dt_to_matrix(x, chunked = TRUE)
#> 3 x 2 Matrix of class "dgeMatrix"
#>   y z
#> a 1 5
#> b 2 6
#> c 3 7
```
