# Check for updates to Giotto Suite

Checks the Giotto Suite github repository and compares the version
number to the currently installed.

## Usage

``` r
check_github_suite_ver(pkg = "Giotto")
```

## Arguments

- pkg:

  character. Package to check (pattern matches)

## Value

Message indicating a new version available, otherwise returns NULL

## Examples

``` r
check_github_suite_ver("GiottoUtils")
```
