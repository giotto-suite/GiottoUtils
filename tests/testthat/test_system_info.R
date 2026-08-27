# test_that("get_os returns the correct operating system", {
#   # Test on Windows
#   if (.Platform$OS.type == "windows") {
#     expected <- "windows"
#     actual <- get_os()
#     expect_equal(actual, expected)
#   }
#
#   # Test on OSX
#   if (.Platform$OS.type == "unix" && grepl("^darwin", R.version$os)) {
#     expected <- "osx"
#     actual <- get_os()
#     expect_equal(actual, expected)
#   }
#
#   # Test on Linux
#   if (.Platform$OS.type == "unix" && grepl("linux-gnu", R.version$os)) {
#     expected <- "linux"
#     actual <- get_os()
#     expect_equal(actual, expected)
#   }
# })

# keep_awake ####

# The command choice is pure, so it can be tested anywhere including CI.
test_that(".awake_cmd picks the right mechanism per platform", {
    mac <- .awake_cmd("osx", pid = 4242)
    expect_equal(mac$cmd, "caffeinate")
    # the assertion must be bound to a pid, which is what makes it self-cleaning
    expect_true("-w" %in% mac$args)
    expect_true("4242" %in% mac$args)

    expect_null(.awake_cmd("windows"))
    expect_null(.awake_cmd("some-future-os"))

    lin <- .awake_cmd("linux")
    if (nzchar(Sys.which("systemd-inhibit"))) {
        expect_equal(lin$cmd, "systemd-inhibit")
    } else {
        expect_null(lin)
    }
})

test_that("keep_awake respects the giotto.prevent_sleep kill switch", {
    gwith_options(list(giotto.prevent_sleep = FALSE), {
        expect_false(keep_awake(TRUE))
        # and nothing was started
        expect_true(is.na(.awake_pid()))
    })
})

test_that("keep_awake holds and releases a real assertion", {
    skip_if_not(nzchar(Sys.which("caffeinate")), "no caffeinate on this system")
    on.exit(keep_awake(FALSE), add = TRUE)

    expect_true(is.na(.awake_pid())) # clean start

    expect_true(keep_awake(TRUE))
    pid <- .awake_pid()
    expect_false(is.na(pid))

    # idempotent: a second call must not start a second helper
    expect_true(keep_awake(TRUE))
    expect_equal(.awake_pid(), pid)

    keep_awake(FALSE)
    Sys.sleep(0.3)
    expect_true(is.na(.awake_pid()))
})

test_that("gwith_awake releases afterwards but leaves a pre-existing hold", {
    skip_if_not(nzchar(Sys.which("caffeinate")), "no caffeinate on this system")

    # nothing held before or after
    expect_true(is.na(.awake_pid()))
    got <- gwith_awake({
        expect_false(is.na(.awake_pid())) # held inside the block
        "value"
    })
    expect_equal(got, "value") # returns the value of code
    Sys.sleep(0.3)
    expect_true(is.na(.awake_pid()))

    # an assertion we did not create must survive the block
    keep_awake(TRUE)
    on.exit(keep_awake(FALSE), add = TRUE)
    pid <- .awake_pid()
    gwith_awake(NULL)
    expect_equal(.awake_pid(), pid)
})
