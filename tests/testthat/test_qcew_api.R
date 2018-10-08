library(blscrapeR)
library(testthat)

year=2017; qtr=1; slice="industry"; sliceCode="5112";
baseURL <- "https://data.bls.gov/cew/data/api/"
url <- paste0(baseURL, year, "/", qtr, "/", slice, "/", sliceCode, ".csv")
temp <- tempfile()
download.file(url, temp, quiet = TRUE)
qcewDat <- read.csv(temp, fill=TRUE, header=TRUE, sep=",", stringsAsFactors=FALSE,
                    strip.white=TRUE)

# Check actual fucntion
out <- blscrapeR::qcew_api(year=2017, qtr=1, slice="industry", sliceCode=5112)
testthat::expect_identical(out, qcewDat)
