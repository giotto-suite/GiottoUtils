# Convert between Matrix and scipy sparse representations

Convert between R Matrix sparse matrix representation and python scipy
sparse formats. Inspired by the implementation in nmslibR. Currently
compatible classes:  

- **`to_scipy_sparse()`**: `matrix`, `dgCMatrix`, `dgRMatrix`,
  `dgTMatrix`

- **`from_scipy_sparse()`**: `scipy.sparse._csr.csr_matrix`,
  `scipy.sparse._csc.csc_matrix`

## Usage

``` r
to_scipy_sparse(x, format = c("C", "R"), transpose = FALSE, ...)

from_scipy_sparse(x, format = c("C", "R"), transpose = FALSE, ...)
```

## Arguments

- x:

  matrix-like object to convert

- format:

  character. Either "C" for Compressed Sparse Column or "R" for
  Compressed Sparse Row matrix representations

- transpose:

  whether to transpose the matrix. default is FALSE

- ...:

  additional params to pass to `scipy.sparse.cs*_matrix()` or
  [`Matrix::sparseMatrix`](https://rdrr.io/pkg/Matrix/man/sparseMatrix.html)
  depending on which output is desired.

## Value

scipy or Matrix sparse representation depending on 'to' or 'from'
respectively

## Examples

``` r
# example data
m <- matrix(data = 0L, nrow = 400, ncol = 300)
m[sample(400, 100), sample(300, 100)] <- runif(100, max = 10)
dgc <- Matrix::rsparsematrix(nrow = 400L, ncol = 300L, density = 0.1)

# some conversions
py_m_c <- to_scipy_sparse(m, format = "C")
#> Error in loadNamespace(x): there is no package called ‘reticulate’
py_m_r_t <- to_scipy_sparse(m, format = "R", transpose = TRUE)
#> Error in loadNamespace(x): there is no package called ‘reticulate’

py_dgc_c <- to_scipy_sparse(dgc, format = "C")
#> Error in loadNamespace(x): there is no package called ‘reticulate’
py_dgc_r <- to_scipy_sparse(dgc, format = "R")
#> Error in loadNamespace(x): there is no package called ‘reticulate’

dgc_revert <- from_scipy_sparse(py_dgc_c, format = "C")
#> Error: object 'py_dgc_c' not found
dgr_revert <- from_scipy_sparse(py_dgc_c, format = "R")
#> Error: object 'py_dgc_c' not found
identical(dgc, dgc_revert)
#> Error: object 'dgc_revert' not found
```
