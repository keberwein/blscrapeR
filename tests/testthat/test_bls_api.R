library(blscrapeR)
library(jsonlite)
library(httr)
library(data.table)
library(testthat)

seriesid <-  'LAUCN040010000000005'
payload <- list(seriesid = seriesid)
base_url <- "http://api.bls.gov/publicAPI/v1/timeseries/data/"

# Manually construct payload since the BLS formatting is wakey.
payload <- toJSON(payload)
loadparse <- regmatches(payload, regexpr("],", payload), invert = TRUE)
parse1 <- loadparse[[1]][1]
parse2 <- gsub("\\[|\\]", "", loadparse[[1]][2])
payload <- paste(parse1, parse2, sep = "],")

# Here's the actual API call.
jsondat <- content(POST(base_url, body = payload, content_type_json()))

if(length(jsondat$Results) > 0) {
    # Put results into data.table format.
    # Try to figure out a way to do this without importing data.table with the package.
    # Method borrowed from here:
    # https://github.com/fcocquemas/bulast/blob/master/R/bulast.R
    dt <- data.table::rbindlist(lapply(jsondat$Results$series, function(s) {
        dt <- data.table::rbindlist(lapply(s$data, function(d) {
            d[["footnotes"]] <- paste(unlist(d[["footnotes"]]), collapse = " ")
            d <- lapply(lapply(d, unlist), paste, collapse=" ")
        }), use.names = TRUE, fill=TRUE)
        dt[, seriesID := s[["seriesID"]]]
        dt
    }), use.names = TRUE, fill=TRUE)
    
    # Convert periods to dates.
    # This is for convenience--don't want to touch any of the raw data.
        dt[, date := seq(as.Date(paste(year, ifelse(period == "M13", 12, substr(period, 2, 3)), "01", sep = "-")),
                         length = 2, by = "months")[2]-1,by="year,period"]
    jsondat$Results <- dt
    df <- as.data.frame(jsondat$Results)
    df$value <- as.numeric(as.character(df$value))
    df$year <- as.numeric(as.character(df$year))
}


# Check actual fucntion
out <- blscrapeR::bls_api('LAUCN040010000000005')

testthat::expect_identical(out, df)
    