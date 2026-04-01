## Update

This is an update to blscrapeR 4.0.1, which is currently on CRAN.

### Changes in this version

* Fixed multiple bugs in `inflation_adjust()`: incorrect `month_ovr_month_pct_change` values, crash on API failure, and a data duplication issue.
* Updated deprecated `tidyr::spread()` usages to `tidyr::pivot_wider()`.
* Removed outdated `.travis.yml` CI configuration.

## Test environments
* windows-latest (R release)
* ubuntu-latest (R devel)
* ubuntu-latest (R release)
* macos-latest (R release)

## R CMD check results

0 errors | 0 warnings | 1 note (future file timestamps)

## Notes:
Found the following (possibly) invalid URLs:
  URL: https://www.bls.gov/
    From: DESCRIPTION
    Status: 403
    Message: Forbidden

  * This URL is valid and accessible in a browser. The BLS web server returns 403 to automated/non-browser requests.

