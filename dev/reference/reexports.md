# Objects exported from other packages

These objects are imported from other packages. Follow the links below
to see their documentation.

- gtools:

  [`mixedorder()`](https://rdrr.io/pkg/gtools/man/mixedsort.html),
  [`mixedsort()`](https://rdrr.io/pkg/gtools/man/mixedsort.html)

- jsonlite:

  [`fromJSON()`](https://jeroen.r-universe.dev/jsonlite/reference/fromJSON.html),
  [`read_json()`](https://jeroen.r-universe.dev/jsonlite/reference/read_json.html)

- lifecycle:

  [`deprecate_soft()`](https://lifecycle.r-lib.org/reference/deprecate_soft.html),
  [`deprecate_stop()`](https://lifecycle.r-lib.org/reference/deprecate_soft.html),
  [`deprecate_warn()`](https://lifecycle.r-lib.org/reference/deprecate_soft.html),
  [`deprecated()`](https://lifecycle.r-lib.org/reference/deprecated.html),
  [`is_present()`](https://lifecycle.r-lib.org/reference/deprecated.html)

## Value

argument marked as deprecated

boolean

NULL, invisibly.

NULL, invisibly.

NULL, invisibly.

A sorted vector

vector giving the sort order of the input elements

## See also

Other lifecycle:
[`lifecycle_badge()`](https://giotto-suite.github.io/GiottoUtils/dev/reference/lifecycle_badge.md)

## Examples

``` r
jsoncars <- jsonlite::toJSON(mtcars, pretty = TRUE)
fromJSON(jsoncars)
```
