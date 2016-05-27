#
#' @title Cloropleth mapping of BLS data.
#' @description Return a ggplot object to render a cloropleth map with county outlines.
#' @keywords bls api economics unemployment map geo geography
#' @import ggplot2
#' @import grDevices
#' @export bls_map
#' @param map_data Dataframe to be used as the map's measures. Usually a result of function calls format_county_data or format_state_data, but other dataframes, which include FIPS codes may be used as well.
#' @param fill_rate Column name from the dataframe that you want to use as a fill value.
#' @examples
#' 
#' ## Not run:
#' df <- format_county_data()
#' bls_gg <- bls_map(map_data = df, fill_rate = "unemp_rate")
#' bls_gg
#' 
#' ## End (Not run)
#'
#'

bls_map <- function(map_data, fill_rate){
#Maps by County
#Load pre-formatted map for ggplot.
map = county_map
#Unemployment statistics by county: Get and process data.
#Plot
ggplot() +
    geom_map(data=map, map=map,
             aes(x=long, y=lat, map_id=id, group=group),
             fill="#ffffff", color="#0e0e0e", size=0.15) +
    geom_map(data=map_data, map=map, aes_string(map_id="fips", fill=fill_rate),
             color="#0e0e0e", size=0.15) +
    scale_fill_gradientn(colors = terrain.colors(9)) +
    coord_equal() +
    labs(title=fill_rate) + 
    theme_bw() +
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
#' @keywords bls api economics unemployment map geo geography
#' @import ggplot2
#' @import grDevices
#' @export bls_map_state
#' @param map_data Dataframe to be used as the map's measures. Usually a result of function calls format_county_data or format_state_data, but other dataframes, which include FIPS codes may be used as well.
#' @param fill_rate Column name from the dataframe that you want to use as a fill value.
#' @examples
#' 
#' ## Not run:
#' df <- bls_state_data(seasonality = TRUE)
#' 
#' #Subset data frame to most recent month.
#' recent <- max(df$month)
#' df <- df[ which(df$month==recent), ]
#' 
#' bls_gg <- bls_map_state(map_data = df, fill_rate = "unemployed_pct")
#' bls_gg
#' 
#' ## End (Not run)
#'
#'

bls_map_state <- function(map_data, fill_rate){
    #Maps by County
    #Load pre-formatted map for ggplot.
    map = state_map
    #Unemployment statistics by county: Get and process data.
    #Plot
    ggplot() +
        geom_map(data=map, map=map,
                 aes(x=long, y=lat, map_id=id, group=group),
                 fill="#ffffff", color="#0e0e0e", size=0.15) +
        geom_map(data=map_data, map=map, aes_string(map_id="fips_state", fill=fill_rate),
                 color="#0e0e0e", size=0.15) +
        scale_fill_gradientn(colors = topo.colors(20)) +
        coord_equal() +
        labs(title=fill_rate) + 
        theme_bw() +
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