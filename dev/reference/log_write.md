# Write to log file

Write to log file

## Usage

``` r
log_write(file_conn = .log_conn(), x = "", collapse = " ", main = NULL)
```

## Arguments

- file_conn:

  a file connection (Uses last created or generates a new one if
  previous does not exist.)

- x:

  character vector. Content to write

- collapse:

  character. Collapse to use with `x`

- main:

  character. Title to assign log entry

## Value

character

## Examples

``` r
log_write(x = "my content")
```
