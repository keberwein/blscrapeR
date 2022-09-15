# blscrapeR 3.2.2

## Bug Fixes

* Addressed changes made by the BLS for the QEW data sets.

* Fixed typos in documentation.

* Added return values to documentation.

* Changed examples so automated CRAN testing won't exhaust daily API limit.


# blscrapeR 3.2.0

## Features

* Added the ability for `inflation_adjust()` function to extend to data before 1947. Using the old base, the data now extents to 1913.

* Added a new `naics` data set. This is meant to replace the old `niacs` data set, which was mis-spelled. The old data set remains in place for backward compatibility.


# blscrapeR 3.1.6

## Testing

* Nightly API tests on various platforms caused error due to reaching daily query limit. Removed automated test runs in favor of testing manually.

# blscrapeR 3.1.5

## Documentation

* Converted BLS hyperlinks to https.

* Fixed various dead hyperlinks.

# blscrapeR 3.1.4

## Bug fixes

* Fixed area in testing module where `qcew_api()` function was pulling improper dates.

## Enhancements

* Added logic to `qcew_api()` that throws a warning if user attempts to query dates outside of the API's range.

Updated NIACS and FIPS codes for 2018.

# blscrapeR 3.1.3

## Bug fixes

* Fixed case issue in qcew annual data.

# blscrapeR 3.1.2

## Enhancements

Updated NIACS and FIPS codes for 2018.

## Bug fixes

* The API sometimes adds an extra column for the most current month, which was causing irregular column shifts. Added logic to the map loop to automatically adjust for such situations.

# blscrapeR 3.1.1

## Bug fixes

* The `bls_api()` function now returns the catalog data with a `catalog=TRUE` argument.

## Enhancements

* The `bls_api()` function now returns verbose error message if the api request fails.

* Added BLS `series_ids` internal data set.

* Added `search_ids()` function to search the internal series_ids data set.

# blscrapeR 3.0.1

## Bug Fixes

* Added an functionality and documentation for an "annual" argument for `qcew_api()`.

## Vignettes

* Added new feature examples to QCEW_API.Rmd.

* Removed qcew.Rmd, since it was duplicated.

# blscrapeR 3.0

## New Features

* Added the map_bls() function. This function replaces the deprecated bls_map_county() bls_map_state() functions and is not backward compatible.

* Updated internal data to 2016 FIPS standards.

## Enhancements

* Updated internal functions to use tidyverse methods. This includes the addition of a few dependencies such as purrr, tibble, and dplyr.

* All data are now returned as tibbles.

## Documentation

* Updated all existing vignettes to use tidyverse functions.

* Edited mapping vignette to include new `map_bls()` function.

* Added tidyverse style code to the readme and vignettes.

# blscrapeR 2.1.5

* Document and vignette fixes

# blscrapeR 2.1.4

## New Features
* Added total non-farm employment as a "quick function."

* Added a dt_format argument to the dateCast() function.

# blscrapeR 2.1.3

## New Features
* Added the compound pipe operator from the magrittr package to exported functions.

## Enhancements
* Added urlExists as a utility function for more robust error handling.

* Added try/catch to url downloads.


# blscrapeR 2.1.2
## New Features
* The ability to select custom choropleth colors with all map functions.

* Automatic end dates set for bls_api() function.

* Removed dependencies for xts and zoo packages. Changed to base R.

## Bug fixes
* Fixed error when rendering national maps with county-wise data.

* Alaska and Hawaii moved further apart in map_data.

* Date column changed to optional for bls_api() function.

# blscrapeR 2.1.1

## New Features
* Added a map projection argument to the bls_map_county() function. Choices are either Lambert or Mercator. Mercator is the default for single states, and Lambert the default for national views.

* Enhanced error handling for the get_bls_state() function.

## Data
* Added Mercator projection data set.

## Bug Fixes
* Fixed date parsing with the get_bls_state() function.


# blscrapeR 2.0.0

## Major Release
* The BLS changed their servers from http to https. API protocols changed in accordance.

# blscrapeR 1.0.2.9000

## Bug Fixes
* FIPS fix for the get_bls_state() function.


# blscrapeR 1.0.2

## Bug Fixes
* Updated URLs for the get_bls_state() function.

## Tets
* Updated tests for the get_bls_state() function.


# blscrapeR 1.0.1

## Major Release
* The BLS changed the location of their county level employment data on the server side. Changes were made in the get_bls_county() function that were not backwards compatible.

## New Features
* Added the qcew_api() function to gather data from the BLS Quarterly Census of Employment and Wages. This API is owned by the QCEW and is separate from the main BLS API.

* Added 404 error handling to the main bls_api() function.

## Data
* Added three data sets; niacs, size_titles, and area_titles. These data sets act as helpers for the QCEW API and provide industry and area codes that the API regularly uses.

## Bug Fixes
* Updated URLs for the get_bls_county() function.

## Documentation
* Added documentation for the qcew_api() function.

* Added documentation for the three new data sets; niacs, size_titles, and area_titles.

* Added a vignette for the qcew_api() function.

## Tets
* Added a test for the qcew_api() function.


# blscrapeR 0.4.2

## New Features
* Added stateName argument to get_bls_county() that allows user to specify a state or list of states.

* Added stateName argument to map_bls_county() that allows user to specify state(s) to map.

## Documentation
* Added mapping vignette.

* Added manual pages for the `county_map_data` and `state_map_data` internal data sets.

## Data
* Added tigris and broom packages to prep_maps.R in data-raw folder.

## Bug Fixes
* Fixed date argument in get_bls_county() and get_bls_state() to return the most recent date if argument is NULL.

* Added error handling to map_bls_state() and map_bls_county().

* Added tests for map_bls_state() and map_bls_county() to the /testthat directory.


# blscrapeR 0.4.1

## New Features

* Added quick functions to pull popular data sets from the API without the need of the user inputting a series id.

* Added data argument to get_bls_county. If NULL the function will return the most recent month.

* Added the inflation_adjust() function to help users with calculating inflation from the CPI. Since the API will only allow twenty years of data, the inflation function pulls data from a text file instead that allows the user to get CPI data back to 1947.

* Added more error handling to bls_api() function.

## Documentation

* Added documentation to get_bls_county() to explain the new date argument.

* Added package vignettes.


# blscrapeR 0.4.0

## Major Changes
* Added the `set_bls_key()` function to be used with the `bls_api()` function. The new function writes the user's api key to the Renviron.
The change is backward compatible since the user is sill able to enter their api key as a string. However, for security purposes, the stored key method is preferred and should be promoted.

* Added testthat directory and added `test_bls_api.R`. The tests won't affect anything in the package functionality, but will be useful for future testing.

## Deprecated Features
* Truncated the `bls_state_data()` function and added those features to the `get_bls_state()` function.

* Removed dplyr from imports since it's not necessary anymore. Added leaflet and cron to package recommends.

## Documentation
* Renamed `blscrape.R` to `bls_api.R` since the `bls_api()` function was the only function in that file.

* Added testthat to recommends.


# blscrapeR 0.3.2

## New Features

* Revised the map prep in `data-raw` to render smaller data frames, thereby making the total package size much smaller.

* Added a label title argument to map functions `bls_map_state()` and `bls_map_county()`

* Standardized colnames in all returned data frames throughout the package.

## Deprecated Features

* Truncated the `inflation()` function for now. The API seems to return adjusted dollar-values.

## Documentation

* Made documentation for helper functions invisible in the manual.

* Added News.Rd


# blscrapeR 0.3.1

## New Features

* Changed name of `county_map()` to avoid conflicts with other packages. I didn't mark this as a major release because no other functions in the package are dependent on this.

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

* Removed shape files from package data to cut down on size. This fundamentally changes the way the mapping functions work. Opted instead, for spacial poly data frames rendered from the shape files.


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

