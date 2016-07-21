#
#' @title Cloropleth mapping of BLS data.
#' @description Return a ggplot object to render a cloropleth map with county outlines.
#' The map files contain 2015 FIPS codes and can be used with any data set containing
#' county and state FIPS codes. They can not be used with Leaflet but the original 
#' shapefiles can be downloaded at \url{https://www.census.gov/geo/maps-data/data/cbf/cbf_counties.html}
#' for analysis which requires more customized mapping.
#' @keywords bls api economics unemployment map geo geography
#' @import ggplot2
#' @import grDevices
#' @import utils
#' @export bls_map_county
#' @param map_data Dataframe to be used as the map's measures. Usually a result of 
#' function calls format_county_data or format_state_data, but other dataframes, 
#' which include FIPS codes may be used as well.
#' @param fill_rate Column name from the dataframe that you want to use as a fill value.
#' @param labtitle The main title label for your map passed as a string. The default is no title
#' @examples \dontrun{
#' # Download the most current month unemployment statistics on a county level.
#' df <- get_bls_county()
#' 
#' # Map the unemployment rate by county.
#' bls_gg <- bls_map_county(map_data = df, fill_rate = "unemployed_rate", 
#'                  labtitle = "Unemployment Rate")
#' bls_gg
#' }
#'
#'

bls_map_county <- function(map_data, fill_rate, labtitle=NULL){
    # Set some dummy variables. This keeps CRAN check happy.
    map=long=lat=id=group=county_map_data=NULL
    # Load pre-formatted map for ggplot.
    map <- county_map_data
    # Unemployment statistics by county: Get and process data.
    # Plot
    ggplot2::ggplot() +
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
#' @title Cloropleth mapping of BLS data.
#' @description Return a ggplot object to render a cloropleth map with state outlines.
#' #' The map files contain 2015 FIPS codes and can be used with any data set containing
#' county and state FIPS codes. They can not be used with Leaflet but the original 
#' shapefiles can be downloaded at \url{https://www.census.gov/geo/maps-data/data/cbf/cbf_state.html}
#' for analysis which requires more customized mapping.
#' @keywords bls api economics unemployment map geo geography
#' @import ggplot2
#' @import grDevices
#' @import utils
#' @export bls_map_state
#' @param map_data Dataframe to be used as the map's measures. Usually a result of 
#' function calls format_county_data or format_state_data, but other dataframes, 
#' which include FIPS codes may be used as well.
#' @param fill_rate Column name from the dataframe that you want to use as a fill value.
#' @param labtitle The main title label for your map passed as a string. The default is no title
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

bls_map_state <- function(map_data, fill_rate, labtitle=NULL){
    # Set some dummy variables. This keeps CRAN check happy.
    map=long=lat=id=group=state_map_data=state.name=NULL
    #Maps by County
    #Load pre-formatted map for ggplot.
    map <- state_map_data
    #Unemployment statistics by county: Get and process data.
    #Plot
    ggplot2::ggplot() +
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