# This function removes a lot of the US territories from the shapefile.
# It also re-locates ak and hawi
# This only needs to be run onece per year, or when the census releases a new shape file.

#library(sp)
#library(broom)
#library(rgdal)
#library(maptools)
#library(devtools)
#library(tigris)

# Read county shapefile from Tiger.
# https://www.census.gov/geo/maps-data/data/cbf/cbf_counties.html
county <- tigris::counties(cb = TRUE, resolution = "20m", year = 2015)

#  Convert to Lambert Azimuthal Equal Area Projection
us.map <- spTransform(county, CRS("+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 
                                  +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs"))
us.map@data$id <- rownames(us.map@data)

# Rotate and shrink ak.
ak <- us.map[us.map$STATEFP=="02",]
ak <- elide(ak, rotate=-50)
ak <- elide(ak, scale=max(apply(bbox(ak), 1, diff)) / 2.3)
ak <- elide(ak, shift=c(-2100000, -2500000))
proj4string(ak) <- proj4string(us.map)

# Rotate and Shift hawi
hawi <- us.map[us.map$STATEFP=="15",]
hawi <- elide(hawi, rotate=-35)
hawi <- elide(hawi, shift=c(5400000, -1400000))
proj4string(hawi) <- proj4string(us.map)

# Also remove Puerto Rico (72), Guam (66), Virgin Islands (78), American Samoa (60) Mariana Islands (69)
# Micronesia (64), Marshall Islands (68), Palau (70), Minor Islands (74)
us.map <- us.map[!us.map$STATEFP %in% c("02", "15", "72", "66", "78", "60", "69",
                                        "64", "68", "70", "74"),]
# Make sure other outling islands are removed.
us.map <- us.map[!us.map$STATEFP %in% c("81", "84", "86", "87", "89", "71", "76",
                                        "95", "79"),]
us.map <- rbind(us.map, ak, hawi)

# Projuce map
county_map_data <- broom::tidy(us.map, region="GEOID")
# Remove helper data and save file. Be sure to remove .Randdom.seed if exists.
rm(ak, county, hawi, us.map)
rm(.Random.seed)
# Use devtools to save data set.
devtools::use_data(county_map_data, overwrite = TRUE)
rm(county_map_data)

## County Map Mercator Projection.
# Read county shapefile from Tiger.
# https://www.census.gov/geo/maps-data/data/cbf/cbf_counties.html
county <- tigris::counties(cb = TRUE, resolution = "20m", year = 2015)

# Convert to Mercator projection.
us.map <- spTransform(county, CRS("+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0
                                    +x_0=0.0 +y_0=0 +k=1.0 +units=m +no_defs"))
us.map@data$id <- rownames(us.map@data)

# Rotate and shrink ak.
ak <- us.map[us.map$STATEFP=="02",]
ak <- elide(ak, rotate=-50)
ak <- elide(ak, scale=max(apply(bbox(ak), 1, diff)) / 2.3)
ak <- elide(ak, shift=c(-2100000, -2500000))
proj4string(ak) <- proj4string(us.map)

# Rotate and Shift hawi
hawi <- us.map[us.map$STATEFP=="15",]
hawi <- elide(hawi, rotate=-35)
hawi <- elide(hawi, shift=c(5400000, -1400000))
proj4string(hawi) <- proj4string(us.map)

# Also remove Puerto Rico (72), Guam (66), Virgin Islands (78), American Samoa (60) Mariana Islands (69)
# Micronesia (64), Marshall Islands (68), Palau (70), Minor Islands (74)
us.map <- us.map[!us.map$STATEFP %in% c("02", "15", "72", "66", "78", "60", "69",
                                        "64", "68", "70", "74"),]
# Make sure other outling islands are removed.
us.map <- us.map[!us.map$STATEFP %in% c("81", "84", "86", "87", "89", "71", "76",
                                        "95", "79"),]
us.map <- rbind(us.map, ak, hawi)

# Projuce map
county_map_merc <- broom::tidy(us.map, region="GEOID")
# Remove helper data and save file. Be sure to remove .Randdom.seed if exists.
rm(ak, county, hawi, us.map)
rm(.Random.seed)
# Use devtools to save data set.
devtools::use_data(county_map_merc, overwrite = TRUE)
rm(county_map_merc)


## State Map

# Read shapefile from Tiger
# https://www.census.gov/geo/maps-data/data/cbf/cbf_state.html
state <- tigris::states(cb = TRUE, resolution = "20m", year = 2015)

# convert it to Albers equal area
us.map <- spTransform(state, CRS("+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 
                                  +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs"))
us.map@data$id <- rownames(us.map@data)

# Extract Alaska; shrink and rotate.
ak <- us.map[us.map$STATEFP=="02",]
ak <- elide(ak, rotate=-50)
ak <- elide(ak, scale=max(apply(bbox(ak), 1, diff)) / 2.3)
ak <- elide(ak, shift=c(-2100000, -2500000))
proj4string(ak) <- proj4string(us.map)

# Extract Hawaii, shift and rotate.
hawi <- us.map[us.map$STATEFP=="15",]
hawi <- elide(hawi, rotate=-35)
hawi <- elide(hawi, shift=c(5400000, -1600000))
proj4string(hawi) <- proj4string(us.map)

# Remove Alaska and Hawaii from map
# Also remove Puerto Rico (72), Guam (66), Virgin Islands (78), American Samoa (60) Mariana Islands (69)
# Micronesia (64), Marshall Islands (68), Palau (70), Minor Islands (74)
us.map <- us.map[!us.map$STATEFP %in% c("02", "15", "72", "66", "78", "60", "69",
                                        "64", "68", "70", "74"),]
#Make sure other outling islands are removed.
us.map <- us.map[!us.map$STATEFP %in% c("81", "84", "86", "87", "89", "71", "76",
                                        "95", "79"),]
us.map <- rbind(us.map, ak, hawi)

#Projuce map
state_map_data <- broom::tidy(us.map, region="GEOID")
# Remove helper data and save file. Be sure to remove .Randdom.seed if exists.
rm(ak, state, hawi, us.map)
rm(.Random.seed)
# Use devtools to save data set.
devtools::use_data(state_map_data, overwrite = TRUE)
rm(state_map_data)

