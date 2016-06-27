#
#' @title Function that returns county-level labor statistics for the last three months.
#' @description Helper function to download and format state employment data.
#' @param state A list of states to run through the loop.
#' @param seasonality TRUE or FALSE. The default value is TRUE.
#' @importFrom utils download.file read.csv read.table
#' @export bls_state_data
#'
# Borrowed this bit from the following link.
# https://rud.is/b/2015/03/12/streamgraph-htmlwidget-version-0-7-released-adds-support-for-markers-annotations/
# TODO need to figure out way to do a FIPS match and add a column.

bls_state_data <- function(state, seasonality = NA){
    seas <- "http://www.bls.gov/lau/ststdsadata.txt"
    notseas <- "http://www.bls.gov/lau/ststdnsadata.txt"
    if (seasonality == TRUE){
        dat <- readLines(seas)
    }
    else if (seasonality == FALSE){
        dat <- readLines(notseas)
    }
    else if (missing(seasonality)){
        dat <- readLines(seas)
    }
    
    section <- paste("^%s|    (", paste0(month.name, sep="", collapse="|"), ")\ +[[:digit:]]{4}", sep="", collapse="")
    section <- sprintf(section, state)
    vals <- gsub("^\ +|\ +$", "", grep(section, dat, value=TRUE))
    
    state_vals <- gsub("^.* \\.+", "", vals[seq(from=2, to=length(vals), by=2)])
    
    cols <- read.table(text=state_vals)
    cols$month <- as.Date(sprintf("01 %s", vals[seq(from=1, to=length(vals), by=2)]),
                          format="%d %B %Y")
    cols$state <- state
    
    cols %>%
        select(8:9, 1:8) %>%
        mutate(V1=as.numeric(gsub(",", "", V1)),
               V2=as.numeric(gsub(",", "", V2)),
               V4=as.numeric(gsub(",", "", V4)),
               V6=as.numeric(gsub(",", "", V6)),
               V3=V3/100,
               V5=V5/100,
               V7=V7/100) %>%
        rename(civ_pop=V1,
               labor_force=V2, labor_force_rate=V3,
               employed=V4, employed_rate=V5,
               unemployed=V6, unemployed_rate=V7)
}

#' @title Gather State Employment Data from the BLS.
#' @description Returns state level data from 1976 to current in a dataframe. Data includes, Civilian Labor Force, 
#' Number of Employed, Number of Unemployed and Unemployment rate.
#' NOTE: These data are from a text file and do not count against your daily API calls.
#' @keywords bls employment, unemployment, labor force, data
#' @importFrom dplyr bind_rows select mutate rename left_join
#' @param seasonality TRUE or FALSE. Would you like seasonally adjusted data? The default value is TRUE.
#' @export get_bls_state
#' @examples
#' 
#' ## Not run:
#' df <- get_bls_state(seasonality = TRUE)
#' 
#' ## End (Not run)
#'
#'

get_bls_state <- function(seasonality = NA){
    if (missing(seasonality)){
        message("The default seasonality is seasonally adjusted.......")
        message("Downloading data, please be patient..................")
        seasonality = TRUE
    }
    else{
        message("Downloading data, please be patient..................")
        df <- bind_rows(lapply(state.name, bls_state_data, seasonality))
        
    }
    state_fips<-state_fips
    df <- left_join(df, state_fips, by="state")
    return(df)
}
