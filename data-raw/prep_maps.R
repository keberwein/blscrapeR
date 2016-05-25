#TODO
# Lookup fips code function
# Dataset containing historic unemployment, employment state/national

library(sp)
library(ggplot2)
library(rgeos)
library(rgdal)
library(maptools)

# Read county shapefile from Tiger.
# https://www.census.gov/geo/maps-data/data/cbf/cbf_counties.html
county <- readOGR(dsn = "cb_2015_us_county_5m", layer = "cb_2015_us_county_5m")

# convert it to Albers equal area
us_aea <- spTransform(county, CRS("+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 
                                  +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs"))
us_aea@data$id <- rownames(us_aea@data)

# extract, then rotate, shrink & move alaska (and reset projection)
# need to use state IDs via # https://www.census.gov/geo/reference/ansi_statetables.html
alaska <- us_aea[us_aea$STATEFP=="02",]
alaska <- elide(alaska, rotate=-50)
alaska <- elide(alaska, scale=max(apply(bbox(alaska), 1, diff)) / 2.3)
alaska <- elide(alaska, shift=c(-2100000, -2500000))
proj4string(alaska) <- proj4string(us_aea)

# extract, then rotate & shift hawaii
hawaii <- us_aea[us_aea$STATEFP=="15",]
hawaii <- elide(hawaii, rotate=-35)
hawaii <- elide(hawaii, shift=c(5400000, -1400000))
proj4string(hawaii) <- proj4string(us_aea)

# Also remove Puerto Rico (72), Guam (66), Virgin Islands (78), American Samoa (60) Mariana Islands (69)
# Micronesia (64), Marshall Islands (68), Palau (70), Minor Islands (74)
us_aea <- us_aea[!us_aea$STATEFP %in% c("02", "15", "72", "66", "78", "60", "69",
                                        "64", "68", "70", "74"),]
# Make sure other outling islands are removed.
us_aea <- us_aea[!us_aea$STATEFP %in% c("81", "84", "86", "87", "89", "71", "76",
                                        "95", "79"),]
us_aea <- rbind(us_aea, alaska, hawaii)

# Projuce map
county_map <- fortify(us_aea, region="GEOID")
# Remove helper data and save file. Be sure to remove .Randdom.seed if exists.
rm(alaska, county, hawaii, us_aea)
rm(.Random.seed)
# Use devtools to save data set.
devtools::use_data(county_map, overwrite = TRUE)
rm(county_map)


## State Map

# Read shapefile from Tiger
# https://www.census.gov/geo/maps-data/data/cbf/cbf_state.html
state <- readOGR(dsn = "cb_2015_us_state_5m", layer = "cb_2015_us_state_5m")

# convert it to Albers equal area
us_aea <- spTransform(state, CRS("+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 
                                  +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs"))
us_aea@data$id <- rownames(us_aea@data)

# extract, then rotate, shrink & move alaska (and reset projection)
# need to use state IDs via # https://www.census.gov/geo/reference/ansi_statetables.html
alaska <- us_aea[us_aea$STATEFP=="02",]
alaska <- elide(alaska, rotate=-50)
alaska <- elide(alaska, scale=max(apply(bbox(alaska), 1, diff)) / 2.3)
alaska <- elide(alaska, shift=c(-2100000, -2500000))
proj4string(alaska) <- proj4string(us_aea)

# extract, then rotate & shift hawaii
hawaii <- us_aea[us_aea$STATEFP=="15",]
hawaii <- elide(hawaii, rotate=-35)
hawaii <- elide(hawaii, shift=c(5400000, -1400000))
proj4string(hawaii) <- proj4string(us_aea)

#Also remove Puerto Rico (72), Guam (66), Virgin Islands (78), American Samoa (60) Mariana Islands (69)
#Micronesia (64), Marshall Islands (68), Palau (70), Minor Islands (74)
us_aea <- us_aea[!us_aea$STATEFP %in% c("02", "15", "72", "66", "78", "60", "69",
                                        "64", "68", "70", "74"),]
#Make sure other outling islands are removed.
us_aea <- us_aea[!us_aea$STATEFP %in% c("81", "84", "86", "87", "89", "71", "76",
                                        "95", "79"),]
us_aea <- rbind(us_aea, alaska, hawaii)

#Projuce map
state_map <- fortify(us_aea, region="GEOID")
# Remove helper data and save file. Be sure to remove .Randdom.seed if exists.
rm(alaska, state, hawaii, us_aea)
rm(.Random.seed)
# Use devtools to save data set.
devtools::use_data(state_map, overwrite = TRUE)
rm(state_map)



