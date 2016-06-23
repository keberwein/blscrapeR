# blscrapeR 0.3.2

## New Features

* Revised the map prep in `data-raw` to render smaller data frames, thereby making the total package size much smaller.

* Added a label title argument to map functions `bls_map_state()` and `bls_map_county()`

* Standardized colnames in all returned data frames throughout the package.

## Deprecated Features

* Truncated the `inflation()` function for now. The API seems to return adjusted dollar-values.

## Documentation

* Made documentation for helper functions invisable in the manual.

* Added News.Rd


# blscrapeR 0.3.1

## New Features

* Changed name of `county_map()` to avoid conflicts with other packages. I didn't mark this as a major release becasue no other functions in the package are dependant on this.

* Various fixes in map functions including removing unused themes and general code tidyness.

## Documentation

* Various fixes to examples.

* Made descriptions more robust.


# blscrapeR 0.3.0

## Major Changes

* Changed name of `get_data()` to `bls_api()` to avoid any problems in the global environment. Bumped the version to 0.3.0 because this is the primary workhorse function of the package.


# blscrapeR 0.2.1

## New Features

* Added custom maps rendered from shape files

## Major Changes

* Removed shape files from package data to cut down on size. This fundamentaly changes the way the mapping functions work. Opted instead, for spacial poly data frames rendered from the shapefiles.


# blscrapeR 0.2.0

## Major Changes

* Complete re-write of old `get_data()` function to pull from API only.

* Added arguments to `get_data()` to pass the BLS API perams.


# blscrapeR 0.1.0

## New features

* Added `bls_state_data()` function to pull most recent sate-level employment data for mapping.

* Added arguments to `get_data()` to pass the BLS API perams.

* Added documentation for data sets.

## Bug Fixes

* Fixed `zoo::index()` error.

