# Colorize print text

Return a list of 8 formatting tags for ansi colored text

## Usage

``` r
color_tag()

color_red(x)

color_green(x)

color_yellow(x)

color_blue(x)

color_purple(x)

color_teal(x)

use_color_text()

ansi_colors()

is_emacs_with_color()

emacs_version()
```

## Arguments

- x:

  text to color

## Value

named list of characters

## Details

supported colors checking is modified from cli
[aab-num-ansi-colors.R](https://github.com/r-lib/cli/blob/HEAD/R/num-ansi-colors.R)

## Functions

- `use_color_text()`: Determine if system should print color

- `ansi_colors()`: Determine if system can print at least 8 colors

- `is_emacs_with_color()`: Determine if emacs can print color

- `emacs_version()`: Determine emacs version

## Examples

``` r
color_tag()
#> $r
#> [1] "\033[31m"
#> 
#> $g
#> [1] "\033[32m"
#> 
#> $y
#> [1] "\033[33m"
#> 
#> $b
#> [1] "\033[34m"
#> 
#> $p
#> [1] "\033[35m"
#> 
#> $t
#> [1] "\033[36m"
#> 
#> $x
#> [1] "\033[39m"
#> 

color_red("My text")
#> [1] "\033[31mMy text\033[39m"

color_green("My text")
#> [1] "\033[32mMy text\033[39m"

color_yellow("My text")
#> [1] "\033[33mMy text\033[39m"

color_blue("My text")
#> [1] "\033[34mMy text\033[39m"

color_purple("My text")
#> [1] "\033[35mMy text\033[39m"

color_teal("My text")
#> [1] "\033[36mMy text\033[39m"

use_color_text()
#> [1] TRUE

ansi_colors()
#> [1] 256

is_emacs_with_color()
#> [1] FALSE

emacs_version()
#> [1] NA
```
