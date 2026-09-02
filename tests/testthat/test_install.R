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
    suite_install("GiottoDisk", ref = "disk", dry_run = TRUE) %>%
        expect_message(regexp = "Disk") %>%
        expect_message(regexp = "Visuals") %>%
        expect_message(regexp = "Class") %>%
        expect_message(regexp = "Utils") %>%
        expect_message(regexp = "Giotto")
    suite_install("GiottoDisk", ref = "main", dry_run = TRUE) %>%
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
        
    suite_install("GiottoDisk", ref = "disk", dry_run = TRUE) %>%
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
