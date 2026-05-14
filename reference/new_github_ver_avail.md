# Check if a package has newer github version

This function works by downloading the DESCRIPTION file from a github
repo and then comparing the verison number with a provided value. If the
download fails or the github version is not newer than what is
installed, then it silently returns NULL. If the github version is
newer, the new version number will be returned

## Usage

``` r
new_github_ver_avail(url, current_ver = NULL)
```

## Arguments

- url:

  character. url to the package to check's DESCRIPTION file.

- current_ver:

  character. Current version to check against

## Value

character. Version number

## Examples

``` r
url <- "https://raw.githubusercontent.com/giotto-suite/GiottoData/master/DESCRIPTION"
new_github_ver_avail(url, 0.2)
#> [1] "0.2.16"
```
