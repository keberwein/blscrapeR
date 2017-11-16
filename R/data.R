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
#' @note Last updated 2017-11-15
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
#' @note Last updated 2016-09-30
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
#' @note Last updated 2016-05-27
#' @format A data frame with 3235 rows and 5 variables
"county_fips"


#' Dataset containing NIACS codes for industry lookups.
#'
#' Built-in dataset to look up industries by NIACS code.
#' To access the data directly, issue the command \code{niacs)}.
#' \itemize{
#'   \item \code{industry_code}: Industry code
#'   \item \code{industry_title}: Industry title
#' }
#'
#' @docType data
#' @keywords internal
#' 
#'
#' @usage data(niacs)
#' @note Last updated 2016-09-30
#' @format A data frame with 2469 rows and 2 variables
"niacs"


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
#' @note Last updated 2016-09-30
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
#' @note Last updated 2016-05-27
#' @format A data frame with 57 rows and 4 variables
"state_fips"


#' Dataset with the lat. / long. of county FIPS codes used for mapping.
#'
#' Built-in dataset for use with the \code{bls_map_county()} function.
#' To access the data directly, issue the command \code{data(county_map_merc)}.
#' 
#' @title Dataset for mapping U.S. counties with a Mercator projection
#' @description A fortified data set that includes U.S. counties and is suitable for making maps with \code{ggplot2}.
#' The county FIPS codes and boundary lines from the most recent TIGER release from the U.S. Census Bureau.
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
#' 
#' @name county_map_data
#' @usage data(county_map_merc)
#' @note Last updated 2017-01-26
#' @format A data frame with 55,413 rows and 7 variables
"county_map_merc"


#' Dataset with the lat. / long. of county FIPS codes used for mapping.
#'
#' Built-in dataset for use with the \code{bls_map_county()} function.
#' To access the data directly, issue the command \code{data(county_map_data)}.
#' 
#' @title Dataset for mapping U.S. counties
#' @description A fortified data set that includes U.S. counties and is suitable for making maps with \code{ggplot2}.
#' The county FIPS codes and boundary lines from the most recent TIGER release from the U.S. Census Bureau.
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
#' 
#' @name county_map_data
#' @usage data(county_map_data)
#' @note Last updated 2017-01-26
#' @format A data frame with 55,413 rows and 7 variables
"county_map_data"


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