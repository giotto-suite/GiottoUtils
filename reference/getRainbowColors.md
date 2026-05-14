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
[`getDistinctColors()`](https://drieslab.github.io/GiottoUtils/reference/getDistinctColors.md),
[`getMonochromeColors()`](https://drieslab.github.io/GiottoUtils/reference/getMonochromeColors.md)

## Examples

``` r
getRainbowColors(100)
#>   [1] "#FF0099" "#FF00A5" "#FF00B2" "#FF00BE" "#FF00CA" "#FF00D7" "#FF00E3"
#>   [8] "#FF00F0" "#FF00FC" "#F600FF" "#E900FF" "#DD00FF" "#D100FF" "#C400FF"
#>  [15] "#B800FF" "#AC00FF" "#9F00FF" "#9300FF" "#8600FF" "#7A00FF" "#6E00FF"
#>  [22] "#6100FF" "#5500FF" "#4900FF" "#3C00FF" "#3000FF" "#2400FF" "#1700FF"
#>  [29] "#0B00FF" "#0002FF" "#000EFF" "#001AFF" "#0027FF" "#0033FF" "#003FFF"
#>  [36] "#004CFF" "#0058FF" "#0064FF" "#0071FF" "#007DFF" "#008AFF" "#0096FF"
#>  [43] "#00A2FF" "#00AFFF" "#00BBFF" "#00C7FF" "#00D4FF" "#00E0FF" "#00ECFF"
#>  [50] "#00F9FF" "#00FFF9" "#00FFEC" "#00FFE0" "#00FFD4" "#00FFC7" "#00FFBB"
#>  [57] "#00FFAF" "#00FFA2" "#00FF96" "#00FF8A" "#00FF7D" "#00FF71" "#00FF64"
#>  [64] "#00FF58" "#00FF4C" "#00FF3F" "#00FF33" "#00FF27" "#00FF1A" "#00FF0E"
#>  [71] "#00FF02" "#0BFF00" "#17FF00" "#24FF00" "#30FF00" "#3CFF00" "#49FF00"
#>  [78] "#55FF00" "#61FF00" "#6EFF00" "#7AFF00" "#86FF00" "#93FF00" "#9FFF00"
#>  [85] "#ACFF00" "#B8FF00" "#C4FF00" "#D1FF00" "#DDFF00" "#E9FF00" "#F6FF00"
#>  [92] "#FFFC00" "#FFF000" "#FFE300" "#FFD700" "#FFCA00" "#FFBE00" "#FFB200"
#>  [99] "#FFA500" "#FF9900"
getRainbowColors(10, slim = c(0.5, 1), vlim = c(0.3, 1))
#>  [1] "#BF197C" "#C00BD1" "#451683" "#1D2387" "#0D65B0" "#15B3B0" "#16E87D"
#>  [8] "#408540" "#95DB54" "#515314"
getRainbowColors(10, slim = c(0.5, 1), vlim = c(0.3, 1), seed = 11)
#>  [1] "#D452A0" "#DD5AE9" "#5C378D" "#151A6E" "#2470B2" "#0B8380" "#78FEB9"
#>  [8] "#39BD3A" "#4A781F" "#64662D"
```
