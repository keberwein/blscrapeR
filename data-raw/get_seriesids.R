library(data.table)
library(dplyr)

# Get LNS ids from CPS Employment and Unemployment.
doc <- data.table::fread("https://download.bls.gov/pub/time.series/ln/ln.series")
# We don't need all the columns.
ln_dat <- dplyr::select(doc, series_title, series_id, periodicity_code, seasonal, begin_year, begin_period, end_year, end_period)

# Get LE ids from CPS Hourly Weekly Earnings.
doc <- data.table::fread("https://download.bls.gov/pub/time.series/le/le.series")
le_dat <- dplyr::select(doc, series_title, series_id, fips_code, seasonal, begin_year, begin_period, end_year, end_period)

# Get LAS unemployment series from LAUS. Local Area Unemployment Statistics.
doc <- data.table::fread("https://download.bls.gov/pub/time.series/ln/ln.series")
la_dat <- dplyr::select(doc, series_title, series_id, seasonal, begin_year, begin_period, end_year, end_period)