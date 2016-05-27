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
#'   \item \code{state}: State abbreviation
#'   \item \code{state_name}: State name
#'   \item \code{gnisid}: Geographic Names Information System ID
#' }
#'
#' @docType data
#' @keywords datasets
#' @name state_fips
#'
#' @usage data(state_fips)
#' @note Last updated 2016-05-27
#' @format A data frame with 57 rows and 4 variables
"state_fips"