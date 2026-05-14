# Fread specific rows based on column matches

Deprecated. Do not use

## Usage

``` r
read_colmatch(
  file,
  col,
  sep = NULL,
  values_to_match,
  drop = NULL,
  schema_detect_nrow = 1000,
  col_classes = NULL,
  verbose = FALSE,
  ...
)

fread_colmatch(...)
```

## Arguments

- file:

  path to file to load

- col:

  name of col to match from

- sep:

  grep term to match as column delimiters within the file

- values_to_match:

  values in `col` to match given as a vector

- drop:

  Vector of column names or numbers to drop, keep the rest.

- schema_detect_nrow:

  numeric. how many rows to sample to guess the arrow schema to use.

- col_classes:

  character vector (optional). R types each column is expected to be.
  These will be translated to arrow schema. Only necessary if the schema
  autodetection from `schema_detect_nrow` is insufficient. Select one or
  multiple of "integer", "double", "raw", "character", "logical",
  "Date", "POSIXct"

- verbose:

  be verbose

- ...:

  additional parameters to pass to `arrow::open_delim_dataset()`

## Value

A tibble

## Functions

- `fread_colmatch()`: deprecated.

## Examples

``` r
f <- file.path(tempdir(), "my_file.csv")
x <- data.frame(a = c("a", "b", "c"), b = 1:3, c = 5:7)
write.csv(x, f)
read_colmatch(f, col = "a", values_to_match = c("a", "c"))
#> Error: package 'dplyr' is not yet installed
#> 
#>  To install:
#> install.packages(c("dplyr"))
read_colmatch(f, col = "a", values_to_match = c("a", "c"), drop = c(1, 4))
#> Error: package 'dplyr' is not yet installed
#> 
#>  To install:
#> install.packages(c("dplyr"))
read_colmatch(f, 
    col = "a", values_to_match = c("a", "c"), drop = c("V1", "b")
)
#> Error: package 'dplyr' is not yet installed
#> 
#>  To install:
#> install.packages(c("dplyr"))
unlink(f)
```
