# String convenience functions

String convenience functions

## Usage

``` r
str_vector(x, qchar = c("single", "double"))

str_bracket(x)

str_parenth(x)

str_double_quote(x)

str_quote(x)

str_reformat(x, ...)
```

## Arguments

- x:

  string item(s) to format

- qchar:

  quote character to use. Either 'single' or "double"

- ...:

  additional params to pass to
  [`strwrap()`](https://rdrr.io/r/base/strwrap.html)

## Value

character

## Functions

- `str_vector()`: Format a vector of values into 'a', 'b', 'c' or "a",
  "b", "c" depending on `qchar` via
  [`toString()`](https://rdrr.io/r/base/toString.html)

- `str_reformat()`: capture and reformat a print with
  [`strwrap()`](https://rdrr.io/r/base/strwrap.html)

## Examples

``` r
x <- "test"
cat(str_bracket(x), "\n")
#> [test] 
cat(str_parenth(x), "\n")
#> (test) 
cat(str_double_quote(x), "\n")
#> "test" 
cat(str_quote(x), "\n")
#> 'test' 
# format a set of character values with str_vector()
vec <- c("item1", "item2", "item3")
cat(str_vector(vec)) # single quote (default)
#> 'item1', 'item2', 'item3'
cat(str_vector(vec, qchar = "double")) # double quote
#> "item1", "item2", "item3"
# print post-processing with str_reformat()
txt <- "hello
        world"
cat(str_reformat(cat(txt), indent = 3))
#>    hello
#>    world
```
