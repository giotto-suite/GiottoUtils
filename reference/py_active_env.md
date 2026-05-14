# Active python environment

Check for an active python environment without initialization. If none
initialized, `FALSE` is returned. If an initialized environment is
found, the env name based on `reticulate::conda_list()` will be
returned. The following options will also be updated with information
about the active environment:

- `"giotto.py_active_env"` *(envname)*

- `"giotto.py_active_ver"` *(python version)*

- `"giotto.py_active_path"` *(path to python)*

## Usage

``` r
py_active_env()
```

## Value

boolean

## Examples

``` r
py_active_env()
#> Error in loadNamespace(x): there is no package called ‘reticulate’
```
