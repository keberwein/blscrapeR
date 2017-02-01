library(blscrapeR)
library(jsonlite)
library(httr)
library(testthat)

seriesid <-  'LAUCN040010000000005'
payload <- list(seriesid = seriesid)
base_url <- "https://api.bls.gov/publicAPI/v1/timeseries/data/"

# Manually construct payload since the BLS formatting is wakey.
payload <- toJSON(payload)
loadparse <- regmatches(payload, regexpr("],", payload), invert = TRUE)
parse1 <- loadparse[[1]][1]
parse2 <- gsub("\\[|\\]", "", loadparse[[1]][2])
payload <- paste(parse1, parse2, sep = "],")

# Here's the actual API call.
jsondat <- content(POST(base_url, body = payload, content_type_json()))

if(length(jsondat$Results) > 0) {
    # Method borrowed from here:
    # https://github.com/fcocquemas/bulast/blob/master/R/bulast.R
    dt <- do.call("rbind",lapply(jsondat$Results$series, function(s) {
        dt <- do.call("rbind", lapply(s$data, function(d) {
            d[["footnotes"]] <- paste(unlist(d[["footnotes"]]), collapse = " ")
            d[["seriesID"]] <- paste(unlist(s[["seriesID"]]), collapse = " ")
            d <- lapply(lapply(d, unlist), paste, collapse=" ")
        }))
    }))
    jsondat$Results <- dt
    df <- as.data.frame(jsondat$Results)
    df$value <- as.numeric(as.character(df$value))
    if ("year" %in% colnames(df)){
        df$year <- as.numeric(as.character(df$year))
    }
}


# Check actual fucntion
out <- blscrapeR::bls_api('LAUCN040010000000005')

testthat::expect_identical(out, df)
    