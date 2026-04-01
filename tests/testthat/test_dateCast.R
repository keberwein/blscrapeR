library(blscrapeR)

# Build a minimal data frame resembling bls_api() output
make_api_df <- function(years, periods, values) {
    data.frame(
        year = years,
        period = periods,
        value = values,
        stringsAsFactors = FALSE
    )
}

test_that("dateCast converts monthly periods to dates", {
    df <- make_api_df(
        years   = c(2020, 2020, 2020),
        periods = c("M01", "M06", "M12"),
        values  = c(1, 2, 3)
    )
    result <- dateCast(df)
    expect_true("date" %in% colnames(result))
    expect_equal(result$date, as.Date(c("2020-01-01", "2020-06-01", "2020-12-01")))
})

test_that("dateCast handles M13 (annual average) as December", {
    df <- make_api_df(years = 2021, periods = "M13", values = 5)
    result <- dateCast(df)
    expect_equal(result$date, as.Date("2021-12-01"))
})

test_that("dateCast handles quarterly periods", {
    df <- make_api_df(
        years   = rep(2022, 4),
        periods = c("Q01", "Q02", "Q03", "Q04"),
        values  = 1:4
    )
    result <- dateCast(df)
    expect_equal(
        result$date,
        as.Date(c("2022-01-01", "2022-04-01", "2022-07-01", "2022-10-01"))
    )
})

test_that("dateCast applies custom dt_format", {
    df <- make_api_df(years = 2020, periods = "M03", values = 1)
    result <- dateCast(df, dt_format = "%Y/%m/%d")
    expect_equal(result$date, "2020/03/01")
})

test_that("dateCast warns when required columns are missing", {
    df <- data.frame(value = 1)
    expect_message(dateCast(df), "year.*period")
})
