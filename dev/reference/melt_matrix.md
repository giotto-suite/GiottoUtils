# Melt a matrix

Simple implementation of melt for matrices to produces results similar
to that of reshape2's now that it is deprecated.  
The param `na.rm` is not implemented.

## Usage

``` r
melt_matrix(data, varnames = NULL, ..., as.is = FALSE, value.name = "value")
```

## Arguments

- data:

  `matrix` to melt

- varnames:

  variable names to use in molten `data.table`

- ...:

  further arguments passed to or from other methods

- as.is:

  if `FALSE`, dimnames will be converted to factor or integer etc as
  appropriate. If `TRUE`, they will be left as strings.

- value.name:

  name of variable used to store values (default = "value")

## Value

`data.table` in long format

## Examples

``` r
set.seed(9)
Data <- matrix(round(rnorm(12, 10, 4)), nrow = 4, ncol = 3)
melt_matrix(Data)
```
