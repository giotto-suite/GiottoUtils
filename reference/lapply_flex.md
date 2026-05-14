# lapply_flex

lapply_flex

## Usage

``` r
lapply_flex(
  X,
  FUN,
  method = c("future", "biocparallel"),
  cores = NA,
  future.seed = TRUE,
  BPPARAM = NULL,
  fun = NULL,
  ...
)
```

## Arguments

- X:

  list to use

- FUN:

  function to be performed

- method:

  character. Either `"future"` or `"biocparallel"`, determining which
  parallelization framework to use.

- cores:

  deprecated

- future.seed:

  whether to set a seed when using `method = "future"`

- BPPARAM:

  a BiocParallel parameter class deciding how to perform parallelized or
  sequential (default) evaluation. Used with `method = "biocparallel"`

- fun:

  deprecated. Backwards compatibility for FUN

- ...:

  other arguments to pass

## Value

list

## Examples

``` r
lapply_flex(list(x = 1, y = 2), FUN = log)
#> Error: package 'future' is not yet installed
#> 
#>  To install:
#> install.packages(c("future"))

# suppress warnings
options("giotto.warn_sequential" = FALSE)

lapply_flex(list(x = 1, y = 2), FUN = log, method = "future")
#> Error: package 'future' is not yet installed
#> 
#>  To install:
#> install.packages(c("future"))

lapply_flex(list(x = 1, y = 2), FUN = log, method = "biocparallel")
#> Error: package 'BiocParallel' is not yet installed
#> 
#>  To install:
#> if(!requireNamespace('BiocManager', quietly = TRUE)) install.packages('BiocManager');
#> BiocManager::install(c("BiocParallel"))
```
