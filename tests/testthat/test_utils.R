library(blscrapeR)

test_that("firstupper capitalizes the first letter", {
    expect_equal(firstupper("hello"), "Hello")
    expect_equal(firstupper("already"), "Already")
})

test_that("firstupper handles single character", {
    expect_equal(firstupper("a"), "A")
    expect_equal(firstupper("Z"), "Z")
})

test_that("firstupper preserves the rest of the string", {
    expect_equal(firstupper("hELLO"), "HELLO")
})
