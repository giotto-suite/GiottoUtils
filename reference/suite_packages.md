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
#> [1] "GiottoUtils"   "GiottoClass"   "GiottoVisuals" "Giotto"       
suite_packages("core")
#> [1] "GiottoUtils"   "GiottoClass"   "GiottoVisuals" "Giotto"       
suite_packages("extensions")
#> [1] "GiottoData" "GiottoDB"  
suite_packages("all")
#> [1] "GiottoUtils"   "GiottoClass"   "GiottoVisuals" "Giotto"       
#> [5] "GiottoData"    "GiottoDB"     
```
