<!-- README.md is generated from README.Rmd. Please edit that file -->
blscrapeR
=========

[![Build Status](https://travis-ci.org/keberwein/blscrapeR.png?branch=master)](https://travis-ci.org/keberwein/blscrapeR) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/blscrapeR)](http://www.r-pkg.org/badges/version/blscrapeR)

Designed to be a better API wrapper for the Bureau of Labor Statistics (BLS.) The package has additional functions to help parse, analyze and visualize the data. With fundamental ideas borrowed from the `acs` package, which has similar functionality with he Census Bureau API.

Install:

-   The latest development version from Github with

``` r
    devtools::install_github("keberwein/blscrapeR")
#> Downloading GitHub repo keberwein/blscrapeR@master
#> from URL https://api.github.com/repos/keberwein/blscrapeR/zipball/master
#> Installing blscrapeR
#> Installing 3 packages: httr, jsonlite, mime
#> 
#> The downloaded binary packages are in
#>  /var/folders/92/7393ygc56fb3lvhglk3sr8vw0000gp/T//RtmpxWYrs6/downloaded_packages
#> '/Library/Frameworks/R.framework/Resources/bin/R' --no-site-file  \
#>   --no-environ --no-save --no-restore --quiet CMD INSTALL  \
#>   '/private/var/folders/92/7393ygc56fb3lvhglk3sr8vw0000gp/T/RtmpxWYrs6/devtools3b0329504d7/keberwein-blscrapeR-88fe73c'  \
#>   --library='/Library/Frameworks/R.framework/Versions/3.2/Resources/library'  \
#>   --install-tests
#> 
#> Reloading installed blscrapeR
```

Before getting started, you’ll probably want to head over to the BLS and get [set up with an API key](http://data.bls.gov/registrationEngine/). While an API key isn’t required to use the package, the query limits are much higher if you have a key and you’ll have access to more data. Plus, it’s free (as in beer), so why not?

Very Basic Usage
----------------

``` r
# Grab the Unemployment Rate (U-3) 
df <- bls_api("LNS14000000")
df
#>    year period periodName value footnotes    seriesID       date
#> 1  2015    M12   December   5.0           LNS14000000 2015-12-31
#> 2  2015    M11   November   5.0           LNS14000000 2015-11-30
#> 3  2015    M10    October   5.0           LNS14000000 2015-10-31
#> 4  2015    M09  September   5.1           LNS14000000 2015-09-30
#> 5  2015    M08     August   5.1           LNS14000000 2015-08-31
#> 6  2015    M07       July   5.3           LNS14000000 2015-07-31
#> 7  2015    M06       June   5.3           LNS14000000 2015-06-30
#> 8  2015    M05        May   5.5           LNS14000000 2015-05-31
#> 9  2015    M04      April   5.4           LNS14000000 2015-04-30
#> 10 2015    M03      March   5.5           LNS14000000 2015-03-31
#> 11 2015    M02   February   5.5           LNS14000000 2015-02-28
#> 12 2015    M01    January   5.7           LNS14000000 2015-01-31
#> 13 2014    M12   December   5.6           LNS14000000 2014-12-31
#> 14 2014    M11   November   5.8           LNS14000000 2014-11-30
#> 15 2014    M10    October   5.7           LNS14000000 2014-10-31
#> 16 2014    M09  September   6.0           LNS14000000 2014-09-30
#> 17 2014    M08     August   6.2           LNS14000000 2014-08-31
#> 18 2014    M07       July   6.2           LNS14000000 2014-07-31
#> 19 2014    M06       June   6.1           LNS14000000 2014-06-30
#> 20 2014    M05        May   6.2           LNS14000000 2014-05-31
#> 21 2014    M04      April   6.2           LNS14000000 2014-04-30
#> 22 2014    M03      March   6.7           LNS14000000 2014-03-31
#> 23 2014    M02   February   6.7           LNS14000000 2014-02-28
#> 24 2014    M01    January   6.6           LNS14000000 2014-01-31
#> 25 2016    M06       June   4.9           LNS14000000 2016-06-30
#> 26 2016    M05        May   4.7           LNS14000000 2016-05-31
#> 27 2016    M04      April   5.0           LNS14000000 2016-04-30
#> 28 2016    M03      March   5.0           LNS14000000 2016-03-31
#> 29 2016    M02   February   4.9           LNS14000000 2016-02-29
#> 30 2016    M01    January   4.9           LNS14000000 2016-01-31
```

Easy right? DISCLAIMER: Some working knowledge of BLS series numbers are required here. The BLS [claims](http://www.bls.gov/developers/api_faqs.htm#signatures3) that they “do not currently have a catalogue of series IDs.” As doubtful as that statement is, there’s not much we can do about it. I’ve found the [BLS Data Finder website](http://beta.bls.gov/dataQuery/search) is a good place to nail down the series numbers I’m looking for.
