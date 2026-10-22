# Create a new Giotto log

Create a new Giotto log

## Usage

``` r
giottoNewLog(logdir)
```

## Arguments

- logdir:

  (optional) specific directory in which to generate logfiles. If not
  provided, will choose a directory based on
  `getOption("giotto.logdir", tempdir())`

## Value

a log file

## Examples

``` r
giottoNewLog("my_log_directory")
```
