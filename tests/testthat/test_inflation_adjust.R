library(blscrapeR)

test_that("inflation_adjust errors when base_date is NA", {
    expect_error(inflation_adjust(base_date = NA), "base_date argument is required")
})

test_that("inflation_adjust errors on invalid date format", {
    expect_error(inflation_adjust(base_date = "2015"), "yyyy-mm-dd format")
    expect_error(inflation_adjust(base_date = "01-01-2015"), "yyyy-mm-dd format")
    expect_error(inflation_adjust(base_date = "Jan 2015"), "yyyy-mm-dd format")
})

test_that("inflation_adjust errors when base_date is before 1947", {
    expect_error(inflation_adjust(base_date = "1946-12-01"), "greater than 1947-01-01")
    expect_error(inflation_adjust(base_date = "1900-01-01"), "greater than 1947-01-01")
})

test_that("inflation_adjust returns data for a valid base_date", {
    # Skip on CRAN: inflation_adjust calls the live BLS API to fetch
    # current CPI data, which requires network access and counts against
    # the daily rate limit.
    skip_on_cran()
    result <- inflation_adjust(base_date = "2015-01-01")
    expect_s3_class(result, "data.frame")
    expect_true(nrow(result) > 0)
    expect_true("adj_dollar_value" %in% colnames(result))
    expect_true("month_ovr_month_pct_change" %in% colnames(result))
    expect_true("date" %in% colnames(result))
})
