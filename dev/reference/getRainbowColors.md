# getRainbowColors

Returns a number of rainbow colors spaced around the spectrum. Only 100
unique colors will be supplied after which they are recycled.

## Usage

``` r
getRainbowColors(n, slim = 1, vlim = 1, seed = 1234)
```

## Arguments

- n:

  numeric. Number of colors wanted

- slim:

  numeric. Saturation. If two values are provided, a random uniform
  distribution with the two values as min and max will be used.

- vlim:

  numeric. Value. If two values are provided, a random uniform
  distribution with the two values as min and max will be used.

- seed:

  integer. seed to use when randomizing saturation and value. Default is
  1234.

## Value

character vector of hexadecimal rainbow colors

## See also

Other basic color palette functions:
[`getDistinctColors()`](https://giotto-suite.github.io/GiottoUtils/dev/reference/getDistinctColors.md),
[`getMonochromeColors()`](https://giotto-suite.github.io/GiottoUtils/dev/reference/getMonochromeColors.md)

## Examples

``` r
getRainbowColors(100)
getRainbowColors(10, slim = c(0.5, 1), vlim = c(0.3, 1))
getRainbowColors(10, slim = c(0.5, 1), vlim = c(0.3, 1), seed = 11)
```
