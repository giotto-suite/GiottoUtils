# GiottoUtils

GiottoUtils exports functionalities that are called internally by many
of the other packages in the Giotto ecosystem. These range from things
such as commonly used imports to pretty prints.

A helpful install utility for the rest of the suite modules is also
provided. See
[`suite_install()`](https://drieslab.github.io/GiottoUtils/reference/suite_install.md)

## Installation

You can install GiottoUtils like:

``` r

if (!requireNamespace("pak", quietly = TRUE)) install.packages("pak")
pak::pak("giotto-suite/GiottoUtils")
```

There is also a version of GiottoUtils locked at R version 4.4.0 that
can be installed as following:

``` r

if (!requireNamespace("remotes", quietly = TRUE)) install.packages("remotes")
remotes::install_github("giotto-suite/GiottoUtils@R4.4.0")
```
