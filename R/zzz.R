#
#' @title choropleth mapping of BLS data
#' @description Return a ggplot object to render a choropleth map with county outlines.
#' The map files contain 2015 FIPS codes and can be used with any data set containing
#' county and state FIPS codes. They can not be used with the leaflet package but the shape files can be
#' downloaded from the Census website or with the tigris package. See the "Mapping BLS Data" vignette for this package.
#' @keywords bls api economics unemployment map geo geography
#' @import ggplot2
#' @import grDevices
#' @import utils
#' @import tigris
#' @importFrom maptools elide
#' @importFrom broom tidy
#' @importFrom sp spTransform bbox proj4string
#' @import rgdal
#' @export map_bls
#' @param map_data Dataframe to be used as the map's measures. Usually a result of 
#' calls to the \code{get_bls_county()} or \code{get_bls_state()} functions, but other dataframes, 
#' which include FIPS codes may be used as well.
#' @param fips_year The year of the available shape files that provides the closest match to your data. Current options are 2010-2016.
#' The 2016 data is the default and fits the FIPS codes for curent data.
#' @param fill_rate Column name from the dataframe that you want to use as a fill value, in quotes. NOTE: This argument is mandatory!
#' @param stateName Optional argument if you only want to map a single state or a group of selected states. The argument
#' accepts state full state names in quotes.
#' @param labtitle The main title label for your map passed as a string. The default is no title.
#' @param projection Choices of map projection are "lambert" or "mercator". By default, the function selects Mercator for single states
#' and Lambert for nationwide views.
#' @param lowFill The fill color of the lower values being mapped. The default color is green, but can be changed to any color accepted by
#' \code{ggplot2::scale_fill_gradient}.
#' @param highFill The fill color of the higher values being mapped. The default color is green, but can be changed to any color accepted by
#' \code{ggplot2::scale_fill_gradient}.
#' @seealso \url{https://cran.r-project.org/package=tigris}
#' @examples \dontrun{
#' # Download the most current month unemployment statistics on a county level.
#' df <- get_bls_county()
#' 
#' # Map the unemployment rate by county.
#' bls_gg <- map_bls(map_data = df, fill_rate = "unemployed_rate", 
#'                  labtitle = "Unemployment Rate")
#' bls_gg
#' 
#' 
#' # Map the unemployment rate for Florida and Alabama.
#' 
#' df <- get_bls_county(stateName = c("Florida", "Alabama"))
#' 
#' bls_gg <- map_bls(map_data=df, fill_rate = "unemployed_rate", 
#' stateName = c("Florida", "Alabama"))
#' 
#' bls_gg
#' }
#'
#'

map_bls <- function(map_data, fips_year=2016, fill_rate=NULL, labtitle=NULL, stateName=NULL, projection=NULL, lowFill="green", highFill="red"){
    # Set some dummy variables. This keeps CRAN check happy.
    map=long=lat=id=group=county_map_data=CRS='proj4string<-'=NULL
    # Check to make sure all requred variables are there.
    if (is.null(fill_rate)){
        warning("Please specify a fill_rate in double quotes. What colunm in your data frame do you want to map?")
    }
    if (is.null(map_data())){
        warning("Please supply a data frame containing variables to be mapped. For help, see the get_bls_county() or get_bls_state() functions.")
    }

    # Load spatial data frame.
    county <- tigris::counties(cb = TRUE, resolution = "20m", fips_year)
    
    # Format spatial data fram to specified projection.
    # User Mercator projection for states unless the user overrides.

    if (is.null(projection)){
        map <- spTransform(county, CRS("+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0
                                    +x_0=0.0 +y_0=0 +k=1.0 +units=m +no_defs"))
        map@data$id <- rownames(map@data)
    }else{
        if (tolower(projection)=="lambert"){
            map <- spTransform(county, CRS("+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 
                                  +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs"))
            map@data$id <- rownames(map@data)        }
        if (tolower(projection)=="mercator"){
            map <- spTransform(county, CRS("+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0
                                    +x_0=0.0 +y_0=0 +k=1.0 +units=m +no_defs"))
            map@data$id <- rownames(map@data)
        }else{
            message("Supported projections are Lambert and Mercator. A null projection argument returns Mercator for this function.")
        }
    }
    
    # Rotate and shrink ak.
    ak <- map[map$STATEFP=="02",]
    ak <- elide(ak, rotate=-50)
    ak <- elide(ak, scale=max(apply(bbox(ak), 1, diff)) / 2.3)
    ak <- elide(ak, shift=c(-2100000, -2500000))
    proj4string(ak) <- proj4string(map)
    
    # Rotate and Shift hawi
    hawi <- map[map$STATEFP=="15",]
    hawi <- elide(hawi, rotate=-35)
    hawi <- elide(hawi, shift=c(5400000, -1400000))
    proj4string(hawi) <- proj4string(map)
    
    # Also remove Puerto Rico (72), Guam (66), Virgin Islands (78), American Samoa (60) Mariana Islands (69)
    # Micronesia (64), Marshall Islands (68), Palau (70), Minor Islands (74)
    map <- map[!map$STATEFP %in% c("02", "15", "72", "66", "78", "60", "69",
                                            "64", "68", "70", "74"),]
    # Make sure other outling islands are removed.
    map <- map[!map$STATEFP %in% c("81", "84", "86", "87", "89", "71", "76",
                                            "95", "79"),]
    map <- rbind(map, ak, hawi)
    
    # Projuce map
    map <- broom::tidy(map, region="GEOID")
    # Remove helper data and save file. Be sure to remove .Randdom.seed if exists.
    rm(ak, county, hawi)
    
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
    # 
    # Working up to here---Need to figure out scale_fill_gradient in ggplot. Though this is working in the production version.
    # TODO: Center lab title.
    ggplot2::ggplot() + 
        ggplot2::geom_map(data=map, map=map, ggplot2::aes(x=long, y=lat, map_id=id, group=group)) +
        ggplot2::geom_map(data=map_data, map=map, ggplot2::aes_string(map_id="fips", fill=fill_rate), color="#0e0e0e", size=0.25) +
        ggplot2::scale_fill_gradient(low=lowFill, high=highFill, na.value="grey50") +
        ggplot2::labs(title=labtitle) + 
        ggplot2::theme(axis.line=ggplot2::element_blank(), axis.text.x=ggplot2::element_blank(), axis.text.y=ggplot2::element_blank(), axis.ticks=ggplot2::element_blank(),
                       axis.title.x=ggplot2::element_blank(), axis.title.y=ggplot2::element_blank(), panel.grid.major=ggplot2::element_blank(), panel.grid.minor=ggplot2::element_blank(),
                       panel.border=ggplot2::element_blank(), panel.background=ggplot2::element_blank(), legend.title=ggplot2::element_blank())
}