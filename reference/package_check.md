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
  optional = FALSE,
  custom_msg = NULL
)
```

## Arguments

- pkg_name:

  name of package

- repository:

  where is the package (in format repo:cooltool for CRAN, Bioc, and pip
  repos. format repo:johndoe/cooltool for github or bitbucket)

- github_repo:

  name of github repository if needed

- optional:

  whether the package is optional. If `TRUE`, an error is thrown. If
  `FALSE`, a warning is sent and only
  [`message()`](https://rdrr.io/r/base/message.html) will be sent if
  FALSE.

- custom_msg:

  custom message to be sent instead of default error or message

## Value

character

## Examples

``` r
if (FALSE) { # \dontrun{
package_check("Matrix")
package_check("BiocSingular", repository = "Bioc")
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
