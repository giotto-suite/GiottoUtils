# Giotto Default BiocParallel Param

Get and set a cached BiocParallel BPPARAM setting. Cached settings can
either be retrieved using `giotto_bpparam()` or directly with
`getOption("giotto.bpparam")`

## Usage

``` r
giotto_bpparam(BPPARAM = NULL)
```

## Arguments

- BPPARAM:

  set a BiocParallel parameter class deciding how to perform
  parallelized or (or sequential) evaluation

## Value

If a `BiocParallelParam` is passed to `BPPARAM`, it will be cached and
invisibly returned. If `BPPARAM` is `NULL` then the cached param will be
invisibly returned (`SerialParam`) is default.
