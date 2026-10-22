# package_check

check if package is available and provide installation instruction if
not available. pip installations can accept github links. For pip links,
the `repo:link` format is always preferred especially since the link
cannot be used as the python package name to check the isntallation
status of.

## Usage

``` r
package_check(
  pkg_name,
  repository = NULL,
  github_repo = NULL,
  optional = deprecated(),
  custom_msg = NULL,
  on_missing = c("error", "warning", "message", "none"),
  once = FALSE
)
```

## Arguments

- pkg_name:

  name of package

- repository:

  where is the package (in format repo:cooltool for CRAN, Bioc, and pip
  repos. format repo:johndoe/cooltool for github or bitbucket. format
  r-universe:johndoe/cooltool for the johndoe r-universe, which serves
  binaries, so prefer it over github for packages with compiled code)

- github_repo:

  name of github repository if needed

- optional:

  **\[deprecated\]** use `on_missing`. `TRUE` is
  `on_missing = "message"`, `FALSE` is `on_missing = "error"`.

- custom_msg:

  custom message to be sent instead of default error or message

- on_missing:

  character. What to do when a package is missing: `"error"` (default),
  `"warning"`, `"message"`, or `"none"` to report nothing. Every level
  but `"error"` returns `FALSE`, so the caller can fall back. An
  installed package below a requested version is reported at the same
  level, except that `"error"` reports it as a warning.

- once:

  logical. When `TRUE`, a warning or message is shown once per session
  for these packages, through `rlang`'s `.frequency = "once"`. Errors
  are always raised.

## Value

`TRUE` invisibly when every package is installed, otherwise `FALSE`
invisibly (only reachable when `on_missing` is not `"error"`)

## Examples

``` r
if (FALSE) { # \dontrun{
package_check("Matrix")
# use a package when it is there, fall back when it is not
if (package_check("png", on_missing = "message")) png::readPNG(f)
# an optional speedup, mentioned once per session
package_check("GiottoKernels", on_missing = "message", once = TRUE)
package_check("BiocSingular", repository = "Bioc")
package_check("sedonadb", repository = "r-universe:apache/sedonadb>=0.4.0")
# (only expected to work when giottoenv is loaded)
package_check("leidenalg", repository = "pip:leidenalg")

# expected to fail
package_check("faketool")
package_check("faketool", repository = "Bioc")
package_check("installme", repository = "pip:installme")
package_check(
    pkg_name = "cooltool",
    repository = c("github"),
    github_repo = "johndoe/cooltool@dev"
)

# vectorized
package_check(
    pkg_name = c("faketool", "cooltool"),
    repository = c("CRAN", "github:johndoe/cooltool")
)

# specific version (most useful for python modules)
package_check("numpy", "pip:numpy>=1.0")
package_check("numpy", "pip:numpy==1.0")

# github pip (python) checks
package_check(
    pkg_name = "pysodb",
    repository =
        "pip:git+https://github.com/TencentAILabHealthcare/pysodb.git"
)
} # }
```
