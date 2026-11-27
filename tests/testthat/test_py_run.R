test_that("py_run() checks its arguments", {
    skip_if_not_installed("reticulate", minimum_version = "1.41")
    expect_error(py_run("not a function"))
    expect_error(py_run(function() 1, requirements = 1))
    expect_error(py_run(function() 1, isolate = FALSE, background = TRUE),
        "isolate")
})

test_that("an own Python is found per tool or for all tools", {
    old <- options(giotto.py_python = NULL)
    on.exit(options(old), add = TRUE)
    expect_null(.py_user_python("a"))
    options(giotto.py_python = "/my/python")
    expect_identical(.py_user_python("a"), "/my/python")
    expect_identical(.py_user_python(), "/my/python")
    options(giotto.py_python = list(a = "/py/a"))
    expect_identical(.py_user_python("a"), "/py/a")
    expect_null(.py_user_python("b"))
    expect_null(.py_user_python())
})

test_that("the first use of a set of requirements is announced once", {
    old <- Sys.getenv("R_USER_CACHE_DIR")
    on.exit(Sys.setenv(R_USER_CACHE_DIR = old), add = TRUE)
    Sys.setenv(R_USER_CACHE_DIR = tempfile())
    expect_message(first <- .py_first_use("scrublet", NULL, "scrublet"),
        "giotto.py_python = list\\(scrublet")
    expect_true(first)
    .py_mark_used("scrublet", NULL)
    expect_false(.py_first_use("scrublet", NULL, "scrublet"))
    expect_message(.py_first_use("scrublet", "3.11", NULL), "/path/to/python")
    expect_false(.py_first_use(character(), NULL))
})

test_that("py_run() runs Python in a worker and reports versions", {
    skip_on_cran()
    skip_if_offline()
    skip_if_not_installed("callr")
    skip_if_not_installed("reticulate", minimum_version = "1.41")
    v <- function() reticulate::import("numpy")$`__version__`
    old <- py_run(v, requirements = "numpy<2")
    new <- py_run(v, requirements = "numpy>=2")
    expect_true(numeric_version(old) < "2")
    expect_true(numeric_version(new) >= "2")
    expect_named(attr(new, "py_versions"), c("python", "numpy"))
    expect_false(reticulate::py_available(initialize = FALSE))
    p <- py_run(v, requirements = "numpy", background = TRUE)
    expect_identical(as.character(py_result(p)), as.character(new))
    expect_error(py_run(function() reticulate::import("not_a_module"),
        requirements = "numpy"), "not_a_module")
})
