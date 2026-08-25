# Read from the last generated log file

Read from the last generated log file

## Usage

``` r
giottoReadLog(filepath = getOption("giotto.last_logpath", NULL))
```

## Arguments

- filepath:

  character. filepath to log file. If omitted, tries to find the last
  created log (will not work after a crash)

## Value

character

## Examples

``` r
log_write(x = "my content")
giottoReadLog()
#> [1] " (2026-08-25 02:43:54) my content"
```
