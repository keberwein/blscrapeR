#' Dataset with the lat. / long. of county FIPS codes used for mapping.
#'
#' Built-in dataset for use with the \code{bls_map} function.
#' To access the data directly, issue the command \code{datastate_fips)}.

#' @title Dataset containing FIPS codes for mapping and lookup.
#' @description Built-in dataset for use with the \code{bls_map} function.
#'              To access the data directly, issue the command \code{data(datastate_fips)}.
#'
#' \itemize{
#'   \item \code{fips_state}: FIPS code for state
#'   \item \code{saa}: saa cross-walk id
#'   \item \code{region}: Geographic region
#'   \item \code{division}: Geographic division
#'   \item \code{state_abb}: State abbreviation
#'   \item \code{state}: State name
#' }
#'
#' @docType data
#' @keywords datasets
#' @name state_fips
#'
#' @usage data(state_fips)
#' @note Last updated 2016-05-27
#' @format A data frame with 63 rows and 6 variables
"state_fips"