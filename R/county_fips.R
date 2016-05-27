#' Dataset containing FIPS codes for mapping and lookup.
#'
#' Built-in dataset for use with the \code{bls_map} function.
#' To access the data directly, issue the command \code{datacounty_fips)}.

#' @title Dataset containing FIPS codes for mapping and lookup.
#' @description Built-in dataset for use with the \code{bls_map} function.
#'              To access the data directly, issue the command \code{data(datacounty_fips)}.
#'
#' \itemize{
#'   \item \code{fips_county}: Combined FIPS code for county + state
#'   \item \code{state}: State name
#'   \item \code{county}: County name
#' }
#'
#' @docType data
#' @keywords datasets
#' @name county_fips
#'
#' @usage data(county_fips)
#' @note Last updated 2016-05-27
#' @format A data frame with 3085 rows and 3 variables
"county_fips"