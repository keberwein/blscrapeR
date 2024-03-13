library(data.table)
library(dplyr)
library(devtools)
library(stringr)

# Get LNS ids from CPS Employment and Unemployment.
doc <- data.table::fread("https://download.bls.gov/pub/time.series/ln/ln.series")
# We don't need all the columns.
ln_dat <- dplyr::select(doc, series_title, series_id, seasonal, periodicity_code) %>% distinct() %>%
    # Capitalize all words--makes it easier to search later.
    dplyr::mutate(series_title =  stringr::str_to_title(series_title)) %>%
    mutate(series_id = trimws(series_id, "right"))


# Get LE ids from CPS Hourly Weekly Earnings.
doc <- data.table::fread("https://download.bls.gov/pub/time.series/le/le.series")
le_dat <-dplyr::select(doc, series_title, series_id, seasonal, begin_period) %>%
    dplyr::mutate(periodicity_code = stringr::str_sub(begin_period, 1,1)) %>% distinct() %>%
    dplyr::select(series_title, series_id, seasonal, periodicity_code) %>%
    dplyr::mutate(series_title =  stringr::str_to_title(series_title)) %>%
    mutate(series_id = trimws(series_id, "right"))



# Get LAS unemployment series from LAUS. Local Area Unemployment Statistics.
doc <- data.table::fread("https://download.bls.gov/pub/time.series/la/la.series")
la_dat <- dplyr::select(doc, series_title, series_id, seasonal, begin_period) %>%
    dplyr::mutate(periodicity_code = stringr::str_sub(begin_period, 1,1)) %>% distinct() %>%
    dplyr::select(series_title, series_id, seasonal, periodicity_code) %>%
    dplyr::mutate(series_title =  stringr::str_to_title(series_title)) %>%
    mutate(series_id = trimws(series_id, "right"))

series_ids <- dplyr::bind_rows(ln_dat, le_dat, la_dat)

rm(doc, ln_dat, le_dat, la_dat)

usethis::use_data(series_ids, overwrite = TRUE)




