# Wrap text

Wrap text

## Usage

``` r
wrap_txt(
  ...,
  sep = " ",
  strWidth = 100,
  errWidth = FALSE,
  .prefix = " ",
  .initial = ""
)

wrap_txtf(
  ...,
  sep = " ",
  strWidth = 100,
  errWidth = FALSE,
  .prefix = " ",
  .initial = ""
)
```

## Arguments

- ...:

  additional params to pass

- sep:

  how to join elements of string (default is one space)

- strWidth:

  externally set wrapping width. (default value of 100 is not effected)

- errWidth:

  default = FALSE. Set strWidth to be compatible with error printout

- .prefix:

  character. prefix for later lines

- .initial:

  character. prefix for first line

## Value

character

## Examples

``` r
cat(wrap_txt("A text"))
#> A text
cat(wrap_txt(
    "Newlines are obeyed.
    The first line is not indented by default.
    later lines are indented by default.

    The text is also wrapped to either a default max width of 100 char
    or the width of the console, whichever is smaller.

    More than one item passed will be concatenated in the same way
    that cat() does."
))
#> Newlines are obeyed.
#>  The first line is not indented by default.
#>  later lines are indented by default.
#> 
#>  The text is also wrapped to either a default max width of 100 char
#>  or the width of the console, whichever is smaller.
#> 
#>  More than one item passed will be concatenated in the same way
#>  that cat() does.

cat(wrap_txtf(
    "This function works the same way as %s, but instead
    of concatenating all elements in the way that %s usually
    does, it uses %s formatting.",
    "wrap_txt()", "cat()", "sprintf()"
))
#> This function works the same way as wrap_txt(), but instead
#>  of concatenating all elements in the way that cat() usually
#>  does, it uses sprintf() formatting.
```
