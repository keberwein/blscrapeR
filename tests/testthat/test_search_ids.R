library(blscrapeR)

test_that("search_ids returns results for a known keyword", {
    result <- search_ids(keyword = "Unemployment Rate")
    expect_s3_class(result, "tbl_df")
    expect_true(nrow(result) > 0)
})

test_that("search_ids returns results for multiple keywords", {
    result <- search_ids(keyword = c("Unemployment Rate", "Women"))
    expect_s3_class(result, "tbl_df")
    expect_true(nrow(result) > 0)
})

test_that("search_ids returns empty tibble for nonsense keyword", {
    result <- search_ids(keyword = "xyznonexistent123")
    expect_s3_class(result, "tbl_df")
    expect_equal(nrow(result), 0)
})

test_that("search_ids messages when keyword is NULL", {
    expect_message(search_ids(keyword = NULL), "enter a keyword")
})
