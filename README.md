<!-- README.md is generated from README.Rmd. Please edit that file -->
    ## Warning: package 'jsonlite' was built under R version 3.2.5

    ## Warning: package 'httr' was built under R version 3.2.5

blscrapeR
=========

[![Build Status](https://travis-ci.org/keberwein/blscrapeR.png?branch=master)](https://travis-ci.org/keberwein/blscrapeR) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/blscrapeR)](http://www.r-pkg.org/badges/version/blscrapeR)

Designed to be a better API wrapper for the Bureau of Labor Statistics (BLS.) The package has additional functions to help parse, analyze and visualize the data. With fundamental ideas borrowed from the `acs` package, which has similar functionality with he Census Bureau API.

Install
-------

-   The latest development version from Github with

``` r
devtools::install_github("keberwein/blscrapeR")
```

Before getting started, you’ll probably want to head over to the BLS and get [set up with an API key](http://data.bls.gov/registrationEngine/). While an API key is not required to use the package, the query limits are much higher if you have a key and you’ll have access to more data. Plus, it’s free (as in beer), so why not?

Very Basic Usage
----------------

For “quick and dirty” type of analysis, The package has some quick functions that will pull metrics from the API without series numbers. These quick functions include unemployment, employment, and civilian labor force on a national level.

``` r
# Grab the Unemployment Rate (U-3) 
df <- quick_unemp_rate()
tail(df, 5)
#>    year period periodName value footnotes    seriesID       date
#> 26 2016    M05        May   4.7           LNS14000000 2016-05-31
#> 27 2016    M04      April   5.0           LNS14000000 2016-04-30
#> 28 2016    M03      March   5.0           LNS14000000 2016-03-31
#> 29 2016    M02   February   4.9           LNS14000000 2016-02-29
#> 30 2016    M01    January   4.9           LNS14000000 2016-01-31
```

**DISCLAIMER:** Some working knowledge of BLS series numbers are required here. The BLS [claims](http://www.bls.gov/developers/api_faqs.htm#signatures3) that they “do not currently have a catalog of series IDs.” As doubtful as that statement is, there’s not much we can do about it. The [BLS Data Finder website](http://beta.bls.gov/dataQuery/search) is a good place to nail down the series numbers I’m looking for.

API Keys
--------

Before you get any further, you should really consider getting an API key form the BLS, why? More data, that’s why! The package has a function to install your key in your `.Renviron` so you’ll only have to worry about it once. Plus, it will add extra security by not having your key hard-coded in your scripts for all the world to see.

### From the BLS:

<table style="width:111%;">
<colgroup>
<col width="34%" />
<col width="37%" />
<col width="38%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">Service</th>
<th align="left">Version 2.0 (Registered)</th>
<th align="left">Version 1.0 (Unregistered)</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">Daily query limit</td>
<td align="left">500</td>
<td align="left">25</td>
</tr>
<tr class="even">
<td align="left">Series per query limit</td>
<td align="left">50</td>
<td align="left">25</td>
</tr>
<tr class="odd">
<td align="left">Years per query limit</td>
<td align="left">20</td>
<td align="left">10</td>
</tr>
<tr class="even">
<td align="left">Net/Percent Changes</td>
<td align="left">Yes</td>
<td align="left">No</td>
</tr>
<tr class="odd">
<td align="left">Optional annual averages</td>
<td align="left">Yes</td>
<td align="left">No</td>
</tr>
<tr class="even">
<td align="left">Series descriptions</td>
<td align="left">Yes</td>
<td align="left">No</td>
</tr>
</tbody>
</table>

### Key Install

``` r
set_bls_key("111111abc")
# First time, relead your enviornment so you can use the key without restarting R.
readRenviron("~/.Renviron")
# You can check it with:
Sys.getenv("BLS_KEY")
```

Advanced Usage
--------------

Now that you have an API key installed, you can call your key in the package’s function arguments with `"BLS_KEY"`. Don't forget the quotes! If you just HAVE to have your key hard-coded in your scripts, you can also pass they key as a string.

``` r
# Amount spent on all items vs. amount spent on education. 
# Seasonally adjusted from the Consumer Price Index
df <- bls_api(c("CUSR0000SA0", "CUSR0000SAE"),
               startyear = 1995, endyear = 2015,
               registrationKey = "BLS_KEY")
```

``` r
# A little help from ggplot2!
library(ggplot2)
gg<- ggplot(df,
       aes(x=date, y=value, color=seriesID)) +
    geom_line()
```

![](https://www.datascienceriot.com/wp-content/uploads/2016/07/fig1.png)

Mapping
-------

Much like the the “quick functions” for requesting data without series ids, there are two map functions, `bls_map_county` and `bls_map_state`. These functions are designed to work with two specifically designed helper functions `get_bls_county` and get `get_bls_state`. Each helper function downloads recent data for unemployment rate, unemployment level, employment rate, employment level and civilian labor force. **Note:** Even though the `get_bls` functions return data in the correct formats, the `bls_map` functions can be used with any data set that includes FIPS codes.

The example below maps the current unemployment rate by county. Note, that Alaska and Hawaii have to re-located. To save space. This is a "quick function," if you would like your map formatted differently, please see the Advanced Mapping section in the documentation.

``` r
# Grap the data in a pre-formatted data frame.
df <- get_bls_county()

#Use map function with arguments.
bls_map_county(map_data = df, fill_rate = "unemployed_rate", 
               labtitle = "Unemployment Rate by County")
```

![](https://www.datascienceriot.com/wp-content/uploads/2016/07/fig2.png)
