# Giotto Suite GitHub Installation

**\[experimental\]**  
Installation convenience function. Helps with Giotto Suite installation
from the GitHub website by ensuring modules are installed in the correct
order. Also automatically switches to the R4.4.0 version when user R
version is lower than 4.4.1.  

This utility will do a full reinstall of the specified Giotto Suite
modules but non-Suite dependencies will never prompt to be updated.

## Usage

``` r
suite_install(
  modules = suite_packages(),
  suite_deps = TRUE,
  ref = "main",
  dry_run = FALSE,
  ...
)
```

## Arguments

- modules:

  character. Which modules to install. Defaults to the core packages
  needed for Giotto to run.

- suite_deps:

  logical. Whether to install any potential Giotto Suite dependency
  modules

- ref:

  character. Currently one of "main", "R4.4.0", or "dev". These
  determine which branches to install. See details.

- dry_run:

  logical. When `TRUE`, only print the install commands instead of
  actually running them.

- ...:

  additional params to pass to `remotes::install_github()`

## Value

`TRUE` if install succeeds

## ref `"main"`

Installs the main Giotto version. This version is expected to chase the
highest R version.

## ref `"R4.4.0"`, `r440`, or `440`

Mirrors the main branch, but locks the R version at 4.4.0 (lowest
version supported by all dependencies)

## ref `"R4.1.0"`, `r410`, or `410`

Mirrors the main branch, but locks the R version at 4.1.0. This version
requires installation of {Matrix} 1.6-5

## ref `"dev"`

This version is ahead of the main version and also chases the latest R
version.

## Examples

``` r
if (FALSE) {
    # install core packages
    suite_install()
    suite_install("GiottoClass", ref = "dev")

    # install ONLY Giotto, ignoring module dependencies
    # (i.e. GiottoVisuals, GiottoClass, etc)
    suite_install("Giotto", suite_deps = FALSE)
}
```
