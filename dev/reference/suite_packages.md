# Giotto Suite Packages

Returns character vector of Giotto Suite's packages. Only the core
packages are returned by default.

## Usage

``` r
suite_packages(type = "core")
```

## Arguments

- type:

  character. Type of module to return. Current choices are `"core"` for
  the packages needed for Giotto to run, `"extensions"` for extending
  packages such as *GiottoData*, and `"all"` for all current modules to
  be returned.

## Value

character

## Examples

``` r
suite_packages()
suite_packages("core")
suite_packages("extensions")
suite_packages("all")
```
