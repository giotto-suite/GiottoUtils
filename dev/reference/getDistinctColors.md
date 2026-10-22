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
[`getMonochromeColors()`](https://giotto-suite.github.io/GiottoUtils/dev/reference/getMonochromeColors.md),
[`getRainbowColors()`](https://giotto-suite.github.io/GiottoUtils/dev/reference/getRainbowColors.md)

## Examples

``` r
getDistinctColors(500)
getDistinctColors(500, seed = 1)
```
