# Changelog

## GiottoUtils 0.2.5 (2025/05/21)

### New

- [`str_reformat()`](https://giotto-suite.github.io/GiottoUtils/reference/str_convenience.md)
  for print post-processing with
  [`strwrap()`](https://rdrr.io/r/base/strwrap.html)

### Enhancement

- Improve fallbacks for
  [`print_list()`](https://giotto-suite.github.io/GiottoUtils/reference/print_list.md)

## GiottoUtils 0.2.4 (2025/05/06)

### Changes

- deprecate
  [`fread_colmatch()`](https://giotto-suite.github.io/GiottoUtils/reference/read_colmatch.md)
  in favor of
  [`read_colmatch()`](https://giotto-suite.github.io/GiottoUtils/reference/read_colmatch.md)

### New

- [`str_abbreviate()`](https://giotto-suite.github.io/GiottoUtils/reference/str_abbreviate.md)
  for shortening long strings for printing

### Enhancement

- More ergonomic ref selection for
  [`suite_install()`](https://giotto-suite.github.io/GiottoUtils/reference/suite_install.md)
- `R4.1.0` branch can now be used as a ref for
  [`suite_install()`](https://giotto-suite.github.io/GiottoUtils/reference/suite_install.md)
- [`read_colmatch()`](https://giotto-suite.github.io/GiottoUtils/reference/read_colmatch.md)
  now uses {arrow} for faster .csv filtering, enhanced with automated
  schema detection performed through
  [`data.table::fread()`](https://rdrr.io/pkg/data.table/man/fread.html)
- `dry_run` param for
  [`suite_install()`](https://giotto-suite.github.io/GiottoUtils/reference/suite_install.md)
  to preview install commands
- [`vmsg()`](https://giotto-suite.github.io/GiottoUtils/reference/vmsg.md)
  logging can now be ephemerally diverted to other files

### Bug Fixes

- [`package_check()`](https://giotto-suite.github.io/GiottoUtils/reference/package_check.md)
  error when checking with a provided github repo and a version number
- [`package_check()`](https://giotto-suite.github.io/GiottoUtils/reference/package_check.md)
  error when checking packages with “.” characters

## GiottoUtils 0.2.3 (2025/01/17)

### New

- [`handle_errors()`](https://giotto-suite.github.io/GiottoUtils/reference/handle_errors.md)
  for catching errors with `call. = FALSE` to avoid console locking in
  complex calls

### Enhancement

- [`package_check()`](https://giotto-suite.github.io/GiottoUtils/reference/package_check.md)
  now supports version checks of the style
  `repository = "pip:XXXXX>=A.B.C"` (reported as warnings)

## GiottoUtils 0.2.2 (2024/12/09)

### Enhancement

- [`lapply_flex()`](https://giotto-suite.github.io/GiottoUtils/reference/lapply_flex.md)
  `BiocParallel` method added.
- warning added when sequential evaluation is used with
  [`lapply_flex()`](https://giotto-suite.github.io/GiottoUtils/reference/lapply_flex.md).
  Silenceable through `options("giotto.warn_sequential" = FALSE)`
- `vlim`, `slim`, `seed` params for
  [`getRainbowColors()`](https://giotto-suite.github.io/GiottoUtils/reference/getRainbowColors.md)
  to allow more diverse palettes

## GiottoUtils 0.2.1 (2024/11/4)

### New

- [`suite_packages()`](https://giotto-suite.github.io/GiottoUtils/reference/suite_packages.md)
  for reporting the names of Giotto Suite modules
- [`suite_install()`](https://giotto-suite.github.io/GiottoUtils/reference/suite_install.md)
  for installing specific branches of Giotto Suite

## GiottoUtils 0.2.0 (2024/10/26)

### Breaking change

- R version requirement is now 4.4.1

### New

- [`gwith_package()`](https://giotto-suite.github.io/GiottoUtils/reference/with.md),
  [`gwith_options()`](https://giotto-suite.github.io/GiottoUtils/reference/with.md),
  [`gwith_seed()`](https://giotto-suite.github.io/GiottoUtils/reference/with.md)
  for setting temporary conditions for eval
- [`handle_warnings()`](https://giotto-suite.github.io/GiottoUtils/reference/handle_warnings.md)
  for graceful warning handling

## GiottoUtils 0.1.12 (2024/09/27)

### New

- [`pbar()`](https://giotto-suite.github.io/GiottoUtils/reference/pbar.md)
  and
  [`with_pbar()`](https://giotto-suite.github.io/GiottoUtils/reference/with_pbar.md)
  as progress reporting utils. These are wrappers around *progressr*
  functionalities.
- reexports of
  [`fromJSON()`](https://jeroen.r-universe.dev/jsonlite/reference/fromJSON.html)
  and
  [`read_json()`](https://jeroen.r-universe.dev/jsonlite/reference/read_json.html)
  from `jsonlite`.
- [`melt_matrix()`](https://giotto-suite.github.io/GiottoUtils/reference/melt_matrix.md)
  to emulate `reshape2::melt.matrix()` (deprecated package) for most use
  cases in Giotto.

## GiottoUtils 0.1.11 (2024/08/22)

### New

- [`py_active_env()`](https://giotto-suite.github.io/GiottoUtils/reference/py_active_env.md)
  utility function for detecting any active python environment without
  initializing

### Enhancement

- [`package_check()`](https://giotto-suite.github.io/GiottoUtils/reference/package_check.md)
  now works for pip github installs
- [`package_check()`](https://giotto-suite.github.io/GiottoUtils/reference/package_check.md)
  now reports which conda environment is being activated and what python
  version it is.

## GiottoUtils 0.1.10 (2024/07/26)

### New

- [`dir_manifest()`](https://giotto-suite.github.io/GiottoUtils/reference/dir_manifest.md)
  for creating a named `list` of files within a directory. Mostly wraps
  [`list.files()`](https://rdrr.io/r/base/list.files.html)

## GiottoUtils 0.1.9 (2024/07/12)

### New

- [`deprecate_param()`](https://giotto-suite.github.io/GiottoUtils/reference/deprecate_param.md)
  utility function for streamlining code
- [`print_list()`](https://giotto-suite.github.io/GiottoUtils/reference/print_list.md)
  for pretty printing of list-like objects
- [`from_scipy_sparse()`](https://giotto-suite.github.io/GiottoUtils/reference/scipy_sparse.md)
  for conversion from scipy `csr` and `csc` to Matrix `dgCMatrix` and
  `dgRMatrix`

### Changes

- newer github version checking refactored into
  [`new_github_ver_avail()`](https://giotto-suite.github.io/GiottoUtils/reference/new_github_ver_avail.md)

## GiottoUtils 0.1.8 (2024/05/22)

### New

- [`wrap_txtf()`](https://giotto-suite.github.io/GiottoUtils/reference/wrap_txt.md)
  variant of
  [`wrap_txt()`](https://giotto-suite.github.io/GiottoUtils/reference/wrap_txt.md)
  that uses [`sprintf()`](https://rdrr.io/r/base/sprintf.html)
  formatting
- [`init_option()`](https://giotto-suite.github.io/GiottoUtils/reference/init_option.md)
  for setting an option if it does not exist

### Enhancement

- [`dt_to_matrix()`](https://giotto-suite.github.io/GiottoUtils/reference/dt_to_matrix.md)
  can now chunk the conversion to `Matrix` to avoid memory issues
- [`get_args_list()`](https://giotto-suite.github.io/GiottoUtils/reference/prev_call.md)
  now has a `keep` param that allows selection of which collected args
  to keep

## GiottoUtils 0.1.6 (2024/02/26)

### New

- `%null%`, `%na%`, and `%none%` infix operators for setting a default
  value when an object is, respectively, NULL, NA, or length of 0.
- [`local_seed()`](https://giotto-suite.github.io/GiottoUtils/reference/local_seed.md)
  for transiently setting a seed only for the duration of a function

## GiottoUtils 0.1.5 (2024/02/11)

### Bug Fixes

- [`str_locate2()`](https://giotto-suite.github.io/GiottoUtils/reference/str_locate2.md)
  now works with vectorized inputs like the *stringr* counterpart
- [`str_locate2()`](https://giotto-suite.github.io/GiottoUtils/reference/str_locate2.md)
  no-matches now properly return `NA_integer_` instead of negative
  values

### New

- [`to_scipy_sparse()`](https://giotto-suite.github.io/GiottoUtils/reference/scipy_sparse.md)
  conversion of R matrices to scipy sparse representations

## GiottoUtils 0.1.4 (2024/02/05)

### Enhancement

- new `seed` param for
  [`getDistinctColors()`](https://giotto-suite.github.io/GiottoUtils/reference/getDistinctColors.md)
  that allows the ordering of the distinct colors to be changed.
- [`package_check()`](https://giotto-suite.github.io/GiottoUtils/reference/package_check.md)
  now allows more than one package to be checked using repo:location
  notation.

## GiottoUtils 0.1.3

### Added

- Add: [`mixedsort()`](https://rdrr.io/pkg/gtools/man/mixedsort.html)
  and [`mixedorder()`](https://rdrr.io/pkg/gtools/man/mixedsort.html)
  from *gtools*

## GiottoUtils 0.1.2 (2024/01/02)

### Added

- Add:
  [`getMonochromeColors()`](https://giotto-suite.github.io/GiottoUtils/reference/getMonochromeColors.md)
  basic color palette function. Useful for image colorization.

## GiottoUtils 0.1.1 (2023/12/16)

### Breaking changes

- Remove checkmate reexports
- Remove deprecated `flex_lapply()`
- Rename `guard_against_notgiotto()` to
  [`assert_giotto()`](https://giotto-suite.github.io/GiottoUtils/reference/g_assert.md)
- Rename `set_row_order_dt()` to
  [`dt_set_row_order()`](https://giotto-suite.github.io/GiottoUtils/reference/dt_set_row_order.md)
- Rename `dcast_dt_string()` to
  [`dt_dcast_string()`](https://giotto-suite.github.io/GiottoUtils/reference/dt_dcast_string.md)
- Rename `sort_combine_two_DT_columns()` to
  [`dt_sort_combine_two_columns()`](https://giotto-suite.github.io/GiottoUtils/reference/dt_sort_combine_two_columns.md)
- Rename `DT_removeNA()` to
  [`dt_remove_na()`](https://giotto-suite.github.io/GiottoUtils/reference/dt_remove_na.md)
- Rename `assert_DT()` to
  [`assert_dt()`](https://giotto-suite.github.io/GiottoUtils/reference/g_assert.md)

### Added

- Add
  [`gstop()`](https://giotto-suite.github.io/GiottoUtils/reference/gstop.md)
  as a framework for sending module specific error messages
- Add
  [`str_locate2()`](https://giotto-suite.github.io/GiottoUtils/reference/str_locate2.md)
  (implementation of `stringr::str_locate()` in base R)
- Add
  [`str_vector()`](https://giotto-suite.github.io/GiottoUtils/reference/str_convenience.md)
  for pretty printing a vector as a string
- Add:
  [`str_bracket()`](https://giotto-suite.github.io/GiottoUtils/reference/str_convenience.md),
  [`str_parenth()`](https://giotto-suite.github.io/GiottoUtils/reference/str_convenience.md),
  [`str_quote()`](https://giotto-suite.github.io/GiottoUtils/reference/str_convenience.md),
  [`str_double_quote()`](https://giotto-suite.github.io/GiottoUtils/reference/str_convenience.md)
  convenience functions
- Move:
  [`get_prev_fname()`](https://giotto-suite.github.io/GiottoUtils/reference/prev_call.md),
  [`get_args()`](https://giotto-suite.github.io/GiottoUtils/reference/prev_call.md),
  and
  [`get_prev_call()`](https://giotto-suite.github.io/GiottoUtils/reference/prev_call.md)
  to this package
- Add
  [`get_prev_call()`](https://giotto-suite.github.io/GiottoUtils/reference/prev_call.md)
- Move basic color palettes
  [`getDistinctColors()`](https://giotto-suite.github.io/GiottoUtils/reference/getDistinctColors.md)
  and
  [`getRainbowColors()`](https://giotto-suite.github.io/GiottoUtils/reference/getRainbowColors.md)
  to this package
- Add: *RColorBrewer* to suggests for
  [`getDistinctColors()`](https://giotto-suite.github.io/GiottoUtils/reference/getDistinctColors.md)

### Changes

- improvements to
  [`assert_giotto()`](https://giotto-suite.github.io/GiottoUtils/reference/g_assert.md)

## GiottoUtils 0.1.0 (2023/11/29)

Initial release
