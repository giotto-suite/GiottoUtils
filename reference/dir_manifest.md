# Generate file manifest list from a directory

Create a `list` of full filepaths (character) that are named by with the
respective `[basename()]`. Allows easy `$` exploration and indexing of
items.  
All params are directly passed to `[list.files()]` except for
`full.names`. `[list.files()]` also normally returns both actual files
and directories when `recursive = FALSE`, but this function specifically
tests if items are existing files and not directories with
`file_test(op = -f)` and fully obeys that flag in all cases.

## Usage

``` r
dir_manifest(
  path = ".",
  pattern = NULL,
  all.files = FALSE,
  recursive = FALSE,
  ignore.case = FALSE,
  include.dirs = FALSE,
  no.. = FALSE,
  as.list = TRUE
)
```

## Arguments

- path:

  a character vector of full path names; the default corresponds to the
  working directory, `[getwd()]`. Tilde expansion (see
  [path.expand](https://rdrr.io/r/base/path.expand.html)) and
  [`normalizePath()`](https://rdrr.io/r/base/normalizePath.html) are
  performed. Missing values will be ignored. Elements with a marked
  encoding will be converted to the native encoding (and if that fails,
  considered non-existent).

- pattern:

  an optional regular expression. Only file names which match the
  regular expression will be returned.

- all.files:

  a logical value. If `FALSE`, only the names of visible files are
  returned (following Unix-style visibility, that is files whose name
  does not start with a dot). If `TRUE`, all file names will be
  returned.

- recursive:

  logical. Should the listing recurse into directories?

- ignore.case:

  logical. Should pattern-matching be case-insensitive?

- include.dirs:

  logical. Should subdirectory names be included in recursive listings?

- no..:

  logical. Should both `"."` and `".."` be excluded also from
  non-recursive listings?

- as.list:

  logical. Should output be a list or a named character vector

## Value

full and normalized filepaths named by the file basename as either a
list (default) or if `as.list = FALSE`, a character vector.

## Examples

``` r
dir_manifest()
#> $check_github_suite_ver.html
#> [1] "/home/runner/work/GiottoUtils/GiottoUtils/docs/reference/check_github_suite_ver.html"
#> 
#> $color_tag.html
#> [1] "/home/runner/work/GiottoUtils/GiottoUtils/docs/reference/color_tag.html"
#> 
#> $degrees.html
#> [1] "/home/runner/work/GiottoUtils/GiottoUtils/docs/reference/degrees.html"
#> 
#> $deprecate_param.html
#> [1] "/home/runner/work/GiottoUtils/GiottoUtils/docs/reference/deprecate_param.html"
#> 
#> $depth.html
#> [1] "/home/runner/work/GiottoUtils/GiottoUtils/docs/reference/depth.html"
#> 
#> $determine_cores.html
#> [1] "/home/runner/work/GiottoUtils/GiottoUtils/docs/reference/determine_cores.html"
#> 
#> $index.html
#> [1] "/home/runner/work/GiottoUtils/GiottoUtils/docs/reference/index.html"
#> 
```
