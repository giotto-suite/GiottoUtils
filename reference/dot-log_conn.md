# Create a logfile connection

Create an active file connection object to the logfile to write to.
Opens it in mode "a+" which allows both appending and reading.

## Usage

``` r
.log_conn(filepath = getOption("giotto.last_logpath", NULL), verbose = TRUE)
```

## Arguments

- filepath:

  path to the logfile

- verbose:

  be verbose about new logfile creation

## Value

file connection
