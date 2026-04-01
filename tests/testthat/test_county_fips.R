library(blscrapeR)

test_that("county_fips returns data for a valid state", {
    result <- county_fips("FL")
    expect_s3_class(result, "tbl_df")
    expect_true(nrow(result) > 0)
    expect_true("state" %in% colnames(result))
    expect_true(all(result$state == "FL"))
})

test_that("county_fips handles lowercase input", {
    result <- county_fips("fl")
    expect_true(nrow(result) > 0)
    expect_true(all(result$state == "FL"))
})

test_that("county_fips handles input with whitespace", {
    result <- county_fips("  TX  ")
    expect_true(nrow(result) > 0)
    expect_true(all(result$state == "TX"))
})

test_that("county_fips errors on invalid state abbreviation", {
    expect_error(county_fips("ZZ"), "Invalid state abbreviation")
})

test_that("county_fips errors on empty string", {
    expect_error(county_fips(""), "Invalid state abbreviation")
})

test_that("county_fips works for territories", {
    result <- county_fips("DC")
    expect_true(nrow(result) > 0)
})
