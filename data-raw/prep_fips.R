library(maps)
library(data.table)

# Grab FIPS codes from the maps package. Warning, county names sometimes change.
state_fips <- state.fips
names(state_fips) <- c("fips_state", "ssa", "region", "division", "state_abb", "state")
#Get the FIPS code: Have to add leading zeros to any single digit number and combine them.
state_fips$fips_state <- formatC(state_fips$fips_state, width = 2, format = "d", flag = "0")
# Make sure there's no Random.seed. Build will fail.
rm(.Random.seed)
# Use devtools to save data set.
devtools::use_data(state_fips, overwrite = TRUE)
rm(state_fips)


# Do the same thing with county FIPS
county_fips <- county.fips
county_fips$polyname <- as.character(county_fips$polyname)
setDT(county_fips)[, paste0("polyname", 1:2) := tstrsplit(county_fips$polyname, ",")]
colnames(county_fips) <- c("fips_county", "oldname","state", "county")
county_fips <- county_fips[, oldname:=NULL]
# Make sure there's no Random.seed. Build will fail.
rm(.Random.seed)
# Use devtools to save data set.
devtools::use_data(county_fips, overwrite = TRUE)
rm(county_fips)

