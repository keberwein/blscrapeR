<!-- README.md is generated from README.Rmd. Please edit that file -->
blscrapeR <img src="man/figures/blscrapeR_hex.png" align="right" />
===================================================================

[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/blscrapeR)](https://www.r-pkg.org/badges/version/blscrapeR) [![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)

Designed to be a tidy API wrapper for the Bureau of Labor Statistics (BLS.) The package has additional functions to help parse, analyze and visualize the data. The package utilizes "tidyverse" concepts for internal functionality and encourages the use of those concepts with the output data.

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
head(df, 5)
#> # A tibble: 5 x 6
#>    year    period periodName value footnotes  seriesID
#>   <dbl>    <list>     <list> <dbl>    <list>    <list>
#> 1  2017 <chr [1]>  <chr [1]>   4.1 <chr [1]> <chr [1]>
#> 2  2017 <chr [1]>  <chr [1]>   4.2 <chr [1]> <chr [1]>
#> 3  2017 <chr [1]>  <chr [1]>   4.4 <chr [1]> <chr [1]>
#> 4  2017 <chr [1]>  <chr [1]>   4.3 <chr [1]> <chr [1]>
#> 5  2017 <chr [1]>  <chr [1]>   4.4 <chr [1]> <chr [1]>
```

Search BLS IDs
--------------

Some knowledge of BLS ids are needed to query the API. The package includes a "fuzzy search" function to help find these ids. There are currently more than 75,000 series ids in the package's internal data set, `series_ids`. While these aren't all the series ids the BLS offers, it contains the most popular. The [BLS Data Finder](https://beta.bls.gov/dataQuery/search) is another good resource for finding series ids, that may not be in the internal data set.

``` r
library(blscrapeR)
# Find series ids relating to the total labor force in LA.
ids <- search_ids(keyword = c("Labor Force", "Los Angeles"))
head(ids)
#> # A tibble: 6 x 4
#>                                                                  series_title
#>                                                                         <chr>
#> 1 Labor Force: Balance Of California, State Less Los Angeles-Long Beach-Glend
#> 2  Labor Force: Los Angeles-Long Beach-Glendale, Ca Metropolitan Division (S)
#> 3 Labor Force: Balance Of California, State Less Los Angeles-Long Beach-Glend
#> 4       Labor Force: Los Angeles-Long Beach, Ca Combined Statistical Area (U)
#> 5                                     Labor Force: Los Angeles County, Ca (U)
#> 6                                       Labor Force: Los Angeles City, Ca (U)
#> # ... with 3 more variables: series_id <chr>, seasonal <chr>,
#> #   periodicity_code <chr>
```

``` r
library(blscrapeR)
# Find series ids relating to median weekly earnings of women software developers.
ids <- search_ids(keyword = c("Earnings", "Software", "Women"))
head(ids)
#> # A tibble: 1 x 4
#>                                                                  series_title
#>                                                                         <chr>
#> 1 (Unadj)- Median Usual Weekly Earnings (Second Quartile), Employed Full Time
#> # ... with 3 more variables: series_id <chr>, seasonal <chr>,
#> #   periodicity_code <chr>
```

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

### Download Multiple BLS Series at Once

``` r
library(blscrapeR)

# Grab several data sets from the BLS at onece.
# NOTE on series IDs: 
# EMPLOYMENT LEVEL - Civilian labor force - LNS12000000
# UNEMPLOYMENT LEVEL - Civilian labor force - LNS13000000
# UNEMPLOYMENT RATE - Civilian labor force - LNS14000000
df <- bls_api(c("LNS12000000", "LNS13000000", "LNS14000000"),
              startyear = 2008, endyear = 2017, Sys.getenv("BLS_KEY")) %>%
    # Add time-series dates
    dateCast()
```

``` r
# Plot employment level
library(ggplot2)
gg1200 <- subset(df, seriesID=="LNS12000000")
library(ggplot2)
ggplot(gg1200, aes(x=date, y=value)) +
    geom_line() +
    labs(title = "Employment Level - Civ. Labor Force")
```

![](https://github.com/keberwein/keberwein.github.io/blob/master/images/bls_img/emplevelggreadme.png?raw=true)

### Median Weekly Earnings

``` r
library(blscrapeR)
library(tidyverse)
# Median Usual Weekly Earnings by Occupation, Unadjusted Second Quartile.
# In current dollars
df <- bls_api(c("LEU0254530800", "LEU0254530600"), startyear = 2000, endyear = 2016, registrationKey = Sys.getenv("BLS_KEY")) %>%
    spread(seriesID, value) %>% dateCast()
```

``` r
# A little help from ggplot2!
library(ggplot2)
ggplot(data = df, aes(x = date)) + 
    geom_line(aes(y = LEU0254530800, color = "Database Admins.")) +
    geom_line(aes(y = LEU0254530600, color = "Software Devs.")) + 
    labs(title = "Median Weekly Earnings by Occupation") + ylab("value") +
    theme(legend.position="top", plot.title = element_text(hjust = 0.5)) 
```

![](https://github.com/keberwein/keberwein.github.io/blob/master/images/bls_img/blscrape_docfig1.png?raw=true)

*For more advanced usage, please see the [package vignettes](https://github.com/keberwein/blscrapeR/tree/master/vignettes).*




