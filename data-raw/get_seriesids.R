# Get LN ids
# Read the table
doc <- data.table::fread("https://download.bls.gov/pub/time.series/ln/ln.series")
# We don't need all the columns.
ln_dat <- dplyr::select(doc, series_title, series_id, periodicity_code, seasonal, begin_year, begin_period, end_year, end_period)

#Get LE ids
doc <- data.table::fread("https://download.bls.gov/pub/time.series/le/le.series")
le_dat <- dplyr::select(doc, series_title, series_id, fips_code, seasonal, begin_year, begin_period, end_year, end_period)
