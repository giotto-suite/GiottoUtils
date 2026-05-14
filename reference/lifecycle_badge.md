# lifecycle badge

Generate markdown needed for lifecycle badges that help communicate
stability of functions in documentation when added in backticks as shown
below.

     #' `r lifecycle::badge("experimental")`
     #' `r lifecycle::badge("deprecated")`
     #' `r lifecycle::badge("superseded")`

## Usage

``` r
lifecycle_badge(stage = "stable")
```

## Arguments

- stage:

  character. 'stable', 'experimental', 'deprecated', or 'superseded'

## Value

markdown

## See also

Other lifecycle: `reexports`

## Examples

``` r
lifecycle_badge()
#> [1] "\\ifelse{html}{\\href{https://lifecycle.r-lib.org/articles/stages.html#stable}{\\figure{lifecycle-stable.svg}{options: alt='[Stable]'}}}{\\strong{[Stable]}}"
```
