# check_github_suite_ver ####
test_that("Existing package is checked without issue", {
    # with the assumption that no development code on this package will be behind
    # what is available on github
    expect_no_error(check_github_suite_ver("GiottoUtils"))
})

test_that("Non-existing package throws error", {
    expect_error(check_github_suite_ver(
        pkg = "this-does-not-exist",
        regexp = "this-does-not-exist"
    ))
})



# package_check ####
test_that("Existing packages are checked with no conditions", {
    expect_no_condition(package_check("GiottoUtils", repository = "CRAN"))
    expect_no_condition(package_check("GiottoUtils", repository = "Bioc"))
    expect_no_condition(package_check("GiottoUtils", repository = "github", github_repo = "johndoe/cooltool"))
})

test_that("Existing packages return TRUE", {
    expect_true(package_check("GiottoUtils", repository = "CRAN"))
    expect_true(package_check("GiottoUtils", repository = "Bioc"))
    expect_true(package_check("GiottoUtils", repository = "github", github_repo = "johndoe/cooltool"))
})

test_that("Nonexisting optional packages return message with install instructions", {
    mock_pkg <- "I-dont-exist"
    expect_message(package_check(mock_pkg, repository = "CRAN", on_missing = "message"),
        regexp = "install.packages"
    )
    expect_message(package_check(mock_pkg, repository = "Bioc", on_missing = "message"),
        regexp = "BiocManager::install"
    )
    expect_message(package_check(mock_pkg, repository = "github", github_repo = "fake_repo", on_missing = "message"),
        regexp = "devtools::install_github\\(\"fake_repo"
    )
})

test_that("Nonexisting Nonoptional packages throw error with install instructions", {
    mock_pkg <- "I-also-dont-exist"
    expect_error(package_check(mock_pkg, repository = "CRAN", on_missing = "error"),
        regexp = "install.packages"
    )
    expect_error(package_check(mock_pkg, repository = "Bioc", on_missing = "error"),
        regexp = "BiocManager::install"
    )
    expect_error(package_check(mock_pkg, repository = "github", github_repo = "I_made_it_up", on_missing = "error"),
        regexp = "devtools::install_github\\(\"I_made_it_up"
    )
})

test_that("Nonexisting packages with specified custom message will send custom", {
    mock_pkg <- "its_amazing_how_much_I_dont_exist"
    custom <- "I am custom"
    expect_message(package_check(mock_pkg, repository = "CRAN", custom_msg = custom, on_missing = "message"),
        regexp = custom
    )
    expect_message(package_check(mock_pkg, repository = "Bioc", custom_msg = custom, on_missing = "message"),
        regexp = custom
    )
    expect_message(package_check(mock_pkg, repository = "github", custom_msg = custom, on_missing = "message", github_repo = "still_fake"),
        regexp = custom
    )
})

test_that("Nonexisting nonoptional packages with specified custom message will error custom", {
    mock_pkg <- "ive_never_heard_of_me"
    custom <- "I am custom"
    expect_error(package_check(mock_pkg, repository = "CRAN", custom_msg = custom, on_missing = "error"),
        regexp = custom
    )
    expect_error(package_check(mock_pkg, repository = "Bioc", custom_msg = custom, on_missing = "error"),
        regexp = custom
    )
    expect_error(package_check(mock_pkg, repository = "github", custom_msg = custom, on_missing = "error", github_repo = "a_fabrication"),
        regexp = custom
    )
})

test_that("r-universe packages point at the universe with CRAN for deps", {
    expect_true(package_check("GiottoUtils",
        repository = "r-universe:giotto-suite/GiottoUtils"))
    expect_error(
        package_check("I-dont-exist",
            repository = "r-universe:johndoe/I-dont-exist"),
        regexp = paste0(
            "install.packages\\(\"I-dont-exist\",\n",
            "    repos = c\\(\"https://johndoe.r-universe.dev\", ",
            "\"https://cloud.r-project.org\"\\)\\)"
        )
    )
    package_check("GiottoUtils",
        repository = "r-universe:giotto-suite/GiottoUtils>=1000") |>
        expect_warning()
})

test_that("r-universe inputs without an owner error", {
    expect_error(package_check("cooltool", repository = "r-universe"),
        regexp = "r-universe:owner/package")
    expect_error(
        package_check("cooltool", repository = "r-universe:cooltool"),
        regexp = "r-universe:owner/package")
})

test_that("on_missing levels signal their condition and return FALSE", {
    mock_pkg <- "I-dont-exist-either"
    expect_message(r <- package_check(mock_pkg, on_missing = "message"),
        regexp = "install.packages")
    expect_false(r)
    expect_warning(r <- package_check(mock_pkg, on_missing = "warning"),
        regexp = "install.packages")
    expect_false(r)
    expect_no_condition(r <- package_check(mock_pkg, on_missing = "none"))
    expect_false(r)
    expect_error(package_check(mock_pkg), regexp = "install.packages")
    expect_true(package_check("data.table", on_missing = "none"))
})

test_that("a version shortfall is reported at the on_missing level", {
    req <- "CRAN:data.table>=1000"
    expect_warning(package_check("data.table", repository = req))
    expect_message(
        r <- package_check("data.table", repository = req,
            on_missing = "message"),
        regexp = "is required"
    )
    expect_true(r) # installed, so usable
    expect_no_condition(package_check("data.table", repository = req,
        on_missing = "none"))
})

test_that("once shows a message once per session", {
    mock_pkg <- paste0("once-pkg-", sample.int(1e6, 1L))
    expect_message(package_check(mock_pkg, on_missing = "message", once = TRUE),
        regexp = mock_pkg)
    expect_no_message(r <- package_check(mock_pkg, on_missing = "message",
        once = TRUE))
    expect_false(r)
    # once never swallows an error
    expect_error(package_check(mock_pkg, once = TRUE))
    expect_error(package_check(mock_pkg, once = TRUE))
})

test_that("deprecated optional maps onto on_missing", {
    rlang::local_options(lifecycle_verbosity = "quiet")
    mock_pkg <- "still-not-real"
    expect_message(r <- package_check(mock_pkg, optional = TRUE),
        regexp = "install.packages")
    expect_false(r)
    expect_error(package_check(mock_pkg, optional = FALSE),
        regexp = "install.packages")
    expect_error(
        package_check(c(mock_pkg, "data.table"),
            repository = c("CRAN", "CRAN"), optional = c(TRUE, FALSE)),
        regexp = "install.packages"
    )
    expect_error(package_check(mock_pkg, optional = TRUE,
        on_missing = "message"), regexp = "not with `optional`")

    rlang::local_options(lifecycle_verbosity = "warning")
    expect_warning(package_check("data.table", optional = TRUE),
        class = "lifecycle_warning_deprecated")
})

# check name parsing internal

parsefun <- get(".check_package_parse_version_request", asNamespace("GiottoUtils"))

test_that("package name and version parsing works", {
    # check some exotic names
    checknames <- c(
        "GiottoUtils",
        "data.table",
        "base64enc",
        "test.name.42",
        "git+https://github.com/TencentAILabHealthcare/pysodb.git"
    )

    for (name in checknames) {
        expect_identical(
            object = parsefun(name),
            expected = c(input = name, location = name, operator = NA, version_req = NA)
        )
        expect_identical(
            object = parsefun(paste0(name, ">=0.2-10")),
            expected = c(input = paste0(name, ">=0.2-10"), location = name, operator = ">=", version_req = "0.2-10")
        )
    }
})

test_that("version requirement works", {
    package_check("GiottoUtils") |> expect_no_condition()
    package_check("GiottoUtils", repository = "github:giotto-suite/GiottoUtils>=1000") |> expect_warning()
    package_check("data.table", repository = "CRAN:data.table>=1000") |> expect_warning()
    package_check("data.table", repository = "CRAN:data.table<1000") |> expect_no_warning()
    package_check("data.table", repository = "CRAN:data.table>=0.0.1") |> expect_no_condition()
    package_check("scipy", repository = "pip:scipy>=0.0.1") |> expect_no_condition()
    package_check("scipy", repository = "pip:scipy>=1000") |> expect_warning()
    package_check("scipy", repository = "pip:scipy~=0.0.1") |> expect_error() # not supported
})

test_that("a missing package beside a version request gets install instructions", {
    package_check(
        c("I-dont-exist", "data.table"),
        repository = c("CRAN:I-dont-exist>=1.0", "CRAN:data.table>=0.0.1")
    ) |>
        expect_error(regexp = "install.packages")
})
