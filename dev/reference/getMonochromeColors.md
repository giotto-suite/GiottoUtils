# Create color scaling for a single color starting from black

Create color scaling for a single color starting from black

## Usage

``` r
getMonochromeColors(col, n = 256L, ...)
```

## Arguments

- col:

  hexadecimal color to scale scale towards

- n:

  number of colors to request in monochrome palette

- ...:

  Arguments passed on to
  [`grDevices::colorRampPalette`](https://rdrr.io/r/grDevices/colorRamp.html)

  `bias`

  :   a positive number. Higher values give more widely spaced colors at
      the high end.

  `space`

  :   a character string; interpolation in RGB or Lab color spaces.

  `interpolate`

  :   use spline or linear interpolation.

  `alpha`

  :   logical: should alpha channel (opacity) values be returned? It is
      an error to give a true value if `space` is specified.

## Value

character vector

## See also

Other basic color palette functions:
[`getDistinctColors()`](https://giotto-suite.github.io/GiottoUtils/dev/reference/getDistinctColors.md),
[`getRainbowColors()`](https://giotto-suite.github.io/GiottoUtils/dev/reference/getRainbowColors.md)

## Examples

``` r
getMonochromeColors("green", n = 100)
```
