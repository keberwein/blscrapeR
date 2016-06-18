#' Dataset containing FIPS codes for mapping and lookup.
#'
#' Built-in dataset for use with the \code{bls_map} function.
#' To access the data directly, issue the command \code{datacounty_fips)}.
#' \itemize{
#'   \item \code{state}: State name
#'   \item \code{fips_state}: FIPS code for State
#'   \item \code{fips_county}: FIPS code for County
#'   \item \code{county}: County name
#'   \item \code{type}: type
#' }
#'
#' @docType data
#' @keywords internal
#' 
#'
#' @usage data(county_fips)
#' @note Last updated 2016-05-27
#' @format A data frame with 3235 rows and 5 variables
"county_fips"