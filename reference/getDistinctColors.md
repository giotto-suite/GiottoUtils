# getDistinctColors

Returns a number of distinct colors based on the RGB scale. When fewer
than 444 colors are requested, colors are returned in an order that
maximizes differences. When more than 444 colors are requested, a
recycled sampling of the available colors is returned.

## Usage

``` r
getDistinctColors(n, seed = 1234)
```

## Arguments

- n:

  number of colors wanted

- seed:

  seed to use when randomizing color order. Default is 1234

## Value

character vector of hexadecimal distinct colors

## See also

Other basic color palette functions:
[`getMonochromeColors()`](https://drieslab.github.io/GiottoUtils/reference/getMonochromeColors.md),
[`getRainbowColors()`](https://drieslab.github.io/GiottoUtils/reference/getRainbowColors.md)

## Examples

``` r
getDistinctColors(500)
#> Error: package 'RColorBrewer' is not yet installed
#> 
#>  To install:
#> install.packages(c("RColorBrewer"))
getDistinctColors(500, seed = 1)
#> Error: package 'RColorBrewer' is not yet installed
#> 
#>  To install:
#> install.packages(c("RColorBrewer"))
```
