#' Dataset containing BLS series ids and descriptions.
#'
#' Built-in dataset to look up BLS series ids and descriptions.
#' Currently limited to the CPS and LAUS.
#' To access the data directly, issue the command \code{series_ids)}.
#'
#' @docType data
#' @keywords internal
#' 
#'
#' @usage data(series_ids)
#' @note Last updated 2024-03-13
"series_ids"


#' Dataset containing FIPS codes for counties, states and MSAs.
#'
#' Built-in dataset to look up areas by FIPS code.
#' Includes recent and historical FIPS codes.
#' To access the data directly, issue the command \code{area_titles)}.
#' \itemize{
#'   \item \code{area_fips}: FIPS code
#'   \item \code{area_title}: Area name
#' }
#'
#' @docType data
#' @keywords internal
#' 
#'
#' @usage data(area_titles)
#' @note Last updated 2024-03-13
#' @format A data frame with 4723 rows and 2 variables
"area_titles"


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
#' @note Last updated 2024-03-13
#' @format A data frame with 3235 rows and 5 variables
"county_fips"


#' Dataset containing NIACS codes for industry lookups.
#'
#' Built-in dataset to look up industries by NAICS code.
#' To access the data directly, issue the command \code{naics)}.
#' \itemize{
#'   \item \code{industry_code}: Industry code
#'   \item \code{industry_title}: Industry title
#' }
#'
#' @docType data
#' @keywords internal
#' 
#'
#' @usage data(naics)
#' @note Last updated 2024-03-13
#' @format A data frame with 2469 rows and 2 variables
"naics"



#' Dataset containing size codes for US industries by size.
#'
#' Built-in dataset to look up industries by size.
#' To access the data directly, issue the command \code{size_titles)}.
#' \itemize{
#'   \item \code{size_code}: Size code
#'   \item \code{size_title}: Size title
#' }
#'
#' @docType data
#' @keywords internal
#' 
#'
#' @usage data(size_titles)
#' @note Last updated 2024-03-13
#' @format A data frame with 10 rows and 2 variables
"size_titles"


#' Dataset with the lat. / long. of county FIPS codes used for mapping.
#'
#' @description Built-in dataset for use with the \code{bls_map} function.
#' To access the data directly, issue the command \code{datastate_fips)}.
#' 
#'
#' \itemize{
#'   \item \code{fips_state}: FIPS code for state
#'   \item \code{state_abb}: State abbreviation
#'   \item \code{state}: State name
#'   \item \code{gnisid}: Geographic Names Information System ID
#' }
#'
#' @docType data
#' @keywords internal
#' 
#'
#' @usage data(state_fips)
#' @note Last updated 2024-03-13
#' @format A data frame with 57 rows and 4 variables
"state_fips"

#' Dataset containing All items in U.S. city average, all urban consumers, seasonally adjusted CUSR0000SA0.
#'
#' Built-in dataset to look CPI values by month.
#' Includes recent and historical CPI values.
#' To access the data directly, issue the command \code{cu_main)}.
#' \itemize{
#'   \item \code{date}: Date in yyyy-mm-dd format
#'   \item \code{period}: Monthly period
#'   \item \code{year}: CPI year
#'   \item \code{value}: CPI value
#' }
#'
#' @docType data
#' @keywords internal
#' 
#'
#' @usage data(cu_main)
#' @note Last updated 2024-03-24
#' @format A data frame with 926 rows and 4 variables
"cu_main"