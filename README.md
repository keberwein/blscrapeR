<!-- README.md is generated from README.Rmd. Please edit that file -->
blscrapeR
=========

[![Build Status](https://travis-ci.org/keberwein/blscrapeR.png?branch=master)](https://travis-ci.org/keberwein/blscrapeR) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/blscrapeR)](http://www.r-pkg.org/badges/version/blscrapeR) [![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)

Designed to be a better API wrapper for the Bureau of Labor Statistics (BLS.) The package has additional functions to help parse, analyze and visualize the data. Fundamental ideas borrowed from the `acs` package, which has similar functionality for the Census Bureau API.

Install
-------

-   Stable version from CRAN:

``` r
install.packages("blscrapeR")
```

-   The latest development version from GitHub:

``` r
devtools::install_github("keberwein/blscrapeR")
```

Before getting started, you’ll probably want to head over to the BLS and [get set up](http://data.bls.gov/registrationEngine/) with an API key. While an API key is not required to use the package, the query limits are much higher if you have a key and you’ll have access to more data. Plus, it’s free (as in beer), so why not?

Basic Usage
-----------

For “quick and dirty” type of analysis, the package has some quick functions that will pull metrics from the API without series numbers. These quick functions include unemployment, employment, and civilian labor force on a national level.

``` r
library(blscrapeR)
# Grab the Unemployment Rate (U-3) 
df <- quick_unemp_rate()
tail(df, 5)
#>    year period periodName value footnotes    seriesID
#> 21 2015    M05        May   5.5           LNS14000000
#> 22 2015    M04      April   5.4           LNS14000000
#> 23 2015    M03      March   5.4           LNS14000000
#> 24 2015    M02   February   5.5           LNS14000000
#> 25 2015    M01    January   5.7           LNS14000000
```

**DISCLAIMER:** Some working knowledge of BLS series numbers are required here. The BLS [claims](http://www.bls.gov/developers/api_faqs.htm#signatures3) that they “do not currently have a catalog of series IDs.” The [BLS Data Finder website](http://beta.bls.gov/dataQuery/search) is a good place to nail down the series numbers we're looking for.

API Keys
--------

You should consider [getting an API key](http://data.bls.gov/registrationEngine/) form the BLS. The package has a function to install your key in your `.Renviron` so you’ll only have to worry about it once. Plus, it will add extra security by not having your key hard-coded in your scripts for all the world to see.

### From the BLS:

| Service                  | Version 2.0 (Registered) | Version 1.0 (Unregistered) |
|--------------------------|--------------------------|----------------------------|
| Daily query limit        | 500                      | 25                         |
| Series per query limit   | 50                       | 25                         |
| Years per query limit    | 20                       | 10                         |
| Net/Percent Changes      | Yes                      | No                         |
| Optional annual averages | Yes                      | No                         |
| Series descriptions      | Yes                      | No                         |

### Key Install

``` r
library(blscrapeR)
set_bls_key("YOUR_KEY_IN_QUOTATIONS")
# First time, reload your enviornment so you can use the key without restarting R.
readRenviron("~/.Renviron")
# You can check it with:
Sys.getenv("BLS_KEY")
```

Note: The above script will add a line to your `.Renviron` file to be re-used when ever you are in the package. If you are not comfortable with that, you can add the following line to your `.Renviron` file manually to produce the same result.

`BLS_KEY='YOUR_KEY_IN_SINGLE_QUOTES'`

Advanced Usage
--------------

Now that you have an API key installed, you can call your key in the package’s function arguments with `"BLS_KEY"`. Don't forget the quotes! If you just HAVE to have your key hard-coded in your scripts, you can also pass they key as a string.

``` r
library(blscrapeR)
# Median Usual Weekly Earnings by Occupation, Unadjusted Second Quartile.
# In current dollars
df <- bls_api(c("LEU0254530800", "LEU0254530600"),
                startyear = 2000, endyear = 2015,
                registrationKey = "BLS_KEY") %>%
    dateCast()
```

``` r
# A little help from ggplot2!
library(ggplot2)
ggplot(df, aes(x=date, y=value, color=seriesID)) +
    geom_line() +
    labs(title = "Median Weekly Earnings by Occupation") +
    theme(legend.position="top") +
    scale_color_discrete(name="Occupation",
        breaks=c("LEU0254530800", "LEU0254530600"),
        labels=c("Database Admins.", "Software Devs."))
```

![](https://www.datascienceriot.com/wp-content/uploads/2016/07/blscrape_docfig1.png)

*For more advanced usage, please see the [package vignettes](https://github.com/keberwein/blscrapeR/tree/master/vignettes).*

Basic Mapping
-------------

Like the the “quick functions” for requesting API data, there are two "quick" map functions, `bls_map_county()` and `bls_map_state()`. These functions are designed to work with two helper functions `get_bls_county()` and get `get_bls_state()`. Each helper function downloads recent data for unemployment rate, unemployment level, employment rate, employment level and civilian labor force. These functions do not pull data from the API, rather they pull data from text files and *do not* count against daily query limits.

**Note:** Even though the `get_bls` functions return data in the correct formats, the `bls_map` functions can be used with any data set that includes FIPS codes.

The example below maps the current unemployment rate by county. Alaska and Hawaii have to re-located to save space.

``` r
library(blscrapeR)
# Grap the data in a pre-formatted data frame.
# If no argument is passed to the function it will load the most recent month's data.
df <- get_bls_county()

#Use map function with arguments.
bls_map_county(map_data = df, fill_rate = "unemployed_rate", 
               labtitle = "Unemployment Rate by County")
```

![](https://www.datascienceriot.com/wp-content/uploads/2016/07/blscrape_docfig3.png)

Advanced Mapping
----------------

What's R mapping without some interactivity? Below we’re using two additional packages, `leaflet`, which is popular for creating interactive maps and `tigris`, which allows us to download the exact shape files we need for these data and includes a few other nice tools.

``` r
# Leaflet map
library(blscrapeR)
library(tigris)
library(leaflet)
map.shape <- counties(cb = TRUE, year = 2015)
df <- get_bls_county()

# Slice the df down to only the variables we need and rename "fips" colunm
# so I can get a cleaner merge later.
df <- df[, c("unemployed_rate", "fips")]
colnames(df) <- c("unemployed_rate", "GEOID")

# Merge df with spatial object.
leafmap <- geo_join(map.shape, df, by="GEOID")

# Format popup data for leaflet map.
popup_dat <- paste0("<strong>County: </strong>", 
                    leafmap$NAME, 
                    "<br><strong>Value: </strong>", 
                    leafmap$unemployed_rate)

pal <- colorQuantile("YlOrRd", NULL, n = 20)
# Render final map in leaflet.
leaflet(data = leafmap) %>% addTiles() %>%
    addPolygons(fillColor = ~pal(unemployed_rate), 
                fillOpacity = 0.8, 
                color = "#BDBDC3", 
                weight = 1,
                popup = popup_dat)
```

**Note:** This is just a static image since the full map would not be as portable for the purpose of documentation.

![](https://www.datascienceriot.com/wp-content/uploads/2016/07/blscrape_docfig3-1.png)
