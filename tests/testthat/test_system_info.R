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

# Tests that hold a real assertion must never run on a machine we do not own:
# they suppress sleep on the check host for as long as they run. `caffeinate`
# is present on the CRAN and Bioconductor macOS builders, so availability alone
# is not a sufficient guard.
skip_unless_own_machine <- function() {
    skip_on_cran()
    skip_on_ci()
    skip_if_not(nzchar(Sys.which("caffeinate")), "no caffeinate on this system")
}

# The command choice is pure, so it can be tested anywhere including CI.
test_that(".awake_cmd picks the right mechanism per platform", {
    mac <- .awake_cmd("osx", pid = 4242)
    expect_equal(mac$cmd, "caffeinate")
    # the assertion must be bound to a pid, which is what makes it self-cleaning
    expect_true("-w" %in% mac$args)
    expect_true("4242" %in% mac$args)

    expect_null(.awake_cmd("windows"))
    expect_null(.awake_cmd("some-future-os"))

    lin <- .awake_cmd("linux", pid = 4242)
    if (nzchar(Sys.which("systemd-inhibit"))) {
        expect_equal(lin$cmd, "systemd-inhibit")
        # systemd-inhibit holds its lock for as long as the command it runs, so
        # that command must be the thing bound to our pid -- otherwise the lock
        # survives a crashed session and no session can tell its helper apart
        # from another's
        expect_true("--pid" %in% lin$args)
        expect_true("4242" %in% lin$args)
        expect_false("infinity" %in% lin$args)
    } else {
        expect_null(lin)
    }

    # binding to a pid is what stops a lock outliving the session
    for (os in c("osx", "linux")) {
        cmd <- .awake_cmd(os, pid = 4242)
        if (!is.null(cmd)) {
            expect_true("4242" %in% cmd$args, info = os)
        }
    }
})

# Regression test for the `pgrep -f` discovery this replaced, which matched
# something on Linux when no helper existed. Reported as a hold, that sent
# keep_awake(TRUE) down the "already holding" branch and it never started
# anything. Pure, so it runs on every platform -- which is the point, since the
# false positive only ever appeared on one of them.
test_that(".awake_pid reports nothing when this session started nothing", {
    expect_true(is.na(.awake_pid()))
    expect_type(.awake_pid(), "integer")
})

test_that(".awake_pid does not report a helper that has since died", {
    skip_on_cran()
    pid <- as.integer(system("sleep 30 </dev/null >/dev/null 2>&1 & echo $!",
        intern = TRUE
    ))
    on.exit(
        {
            tools::pskill(pid)
            .awake_state$pid <- NA_integer_
        },
        add = TRUE
    )

    .awake_state$pid <- pid
    expect_equal(.awake_pid(), pid)

    tools::pskill(pid)
    Sys.sleep(0.3)
    expect_true(is.na(.awake_pid())) # reaped, not reported as a live hold
})

test_that("keep_awake respects the giotto.prevent_sleep kill switch", {
    gwith_options(list(giotto.prevent_sleep = FALSE), {
        expect_false(keep_awake(TRUE))
        # and nothing was started
        expect_true(is.na(.awake_pid()))
    })
})

test_that("the kill switch gates taking a hold, not releasing one", {
    skip_unless_own_machine()
    on.exit(keep_awake(FALSE), add = TRUE)

    expect_true(keep_awake(TRUE))
    expect_false(is.na(.awake_pid()))

    # setting the option after the fact must not strand the assertion
    gwith_options(list(giotto.prevent_sleep = FALSE), {
        keep_awake(FALSE)
    })
    Sys.sleep(0.3)
    expect_true(is.na(.awake_pid()))
})

test_that("keep_awake holds and releases a real assertion", {
    skip_unless_own_machine()
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
    skip_unless_own_machine()

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
