#library(utils)

# 2015 FIPS:
# This will have to be examined every year for county name changes.
fileUrl <- "http://www2.census.gov/geo/docs/reference/codes/files/national_county.txt"
download.file(fileUrl, destfile="county_fips.txt", method="curl")

county_fips<-read.csv('county_fips.txt',
                    header=FALSE,
                    sep=",",
                    colClasses = "character")

names(county_fips) <- c("state", "fips_state", "fips_county", "county", "type")
# Make sure there's no Random.seed. Build will fail.
rm(.Random.seed)
rm(fileUrl)
# Use devtools to save data set.
devtools::use_data(county_fips, overwrite = TRUE)
rm(county_fips)


# Do the same thing with county FIPS.
fileUrl <- "http://www2.census.gov/geo/docs/reference/state.txt"
download.file(fileUrl, destfile="state_fips.txt", method="curl")

state_fips<-read.csv('state_fips.txt',
                      header=TRUE,
                      sep="|",
                      colClasses = "character")
names(state_fips) <- c("fips_state", "state_abb", "state", "gnisid")
# Make sure there's no Random.seed. Build will fail.
rm(.Random.seed)
rm(fileUrl)
# Use devtools to save data set.
devtools::use_data(state_fips, overwrite = TRUE)
rm(state_fips)
