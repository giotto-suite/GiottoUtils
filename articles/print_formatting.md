# Console Printing

## Relevant Options

    options("giotto.verbose")
    options("giotto.logdir")
    options("giotto.last_logpath")

## Overview

Diagnostic prints in R are vital for communicating to both users and
developers what the function is doing and how it may be going wrong.
*GiottoUtils* exports a collection of utility functions that facilitate
pretty printing and readability.

There are several types of console printouts in R. Giotto uses the
following types of functions for specific purposes:  
- [`message()`](https://rdrr.io/r/base/message.html) - Descriptive
messages of what a function is doing (most common)  
- [`cat()`](https://rdrr.io/r/base/cat.html) and
[`print()`](https://rdrr.io/r/base/print.html) - Diagnostic outputs,
usually comments and previews of the data  
- [`warning()`](https://rdrr.io/r/base/warning.html) - When a function
behavior is potentially problematic, given the context and/or inputs  
- [`stop()`](https://rdrr.io/r/base/stop.html) - Error messages

## Text Formatting

[`GiottoUtils::wrap_txt()`](https://drieslab.github.io/GiottoUtils/reference/wrap_txt.md)
can be used to format text to wrap to to console size or 100 char by
default - whichever is less. New lines are treated like “\n” and it also
applies an indent to all lines after the first.  
This function is wrapped by the convenient print functions detailed
below.  

``` r

library(GiottoUtils)
cat(wrap_txt("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."))
```

    ## Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
    ##  incididunt ut labore et dolore magna aliqua.
    ##  Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut
    ##  aliquip ex ea commodo consequat.

You can also use sprintf formatting using `wrap_txtf`

``` r

wrap_txtf("%s morning", "good")
```

    ## [1] "good morning"

See base behavior

Base functions for console prints lack text wrapping. Linebreaks also
require usage of “\n” to be formatted as expected.

``` r

# Code formatting causes "    " to be added the next line
cat("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
    Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.")
```

    ## Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
    ##     Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

``` r

# Using \n instead
cat("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\nUt enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.")
```

    ## Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
    ## Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

## Messages

Giotto primarily uses messages to write helpful console prints. Whenever
a function has a message print, we also encourage adding a `verbose`
param so that it can be turned off. The standard implementation looks
like this.

``` r

test_fun1 <- function(verbose = TRUE) {
    if (verbose) message("hello world")
}

test_fun1()
```

    ## hello world

*GiottoUtils* v0.1.1 introduces
[`vmsg()`](https://drieslab.github.io/GiottoUtils/reference/vmsg.md)
which simplifies this to a single function without a preceding `if`
statement. It also applies text wrapping. Note that the `verbose`
default should be `NULL` with this implementation since
[`vmsg()`](https://drieslab.github.io/GiottoUtils/reference/vmsg.md)
checks for a default using the `"giotto.verbose"` option that can be set
globally.

``` r

test_fun2 <- function(verbose = NULL) {
    vmsg(.v = verbose, "hello world")
}

test_fun2()
```

    ## hello world

### Debug messages

[`vmsg()`](https://drieslab.github.io/GiottoUtils/reference/vmsg.md)
also provides other modes of prints. For debugging purposes, it can be
helpful to include more abstract or wordy printouts such as messages for
every successful step. These can be included by flagging as `"debug"`

``` r

test_debug <- function(verbose = NULL) {
    vmsg(.v = verbose, .is_debug = TRUE, "this is a debug statement")
    vmsg(.v = verbose, "this is a normal message")
}

test_debug(verbose = TRUE)
```

    ## this is a normal message

``` r

test_debug(verbose = "debug")
```

    ## this is a debug statement
    ## this is a normal message

### Logging messages

For cases where a record of the messages would be helpful, but it would
be preferred that nothing is actually printed to the console,
[`vmsg()`](https://drieslab.github.io/GiottoUtils/reference/vmsg.md)
also supports writing to a logfile. This can be done by passing either
`"log"` or `"log_debug"` for the desired level of verbosity to the
`verbose` param or `"giotto.verbose"` option.  
The logfile defaults to being created in
[`tempdir()`](https://rdrr.io/r/base/tempfile.html), but this can be set
to a directory of choice using the `"giotto.logdir"` option. The
specific path to the logfile is stored within the
`"giotto.last_logpath"`.

``` r

vmsg(.v = "log", "Write this to a logfile in tempdir")
```

    ## Logging to:/tmp/RtmpiR6KtR/giotto_20260514_1.txt

To read the log items, use
[`giottoReadLog()`](https://drieslab.github.io/GiottoUtils/reference/giottoReadLog.md).

``` r

giottoReadLog()
```

    ## [1] " (2026-05-14 08:14:19) Write this to a logfile in tempdir"

You can start a new logfile using
[`giottoNewLog()`](https://drieslab.github.io/GiottoUtils/reference/giottoNewLog.md)

## Errors

With the modularization of *Giotto* in v4.0.0, it can be hard to find
which module a specific error came from. `.gstop()` is an error handling
internal function within each of the modules that seeks to solve this.
This function will pre-pend which module the error happened in. It also
provides the `.n` param that allows developers to specify how many
stackframes back the error should be reported from.

``` r

foo <- function(x, y) {
    GiottoUtils:::.gstop("This is an error.")
}

bar <- function() {
    foo(1, 2)
}

bar()
```

    ## Error:
    ## ! [GiottoUtils] foo(1, 2):
    ##  This is an error.

``` r

foo <- function(x, y) {
    GiottoUtils:::.gstop("This is an error.", .n = 2) # report from one stackframe back
}

bar()
```

    ## Error:
    ## ! [GiottoUtils] bar():
    ##  This is an error.

``` r

sessionInfo()
```

    ## R version 4.6.0 (2026-04-24)
    ## Platform: x86_64-pc-linux-gnu
    ## Running under: Ubuntu 24.04.4 LTS
    ## 
    ## Matrix products: default
    ## BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
    ## LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.26.so;  LAPACK version 3.12.0
    ## 
    ## locale:
    ##  [1] LC_CTYPE=C.UTF-8       LC_NUMERIC=C           LC_TIME=C.UTF-8       
    ##  [4] LC_COLLATE=C.UTF-8     LC_MONETARY=C.UTF-8    LC_MESSAGES=C.UTF-8   
    ##  [7] LC_PAPER=C.UTF-8       LC_NAME=C              LC_ADDRESS=C          
    ## [10] LC_TELEPHONE=C         LC_MEASUREMENT=C.UTF-8 LC_IDENTIFICATION=C   
    ## 
    ## time zone: UTC
    ## tzcode source: system (glibc)
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ## [1] GiottoUtils_0.2.5 BiocStyle_2.40.0 
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] vctrs_0.7.3         cli_3.6.6           knitr_1.51         
    ##  [4] rlang_1.2.0         xfun_0.57           textshaping_1.0.5  
    ##  [7] data.table_1.18.4   gtools_3.9.5        jsonlite_2.0.0     
    ## [10] glue_1.8.1          backports_1.5.1     htmltools_0.5.9    
    ## [13] ragg_1.5.2          sass_0.4.10         rmarkdown_2.31     
    ## [16] evaluate_1.0.5      jquerylib_0.1.4     fastmap_1.2.0      
    ## [19] yaml_2.3.12         lifecycle_1.0.5     bookdown_0.46      
    ## [22] BiocManager_1.30.27 compiler_4.6.0      fs_2.1.0           
    ## [25] systemfonts_1.3.2   digest_0.6.39       R6_2.6.1           
    ## [28] pillar_1.11.1       parallel_4.6.0      magrittr_2.0.5     
    ## [31] bslib_0.10.0        checkmate_2.3.4     tools_4.6.0        
    ## [34] pkgdown_2.2.0       cachem_1.1.0        desc_1.4.3
