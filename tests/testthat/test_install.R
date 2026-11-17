test_that("install modules is working", {
    suite_install("GiottoUtils", dry_run = TRUE) %>% 
        expect_message(regexp = "Utils")
    suite_install("GiottoClass", dry_run = TRUE) %>% 
        expect_message(regexp = "Class") %>% 
        expect_message(regexp = "Utils")
    suite_install("GiottoVisuals", dry_run = TRUE) %>%
        expect_message(regexp = "Visuals") %>%
        expect_message(regexp = "Class") %>%
        expect_message(regexp = "Utils")
    suite_install("Giotto", dry_run = TRUE) %>% 
        expect_message(regexp = "Visuals") %>%
        expect_message(regexp = "Class") %>%
        expect_message(regexp = "Utils") %>%
        expect_message(regexp = "Giotto")
    suite_install("GiottoData", dry_run = TRUE) %>% 
        expect_message(regexp = "Data") %>%
        expect_message(regexp = "Class") %>%
        expect_message(regexp = "Utils")
    suite_install("GiottoDB", dry_run = TRUE) %>%
        expect_message(regexp = "DB") %>%
        expect_message(regexp = "Class") %>%
        expect_message(regexp = "Utils")
    # GiottoDisk is only available with the disk ref
    suite_install("GiottoDisk", ref = "disk", dry_run = TRUE,
                  install_arrow = FALSE) %>%
        expect_message(regexp = "Disk") %>%
        expect_message(regexp = "Visuals") %>%
        expect_message(regexp = "Class") %>%
        expect_message(regexp = "Utils") %>%
        expect_message(regexp = "Giotto")
    suite_install("GiottoDisk", ref = "main", dry_run = TRUE,
                  install_arrow = FALSE) %>%
        expect_message(regexp = "Switching") %>%
        expect_message(regexp = "GiottoDisk@dev") %>%
        expect_message(regexp = "gsource")
})

test_that("install modules is working", {
    suite_install("Giotto", suite_deps = TRUE, dry_run = TRUE) %>% 
        expect_message(regexp = "Visuals") %>%
        expect_message(regexp = "Class") %>%
        expect_message(regexp = "Utils") %>%
        expect_message(regexp = "Giotto")
    suite_install("Giotto", suite_deps = FALSE, dry_run = TRUE) %>% 
        expect_message(regexp = "Giotto")
})

test_that("refs work", {
    suite_install(ref = "main", dry_run = TRUE) %>% 
        expect_message(regexp = "Utils,") %>%
        expect_message(regexp = "Class,") %>%
        expect_message(regexp = "Visuals,") %>%
        expect_message(regexp = "Giotto,")
    suite_install(ref = "dev", dry_run = TRUE) %>%
        expect_message(regexp = "dev") %>%
        expect_message(regexp = "dev") %>%
        expect_message(regexp = "dev") %>%
        expect_message(regexp = "dev")
        
    suite_install("GiottoDisk", ref = "disk", dry_run = TRUE,
                  install_arrow = FALSE) %>%
        expect_message(regexp = "GiottoUtils@dev") %>%
        expect_message(regexp = "GiottoClass@gsource") %>%
        expect_message(regexp = "GiottoVisuals@gsource") %>%
        expect_message(regexp = "Giotto@gsource") %>%
        expect_message(regexp = "GiottoDisk@dev")
    # aliases
    suite_install("GiottoClass", ref = "gsource", suite_deps = FALSE,
                  dry_run = TRUE) %>%
        expect_message(regexp = "GiottoClass@gsource")
    suite_install("GiottoClass", ref = "giottodisk", suite_deps = FALSE,
                  dry_run = TRUE) %>%
        expect_message(regexp = "GiottoClass@gsource")

    suite_install(ref = "R4.4.0", dry_run = TRUE) %>%
        expect_message(regexp = "R4.4.0") %>%
        expect_message(regexp = "R4.4.0") %>%
        expect_message(regexp = "R4.4.0") %>%
        expect_message(regexp = "R4.4.0")
    suite_install(ref = "R4.1.0", dry_run = TRUE) %>%
        expect_message(regexp = "R4.1.0") %>%
        expect_message(regexp = "R4.1.0") %>%
        expect_message(regexp = "R4.1.0") %>%
        expect_message(regexp = "R4.1.0")
    # shorthand
    suite_install(ref = 440, dry_run = TRUE) %>%
        expect_message(regexp = "R4.4.0") %>%
        expect_message(regexp = "R4.4.0") %>%
        expect_message(regexp = "R4.4.0") %>%
        expect_message(regexp = "R4.4.0")
    suite_install(ref = 410, dry_run = TRUE) %>%
        expect_message(regexp = "R4.1.0") %>%
        expect_message(regexp = "R4.1.0") %>%
        expect_message(regexp = "R4.1.0") %>%
        expect_message(regexp = "R4.1.0")
})

test_that("tilework and arrow are reachable from any ref", {
    for (ref in c("main", "dev", "disk", "R4.4.0", "R4.1.0")) {
        suite_install("tilework", ref = ref, dry_run = TRUE) %>%
            expect_message(regexp = "\"tilework\".*drieslab\\.r-universe")
        expect_no_error(
            suite_install("arrow", ref = ref, dry_run = TRUE,
                          install_arrow = FALSE)
        )
    }
    # only auto-added for GiottoDisk
    msgs <- capture_messages(suite_install("Giotto", dry_run = TRUE))
    expect_false(any(grepl("tilework", msgs)))
    msgs <- capture_messages(
        suite_install("GiottoDisk", dry_run = TRUE, install_arrow = FALSE)
    )
    installs <- grep("install_github|install\\.packages", msgs, value = TRUE)
    expect_true(grepl("tilework", installs[1]))
    msgs <- capture_messages(
        suite_install("GiottoDisk", suite_deps = FALSE, dry_run = TRUE)
    )
    expect_false(any(grepl("tilework", msgs)))
})

test_that("disk_full installs the pipeline from the disk branches", {
    msgs <- capture_messages(
        suite_install(ref = "disk_full", dry_run = TRUE, install_arrow = FALSE)
    )
    installs <- grep("install_github|install\\.packages", msgs, value = TRUE)
    github <- c(
        "GiottoUtils@dev", "GiottoClass@gsource", "GiottoVisuals@gsource",
        "Giotto@gsource", "GiottoDisk@dev", "giotto-suite/GiottoLens,"
    )
    runiverse <- c(
        "tilework", "GiottoKernels", "GiottoIngest", "smotifrs", "smotif",
        "cosmxscan", "spatialDWLS", "sedonadb"
    )
    for (x in github) {
        expect_true(any(grepl(x, installs, fixed = TRUE)), info = x)
    }
    for (x in runiverse) {
        expect_true(
            any(grepl(sprintf("install.packages(\"%s\"", x), installs,
                fixed = TRUE)),
            info = x
        )
    }
    expect_length(installs, length(github) + length(runiverse))
    # dependencies before dependents, the viewer last
    expect_match(installs[1], "tilework")
    expect_match(installs[length(installs)], "GiottoLens")
    # case-insensitive like the other refs
    expect_identical(
        capture_messages(
            suite_install(ref = "DISK_FULL", dry_run = TRUE,
                install_arrow = FALSE)
        ),
        msgs
    )
})

test_that("GiottoLens switches to the disk ref", {
    suite_install("GiottoLens", ref = "main", dry_run = TRUE) %>%
        expect_message(regexp = "GiottoLens requested. Switching") %>%
        expect_message(regexp = "giotto-suite/GiottoLens")
})

test_that("r-universe installs list the suite universes and CRAN", {
    repos <- .runiverse_repos("drieslab")
    expect_identical(unname(repos), c(
        "https://drieslab.r-universe.dev",
        "https://giotto-suite.r-universe.dev",
        "https://cloud.r-project.org"
    ))
    # another owner's universe only for its own package
    expect_true("https://apache.r-universe.dev" %in% .runiverse_repos("apache"))
    expect_false(any(grepl("apache", .runiverse_repos("giotto-suite"))))
    suite_install("sedonadb", dry_run = TRUE) %>%
        expect_message(regexp = "\"sedonadb\".*apache\\.r-universe")
})

test_that("install_arrow gates the arrow install", {
    for (status in c("missing", "no_zstd")) {
        expect_error(.arrow_install_plan(status), "install_arrow = TRUE")
        expect_error(.arrow_install_plan(status), "r-universe")
        expect_false(.arrow_install_plan(status, FALSE))
        expect_true(.arrow_install_plan(status, TRUE))
    }
    for (x in list(NULL, TRUE, FALSE)) {
        expect_false(.arrow_install_plan("ok", x))
    }
    expect_error(.arrow_install_plan("missing", NA), "must be NULL")
    expect_message(.install_arrow_zstd(dry_run = TRUE), "ARROW_WITH_ZSTD")
})
