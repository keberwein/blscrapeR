#' Dataset with the lat. / long. of county FIPS codes used for mapping.
#'
#' Built-in dataset for use with the \code{bls_map} function.
#' To access the data directly, issue the command \code{datastate_map)}.

#' @title Dataset with the lat. / long. of county FIPS codes used for mapping.
#' @description Built-in dataset for use with the \code{bls_map} function.
#'              To access the data directly, issue the command \code{data(datastate_map)}.
#'
#' \itemize{
#'   \item \code{long}: State longitude
#'   \item \code{lat}: State latitude
#'   \item \code{order}: Polygon order
#'   \item \code{hole}: hole
#'   \item \code{piece}: Polygon piece
#'   \item \code{id}: FIPS Code
#'   \item \code{group}: group
#' }
#'
#' @docType data
#' @keywords datasets
#' @name state_map
#'
#' @usage data(state_map)
#' @note Last updated 2016-05-26
#' @format A data frame with 206,500 rows and 7 variables
"state_map"