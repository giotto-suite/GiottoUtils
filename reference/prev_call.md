# Previous calls

Functions to check the call stack and get aspects of previous calls.
Used in putting together object histories and error handling.

## Usage

``` r
get_prev_call(toplevel = 1L)

get_prev_fname(toplevel = 3L)

get_args(toplevel = 2L, verbose = FALSE)

get_args_list(toplevel = 1L, keep = NULL, ...)
```

## Arguments

- toplevel:

  integer. Relative stack where the function call was made.

- verbose:

  be verbose

- keep:

  character. When NULL, all params are captured. If not NULL, specifies
  which params to capture.

- ...:

  additional params to capture

## Value

character

## Functions

- `get_prev_call()`: Get previous call

- `get_prev_fname()`: Get previous call function name

- `get_args()`: Get previous call args as named character vector

- `get_args_list()`: Get call args as named list

## Examples

``` r
get_prev_call()
#> [1] "eval(expr, envir)"

get_prev_fname(1)
#> [1] "eval"

# preserve params
foo <- function(a, b) get_args(toplevel = 1)
foo(a = 1, b = 2)
#> Error in get(fun, mode = "function", envir = envir): object 'foo' of mode 'function' was not found

bar <- function() get_args() # default toplevel = 2
baz <- function(x, y) bar()
baz("a", "b")
#> Error in get(fun, mode = "function", envir = envir): object 'baz' of mode 'function' was not found
a <- function(x = 1, y = 2, ...) {
    get_args_list(...)
}

a(z = 3, keep = "y")
#> $y
#> [1] 2
#> 
#> $z
#> [1] 3
#> 
```
