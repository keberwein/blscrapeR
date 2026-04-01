library(blscrapeR)

test_that("bls_api returns data for a valid series", {
    # Skip on CRAN: this calls the live BLS API which has daily rate limits
    # and requires network access that may not be available in CRAN check environments.
    skip_on_cran()
    df <- bls_api("LAUCN040010000000005")
    expect_s3_class(df, "data.frame")
    expect_true(nrow(df) > 0)
    expect_true("year" %in% colnames(df))
    expect_true("period" %in% colnames(df))
    expect_true("value" %in% colnames(df))
    expect_true("seriesID" %in% colnames(df))
    expect_type(df$value, "double")
    expect_type(df$year, "double")
})

test_that("bls_api returns data with startyear and endyear", {
    skip_on_cran() # Requires live BLS API access; see above.
    df <- bls_api("LAUCN040010000000005", startyear = 2020, endyear = 2021)
    expect_s3_class(df, "data.frame")
    expect_true(nrow(df) > 0)
    expect_true(all(df$year %in% c(2020, 2021)))
})

test_that("bls_api handles multiple series", {
    skip_on_cran() # Requires live BLS API access; see above.
    df <- bls_api(c("LAUCN040010000000005", "LAUCN040010000000006"))
    expect_s3_class(df, "data.frame")
    expect_true(nrow(df) > 0)
    expect_true(length(unique(df$seriesID)) == 2)
})

test_that("bls_api sets endyear automatically when only startyear given", {
    skip_on_cran() # Requires live BLS API access; see above.
    expect_message(
        df <- bls_api("LAUCN040010000000005", startyear = 2020),
        "endyear argument has automatically been set"
    )
    expect_s3_class(df, "data.frame")
})
