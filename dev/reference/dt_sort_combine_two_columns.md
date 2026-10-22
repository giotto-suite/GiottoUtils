# dt_sort_combine_two_columns

fast sorting and pasting of 2 character columns in a data.table

## Usage

``` r
dt_sort_combine_two_columns(DT, column1, column2, myname = "unif_gene_gene")
```

## Arguments

- DT:

  datatable

- column1:

  column1 to use

- column2:

  column2 to use

- myname:

  name of combined column to generate

## Value

A data.table

## Examples

``` r
x <- data.table::data.table(x = 1:3, y = 5:7)
dt_sort_combine_two_columns(x, column1 = "x", column2 = "y")
x
```
