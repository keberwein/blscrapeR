#
#' @title choropleth mapping of BLS data
#' @description Return a ggplot object to render a choropleth map with state and/or county outlines.
#' The map files contain 2016 FIPS codes and can be used with any data set containing
#' county and state FIPS codes. They can not be used with the leaflet package but the shape files can be
#' downloaded from the Census website or with the \code{tigris} package. See the "Mapping BLS Data" vignette for this package.
#' @keywords bls api economics unemployment map geo geography
#' @import ggplot2
#' @import grDevices
#' @import utils
#' @param map_data Dataframe to be used as the map's measures. Usually a result of 
#' calls to the \code{get_bls_county()} or \code{get_bls_state()} functions, but other dataframes, 
#' which include FIPS codes may be used as well.
#' @param fill_rate Column name from the dataframe that you want to use as a fill value, in quotes. NOTE: This argument is mandatory!
#' @param stateName Optional argument if you only want to map a single state or a group of selected states. The argument
#' accepts state full state names in quotes.
#' @param labtitle The main title label for your map passed as a string. The default is no title.
#' @param projection Choices of map projection are "lambert" or "mercator". By default, the function selects Lambert for county data and
#' Mercator for single states.
#' and Lambert for nationwide views.
#' @param lowFill The fill color of the lower values being mapped. The default color is green, but can be changed to any color accepted by
#' \code{ggplot2::scale_fill_gradient}.
#' @param highFill The fill color of the higher values being mapped. The default color is green, but can be changed to any color accepted by
#' \code{ggplot2::scale_fill_gradient}.
#' @seealso \url{https://cran.r-project.org/package=tigris}
#' @examples
#' \dontrun{
#' # Download the most current month unemployment statistics on a county level.
#' df <- get_bls_county()
#' 
#' # Map the unemployment rate by county.
#' bls_gg <- map_bls(map_data = df, fill_rate = "unemployed_rate", 
#'                  labtitle = "Unemployment Rate")
#' bls_gg
#'  
#' # Map the unemployment rate for Florida and Alabama.
#' 
#' df <- get_bls_county(stateName = c("Florida", "Alabama"))
#' 
#' bls_gg <- map_bls(map_data=df, fill_rate = "unemployed_rate", 
#' stateName = c("Florida", "Alabama"))
#' 
#' bls_gg
#' 
#' 
#' # Downlaod state employment statistics for April 2016.
#' df <- get_bls_state("April 2016", seasonality = TRUE)
#' 
#' # Map the unemployment rate from data set.
#' bls_gg <- map_bls(map_data = df, fill_rate = "unemployed_rate", 
#'              labtitle = "Unemployment Rate")
#' bls_gg
#' 
#' }
#'
#' @export

map_bls <- function(map_data, fill_rate=NULL, labtitle=NULL, stateName=NULL, projection=NULL, lowFill="green", highFill="red"){
    if (is.null(fill_rate)){
        stop(message("Please specify a fill_rate in double quotes. What colunm in your data frame do you want to map?"))
    }
    # Set some dummy variables. This keeps CRAN check happy.
    map=long=lat=id=group=county_map_data=NULL
    # Attempt to assume if the dataframe is state or county level by colnames.
    if("gnisid" %in% names(map_data)){
        #Load pre-formatted map for ggplot.
        map <- blscrapeR::state_map_data
        #Unemployment statistics by county: Get and process data.
        #Plot
        suppressWarnings(ggplot2::ggplot() + 
            ggplot2::geom_map(data=map, map=map, ggplot2::aes(x=long, y=lat, map_id=id, group=group)) +
            ggplot2::geom_map(data=map_data, map=map, ggplot2::aes_string(map_id="fips_state", fill=fill_rate), color="#0e0e0e", size=0.25) +
            ggplot2::scale_fill_gradient(low=lowFill, high=highFill, na.value="grey50") +
            ggplot2::labs(title=labtitle) + 
            ggplot2::theme(axis.line=ggplot2::element_blank(), axis.text.x=ggplot2::element_blank(), axis.text.y=ggplot2::element_blank(), 
                           axis.ticks=ggplot2::element_blank(), axis.title.x=ggplot2::element_blank(), axis.title.y=ggplot2::element_blank(), 
                           panel.grid.major=ggplot2::element_blank(), panel.grid.minor=ggplot2::element_blank(), panel.border=ggplot2::element_blank(), 
                           panel.background=ggplot2::element_blank(), legend.title=ggplot2::element_blank(), plot.title = element_text(hjust = 0.5)))
    } else {
        # Load pre-formatted map for ggplot.
        if (is.null(projection)){
            map <- blscrapeR::county_map_data
        }else{
            if (tolower(projection)=="lambert"){
                map <- blscrapeR::county_map_data
            }
            if (tolower(projection)=="mercator"){
                map <- blscrapeR::county_map_merc
            }else{
                message("Supported projections are Lambert and Mercator. A null projection argument returns Mercator for this function.")
            }
        }
        
        # Unemployment statistics by county: Get and process data.
        # Check to see if user selected specific state(s).
        if (!is.null(stateName)){
            # Get state FIPS from internal dataset.
            state_fips <- blscrapeR::state_fips
            # Check to see if states exists.
            state_check <- sapply(stateName, function(x) any(grepl(x, state_fips$state)))
            if(any(state_check==FALSE)){
                stop(message("Please make sure you state names are spelled correctly using full state names."))
            }
            # User Mercator projection for states unless the user overrides.
            if (is.null(projection)){
                map <- blscrapeR::county_map_merc
            }else{
                if (tolower(projection)=="lambert"){
                    map <- blscrapeR::county_map_data
                }
                if (tolower(projection)=="mercator"){
                    map <- blscrapeR::county_map_merc
                }
            }
            # If state list is valid. Grab State FIPS codes from internal data set and subset map.
            # Add state_id to map frame
            map$state_id <- substr(map$id, 1,2)
            state_rows <- sapply(stateName, function(x) grep(x, state_fips$state))
            state_selection <- state_fips$fips_state[state_rows]
            statelist <- list()
            map <- map[(map$state_id %in% state_selection),]
        }
        # Plot
        suppressWarnings(ggplot2::ggplot() + 
            ggplot2::geom_map(data=map, map=map, ggplot2::aes(x=long, y=lat, map_id=id, group=group)) +
            ggplot2::geom_map(data=map_data, map=map, ggplot2::aes_string(map_id="fips", fill=fill_rate), color="#0e0e0e", size=0.25) +
            ggplot2::scale_fill_gradient(low=lowFill, high=highFill, na.value="grey50") +
            ggplot2::labs(title=labtitle) + 
            ggplot2::theme(axis.line=ggplot2::element_blank(), axis.text.x=ggplot2::element_blank(), axis.text.y=ggplot2::element_blank(), 
                           axis.ticks=ggplot2::element_blank(), axis.title.x=ggplot2::element_blank(), axis.title.y=ggplot2::element_blank(), 
                           panel.grid.major=ggplot2::element_blank(), panel.grid.minor=ggplot2::element_blank(), panel.border=ggplot2::element_blank(), 
                           panel.background=ggplot2::element_blank(), legend.title=ggplot2::element_blank(), plot.title = element_text(hjust = 0.5)))
        
    }
}



