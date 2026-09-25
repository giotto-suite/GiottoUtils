test_that("get_args_list works", {
    a <- function(x = 1, y = 2, ...) {
        get_args_list(...)
    }

    b <- a(z = 3, keep = "y")

    expect_identical(b, list(y = 2, z = 3))
})


test_that("get_args resolves caller via sys.function (no name lookup)", {
    # Regression for cross-package qualified calls (e.g. `Giotto::fn(...)`
    # when Giotto isn't attached). The caller's name is not reachable from
    # base::get()'s envir search, so name-based lookup errors with
    # "object 'fn' of mode 'function' was not found". sys.function() grabs
    # the function value directly off the call stack.
    e <- new.env(parent = baseenv())
    e$wrapper <- function(x = 1, y = 2) {
        GiottoUtils::get_args(toplevel = 1L)
    }
    # Detach the function from its lexical scope so its own name isn't
    # reachable when get_args walks up from its exec frame.
    environment(e$wrapper) <- baseenv()

    res <- eval(quote(wrapper(x = 10)), envir = e)

    expect_equal(unname(res[["x"]]), "10")
    expect_equal(unname(res[["y"]]), "2")
})
