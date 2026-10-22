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
  install_arrow = NULL,
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

  character. Currently one of "main", "R4.4.0", "R4.1.0", "dev", or
  "disk". These determine which branches to install. See details.

- dry_run:

  logical. When `TRUE`, only print the install commands instead of
  actually running them.

- install_arrow:

  logical or `NULL`. Whether to (re)install *arrow* with zstd support
  when `"arrow"` is in `modules` and the installed version is missing or
  lacks zstd. `NULL` (default) errors with the install command, `TRUE`
  runs it, `FALSE` skips it. See the *Non-suite packages* section.

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

## ref `"disk"`, `giottodisk`, or `gsource`

The on-disk build set. Installs the `gsource` branches that *GiottoDisk*
builds against, and *GiottoDisk* itself from its `dev` integration
branch. This is the only ref *GiottoDisk* is compatible with, so
requesting *GiottoDisk* with any other ref switches to this one.  
*GiottoData* and *GiottoDB* have no `gsource` branch and install from
their default branch. Neither is part of the *GiottoDisk* dependency
chain, so they are only installed when asked for by name.

## Non-suite packages

`"tilework"` and `"arrow"` can be requested as `modules` under any ref.
With `suite_deps = TRUE` they are only added automatically for
*GiottoDisk*.  
*tilework* installs from GitHub. *arrow* installs from source through
r-universe with zstd enabled, since zstd is needed for 10x parquet
files. This build can take a long time, so it only runs when *arrow* is
missing or lacks zstd and `install_arrow = TRUE`.

## Examples

``` r
if (FALSE) {
    # install core packages
    suite_install()
    suite_install("GiottoClass", ref = "dev")

    # install the on-disk build set
    suite_install("GiottoDisk", ref = "disk", install_arrow = TRUE)

    # install ONLY Giotto, ignoring module dependencies
    # (i.e. GiottoVisuals, GiottoClass, etc)
    suite_install("Giotto", suite_deps = FALSE)
}
```
