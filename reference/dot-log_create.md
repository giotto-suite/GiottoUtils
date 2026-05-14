# Create a log file

Creates a file called 'log.txt' at the specified directory. If no
directory is provided, it defaults to
[`tempdir()`](https://rdrr.io/r/base/tempfile.html), but a specific one
can be provided by setting it to the "giotto.logdir" option or using
[`.log_dir()`](https://drieslab.github.io/GiottoUtils/reference/dot-log_dir.md).
The filepath is additionally written to the option
'giotto.last_logpath'.

## Usage

``` r
.log_create(filedir = getOption("giotto.logdir", tempdir()), filepath = NULL)
```

## Arguments

- filedir:

  character. Directory to create a logfile

- filepath:

  character. Path to logfile. Overrides `filedir`.

## Value

file 'log.txt'
