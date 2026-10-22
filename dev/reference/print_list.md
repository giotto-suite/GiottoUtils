# Pretty print formatting for lists and vectors

Pretty print formatting for lists and vectors

## Usage

``` r
print_list(x, pre = "")
```

## Arguments

- x:

  list of items to print. All entries must be named and have
  [`as.character()`](https://rdrr.io/r/base/character.html) methods

- pre:

  character. Optional characters to place at the head of each line

## Value

lists and vectors

## Examples

``` r
print_list(list())
print_list(c())

testvec <- seq(3)
names(testvec) <- LETTERS[seq(3)]
print_list(testvec)

test <- list(
    name1 = "1",
    longername2 = "test_char",
    thirdname = factor("this will be converted with as.character()"),
    df_test = data.frame(a = "a", b = "b"),
    list_test = list(a = 1, b = 2, c = 3),
    formula_test = ~a
)
print_list(test)
print_list(test, pre = "* ")
```
