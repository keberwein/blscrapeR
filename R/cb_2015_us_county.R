#' Dataset with the lat. / long. of county FIPS codes used for mapping.
#'
#' Built-in dataset for use with the \code{bls_map} function.
#' To access the data directly, issue the command \code{datacb_2015_us_county)}.

#' @title Dataset with the lat. / long. of county FIPS codes used for mapping.
#' @description Built-in dataset for use with the \code{bls_map} function.
#'              To access the data directly, issue the command \code{data(datacb_2015_us_county)}.
#'
#' \itemize{
#'   \item \code{long}: County longitude
#'   \item \code{lat}: County latitude
#'   \item \code{order}: Polygon order
#'   \item \code{hole}: hole
#'   \item \code{piece}: Polygon piece
#'   \item \code{id}: FIPS Code
#'   \item \code{group}: group
#' }
#'
#' @docType data
#' @keywords datasets
#' @name cb_2015_us_county
#'
#' @usage data(cb_2015_us_county)
#' @note Last updated 2016-05-26
#' @format A data frame with 206,500 rows and 7 variables
"cb_2015_us_county"
