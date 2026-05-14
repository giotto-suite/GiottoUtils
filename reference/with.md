# With utilities

Simple *with* functions. Similar to or from withr implementations.

## Usage

``` r
gwith_options(new, code)

gwith_package(package, code, pos = 2L)

gwith_seed(seed = 1234, code, ..., substitute = TRUE, envir = parent.frame())
```

## Arguments

- new:

  new option to set and its value

- code:

  R code to execute with temporary settings

- package:

  character. The name of a package

- pos:

  integer. position in search to attach at. Default = 2

- seed:

  numeric. seed to set

- ...:

  additional params to pass. See details.

- substitute:

  If [`TRUE`](https://rdrr.io/r/base/logical.html), argument `expr` is
  [`substitute()`](https://rdrr.io/r/base/substitute.html):ed, otherwise
  not.

- envir:

  The [`environment`](https://rdrr.io/r/base/environment.html) in which
  the expression should be evaluated.

## Value

the evaluated value of `code`

## Details

`gwith_seed()` : `...` passes to
[`set.seed()`](https://rdrr.io/r/base/Random.html)

## Functions

- `gwith_options()`: Eval with temporary option setting

- `gwith_package()`: Eval with temporarily attached package

- `gwith_seed()`: Eval with temporary specifiable seed

## Examples

``` r
# options ###################################
gwith_options(list(gutils.temp = "found"), {
    print(getOption("gutils.temp", default = "not_found"))
})
#> [1] "found"
getOption("gutils.temp", default = "not_found")
#> [1] "not_found"

# packages ##################################
# temporarily attach at end of search (right before "base")
gwith_package("data.table", print(search()), pos = length(search()))
#>  [1] ".GlobalEnv"          "package:GiottoUtils" "package:stats"      
#>  [4] "package:graphics"    "package:grDevices"   "package:utils"      
#>  [7] "package:datasets"    "package:methods"     "Autoloads"          
#> [10] "package:data.table"  "package:base"       
search()
#>  [1] ".GlobalEnv"          "package:GiottoUtils" "package:stats"      
#>  [4] "package:graphics"    "package:grDevices"   "package:utils"      
#>  [7] "package:datasets"    "package:methods"     "Autoloads"          
#> [10] "package:base"       

# seed  #####################################
start_seed <- .Random.seed

# identical generation
a <- gwith_seed(runif(10), seed = 1234)
b <- gwith_seed(runif(10), seed = 1234)
identical(a, b)
#> [1] TRUE

# does not alter pre-existing seed
end_seed <- .Random.seed
identical(start_seed, end_seed)
#> [1] TRUE
```
