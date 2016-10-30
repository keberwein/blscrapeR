#
#' @title Cloropleth mapping of BLS data
#' @description Return a ggplot object to render a cloropleth map with county outlines.
#' The map files contain 2015 FIPS codes and can be used with any data set containing
#' county and state FIPS codes. They can not be used with the leaflet package but the shape files can be
#' downloaded from the Census website or with the tigris package. See the "Mapping BLS Data" vignette for this package.
#' @keywords bls api economics unemployment map geo geography
#' @import ggplot2
#' @import grDevices
#' @import utils
#' @export bls_map_county
#' @param map_data Dataframe to be used as the map's measures. Usually a result of 
#' calls to the \code{get_bls_county()} or \code{get_bls_state()} functions, but other dataframes, 
#' which include FIPS codes may be used as well.
#' @param fill_rate Column name from the dataframe that you want to use as a fill value, in quotes. NOTE: This argument is mandatory!
#' @param stateName Optional argument if you only want to map a single state or a group of selected staes. The argument
#' accepts state full state names in quotes.
#' @param labtitle The main title label for your map passed as a string. The default is no title.
#' @seealso \url{https://cran.r-project.org/package=tigris}
#' @examples \dontrun{
#' # Download the most current month unemployment statistics on a county level.
#' df <- get_bls_county()
#' 
#' # Map the unemployment rate by county.
#' bls_gg <- bls_map_county(map_data = df, fill_rate = "unemployed_rate", 
#'                  labtitle = "Unemployment Rate")
#' bls_gg
#' 
#' 
#' # Map the unemployment rate for Florida and Alabama.
#' 
#' df <- get_bls_county(stateName = c("Florida", "Alabama"))
#' 
#' bls_gg <- bls_map_county(map_data=df, fill_rate = "unemployed_rate", 
#' stateName = c("Florida", "Alabama"))
#' 
#' bls_gg
#' }
#'
#'

bls_map_county <- function(map_data, fill_rate=NULL, labtitle=NULL, stateName=NULL){
    if (is.null(fill_rate)){
        stop(message("Please specify a fill_rate in double quotes. What colunm in your data frame do you want to map?"))
    }
    # Set some dummy variables. This keeps CRAN check happy.
    map=long=lat=id=group=county_map_data=NULL
    # Load pre-formatted map for ggplot.
    map <- blscrapeR::county_map_data
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
        # If state list is valid. Grab State FIPS codes from internal data set and subset map.
        # Add state_id to map frame
        map$state_id <- substr(map$id, 1,2)
        state_rows <- sapply(stateName, function(x) grep(x, state_fips$state))
        state_selection <- state_fips$fips_state[state_rows]
        statelist <- list()
        map <- map[(map$state_id %in% state_selection),]
    }
    # Plot
    ggplot() +
        geom_map(data=map, map=map,
                 aes(x=long, y=lat, map_id=id, group=group),
                 fill="#ffffff", color="#0e0e0e", size=0.15) +
        geom_map(data=map_data, map=map, aes_string(map_id="fips", fill=fill_rate),
                 color="#0e0e0e", size=0.15) +
        scale_fill_gradientn(colors = c("green", "red")) +
        coord_equal() +
        labs(title=labtitle) + 
        theme(axis.line=element_blank(),
              axis.text.x=element_blank(),
              axis.text.y=element_blank(),
              axis.ticks=element_blank(),
              axis.title.x=element_blank(),
              axis.title.y=element_blank(),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              panel.border = element_blank(),
              panel.background = element_blank(),
              legend.title=element_blank())
    }


#
#' @title Cloropleth mapping of BLS data
#' @description Return a ggplot object to render a cloropleth map with state outlines.
#' The map files contain 2015 FIPS codes and can be used with any data set containing
#' state FIPS codes. They can not be used with the leaflet package but the shape files can be
#' downloaded from the Census website or with the tigris package. See the "Mapping BLS Data" vignette for this package.
#' @keywords bls api economics unemployment map geo geography
#' @import ggplot2
#' @import grDevices
#' @import utils
#' @export bls_map_state
#' @param map_data Dataframe to be used as the map's measures. Usually a result of 
#' calls to the \code{get_bls_state()} function but other dataframes, 
#' which include FIPS codes may be used as well.
#' @param fill_rate Column name from the dataframe that you want to use as a fill value.
#' @param labtitle The main title label for your map passed as a string. The default is no title
#' @seealso \url{https://cran.r-project.org/package=tigris}
#' @examples \dontrun{
#' # Downlaod employment statistics for April 2016.
#' df <- get_bls_state("April 2016", seasonality = TRUE)
#' 
#' # Map the unemployment rate from data set.
#' bls_gg <- bls_map_state(map_data = df, fill_rate = "unemployed_rate", 
#'              labtitle = "Unemployment Rate")
#' bls_gg
#' }
#' 
#'
#'

bls_map_state <- function(map_data, fill_rate=NULL, labtitle=NULL){
    if (is.null(fill_rate)){
        stop(message("Please specify a fill_rate in double quotes. What colunm in your data frame do you want to map?"))
    }
    # Set some dummy variables. This keeps CRAN check happy.
    map=long=lat=id=group=state_map_data=state.name=NULL
    #Maps by County
    #Load pre-formatted map for ggplot.
    map <- blscrapeR::state_map_data
    #Unemployment statistics by county: Get and process data.
    #Plot
    ggplot() +
        geom_map(data=map, map=map,
                 aes(x=long, y=lat, map_id=id, group=group),
                 fill="#ffffff", color="#0e0e0e", size=0.15) +
        geom_map(data=map_data, map=map, aes_string(map_id="fips_state", fill=fill_rate),
                 color="#0e0e0e", size=0.15) +
        scale_fill_gradientn(colors = c("green", "red")) +
        coord_equal() +
        labs(title=labtitle) + 
        theme(axis.line=element_blank(),
              axis.text.x=element_blank(),
              axis.text.y=element_blank(),
              axis.ticks=element_blank(),
              axis.title.x=element_blank(),
              axis.title.y=element_blank(),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              panel.border = element_blank(),
              panel.background = element_blank(),
              legend.title=element_blank())
}


