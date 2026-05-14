# Set a seed local to a call

When used inside a call, `local_seed()` first records the existing seed
then transiently sets a specific one. When the call exits, the recorded
seed is set again, so that the transient seed setting leaves no
effects.  
Based on discussion from <https://support.bioconductor.org/p/110439/>

## Usage

``` r
local_seed(seed)
```

## Arguments

- seed:

  seed value to set

## Value

set up seed passed to environment

## Examples

``` r
f <- function() {
    local_seed(1234)
    r_val <- rnorm(1)
    return(r_val)
}

rnorm(1) # make sure a seed exists (not needed but handy for this example)
#> [1] -1.400044

seed1 <- .Random.seed
x <- f()
seed2 <- .Random.seed
y <- rnorm(1)
seed3 <- .Random.seed
z <- f()

identical(seed1, seed2)
#> [1] TRUE
!identical(seed1, seed3)
#> [1] TRUE

identical(x, z)
#> [1] TRUE
!identical(x, y)
#> [1] TRUE
```
