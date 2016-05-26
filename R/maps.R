#
#' @title Cloropleth mapping of BLS data.
#' @description Return a ggplot object to render a cloropleth map.
#' @keywords bls api economics unemployment map geo geography
#' @import ggplot2
#' @export bls_map
#' @param map_data Dataframe to be used as the map's measures. Usually a result of function calls format_county_data or format_state_data, but other dataframes, which include FIPS codes may be used as well.
#' @examples
#' 
#' ## Not run:
#' df <- format_county_data()
#' bls_gg <- bls_map(df)
#' bls_gg
#' 
#' ## End (Not run)
#'
#'

bls_map <- function(map_data){
#Maps by County
#Load pre-formatted map for ggplot.
map = county_map
#Unemployment statistics by county: Get and process data.
#Plot
ggplot() +
    geom_map(data=map, map=map,
             aes(x=long, y=lat, map_id=id, group=group),
             fill="#ffffff", color="#0e0e0e", size=0.15) +
    geom_map(data=map_data, map=map, aes(map_id=fips, fill=unemp_rate),
             color="#0e0e0e", size=0.15) +
    scale_fill_gradientn(colors = terrain.colors(9)) +
    coord_equal() +
    labs(title="Current Unemployment Rate by State") + 
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
          panel.background = element_blank())
}