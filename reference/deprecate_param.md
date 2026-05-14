# Deprecate a parameter

Accepts the directly passed deprecated and superceding params and Sends
a deprecation message if the deprecated param was used. This function
wraps
[`lifecycle::deprecate_warn()`](https://lifecycle.r-lib.org/reference/deprecate_soft.html)
to make a standard param deprecation message. It then outputs the final
value to be used.

## Usage

``` r
deprecate_param(
  x,
  y,
  fun,
  when,
  check = c("deprecated", "null"),
  always = FALSE
)
```

## Arguments

- x:

  name. Deprecated param

- y:

  name. Superceding param

- fun:

  character. Name of function

- when:

  character. Version number in which the deprecation happened.

- check:

  character. Method to check if deprecated param was used

- always:

  If FALSE, the default, will warn every 8 hours. If TRUE, will always
  warn in direct usages. Indirect usages keep warning every 8 hours to
  avoid disrupting users who can't fix the issue. Only use always = TRUE
  after at least one release with the default.

## Value

final value to be used

## Examples

``` r
foo <- function(dep = deprecated(), sup = 10) {
    sup <- deprecate_param(
        dep, sup,
        fun = "foo", when = "0.0.1"
    )
    return(sup)
}

foo() # following defaults, no deprecation message
#> [1] 10
foo(sup = 3) # no deprecation message triggered
#> [1] 3
foo(dep = 3) # deprecation message triggered
#> Warning: The `dep` argument of `foo()` is deprecated as of <NA> 0.0.1.
#> ℹ Please use the `sup` argument instead.
#> ℹ The deprecated feature was likely used in the base package.
#>   Please report the issue to the authors.
#> [1] 3

# convenient nested function when deprecating multiple params
bar <- function(dep1 = deprecated(),
    dep2 = deprecated(),
    sup1 = 10,
    sup2 = 20) {
    # internally defined function that streamlines downstream deprecations
    .dep <- function(...) {
        deprecate_param(..., fun = "bar", when = "0.0.2")
    }

    sup1 <- .dep(dep1, sup1)
    sup2 <- .dep(dep2, sup2)

    return(list(sup1, sup2))
}

bar(sup1 = 100)
#> [[1]]
#> [1] 100
#> 
#> [[2]]
#> [1] 20
#> 
bar(dep1 = 100, dep2 = "hello")
#> Warning: The `dep1` argument of `bar()` is deprecated as of <NA> 0.0.2.
#> ℹ Please use the `sup1` argument instead.
#> Warning: The `dep2` argument of `bar()` is deprecated as of <NA> 0.0.2.
#> ℹ Please use the `sup2` argument instead.
#> [[1]]
#> [1] 100
#> 
#> [[2]]
#> [1] "hello"
#> 
```
