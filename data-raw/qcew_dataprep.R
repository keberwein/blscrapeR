# These come from the QCEW API documentation.
# http://data.bls.gov/cew/doc/access/csv_data_slices.htm
# http://data.bls.gov/cew/doc/titles/area/area_titles.htm
# http://data.bls.gov/cew/doc/titles/size/size_titles.htm
# http://data.bls.gov/cew/doc/titles/industry/industry_titles.htm

area_titles <- read.csv("area_titles.csv")
niacs <- read.csv("niacs.csv")
size_titles <- read.csv("size_titles.csv")

devtools::use_data(area_titles, area_titles)
devtools::use_data(niacs, niacs)
devtools::use_data(size_titles, size_titles)

rm(area_titles, niacs, size_titles)