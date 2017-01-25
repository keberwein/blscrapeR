#' Dataset with the lat. / long. of county FIPS codes used for mapping.
#'
#' Built-in dataset for use with the \code{bls_map_state()} function.
#' To access the data directly, issue the command \code{datastate_map_data)}.
#' 
#' @title Dataset for mapping U.S. states
#' @description A fortified data set that includes U.S. states and is suitable for making maps with \code{ggplot2}.
#' The county FIPS codes and boundary lines from the most recent TIGER release from the U.S. Census Bureau.
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
#' 
#' @name state_map_data
#' @usage data(state_map_data)
#' @note Last updated 2017-01-26
#' @format A data frame with 13,660 rows and 7 variables
"state_map_data"