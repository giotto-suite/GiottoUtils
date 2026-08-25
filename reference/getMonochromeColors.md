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

  :   

## Value

character vector

## See also

Other basic color palette functions:
[`getDistinctColors()`](https://giotto-suite.github.io/GiottoUtils/reference/getDistinctColors.md),
[`getRainbowColors()`](https://giotto-suite.github.io/GiottoUtils/reference/getRainbowColors.md)

## Examples

``` r
getMonochromeColors("green", n = 100)
#>   [1] "#000000" "#000200" "#000500" "#000700" "#000A00" "#000C00" "#000F00"
#>   [8] "#001200" "#001400" "#001700" "#001900" "#001C00" "#001E00" "#002100"
#>  [15] "#002400" "#002600" "#002900" "#002B00" "#002E00" "#003000" "#003300"
#>  [22] "#003600" "#003800" "#003B00" "#003D00" "#004000" "#004200" "#004500"
#>  [29] "#004800" "#004A00" "#004D00" "#004F00" "#005200" "#005500" "#005700"
#>  [36] "#005A00" "#005C00" "#005F00" "#006100" "#006400" "#006700" "#006900"
#>  [43] "#006C00" "#006E00" "#007100" "#007300" "#007600" "#007900" "#007B00"
#>  [50] "#007E00" "#008000" "#008300" "#008500" "#008800" "#008B00" "#008D00"
#>  [57] "#009000" "#009200" "#009500" "#009700" "#009A00" "#009D00" "#009F00"
#>  [64] "#00A200" "#00A400" "#00A700" "#00AA00" "#00AC00" "#00AF00" "#00B100"
#>  [71] "#00B400" "#00B600" "#00B900" "#00BC00" "#00BE00" "#00C100" "#00C300"
#>  [78] "#00C600" "#00C800" "#00CB00" "#00CE00" "#00D000" "#00D300" "#00D500"
#>  [85] "#00D800" "#00DA00" "#00DD00" "#00E000" "#00E200" "#00E500" "#00E700"
#>  [92] "#00EA00" "#00EC00" "#00EF00" "#00F200" "#00F400" "#00F700" "#00F900"
#>  [99] "#00FC00" "#00FF00"
```
