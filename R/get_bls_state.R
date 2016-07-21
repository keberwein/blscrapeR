
#' @title Function that returns county-level labor statistics for the last three months.
#' @description Helper function to download and format state employment data.
#' @param date_mth The month or months you would like data for. Accepts full month names and four-digit year.
#' @param seasonality TRUE or FALSE. The default value is TRUE.
#' @import datasets
#' @importFrom utils download.file read.csv read.table
#' @importFrom data.table rbindlist
#' @export get_bls_state
#' @examples  \dontrun{
#' # Single series
#' get_bls_state(date_mth = "May 2016", seasonality = TRUE)
#' 
#' # Multiple series
#' get_bls_state(date_mth = c("April 2016", "May 2016"), seasonality = FALSE)
#' }
#'

get_bls_state <- function(date_mth, seasonality = NA){
    state.name=NULL
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
    # Make an empty list for data frames and iterate in big nasty for loop.
    datalist <- list()
    for (i in date_mth) {
        #datebegin <- unique(grep(paste(i, collapse = "|"),dat)) + 3
        datebegin <- grep(i, dat) +3
        dateend = datebegin+52
        vals <- gsub("^\ +|\ +$", "", dat[datebegin:dateend])
        vals <- unique(grep(paste(state.name, sep="", collapse="|"), 
                            vals, value=TRUE))
        # Grep will confuse "New York" and "NYC," so manually get rid of NYC.
        nycrow <- grep("New York city", vals)
        vals <- vals[-c(nycrow)]
        
        # Split out state names, so read.table doesn't get confused.
        state_vals <- gsub("^.* \\.+", "", vals)
        cols <- read.table(text=state_vals)
        colnames(cols) <- c("civ_pop", "labor_force", "labor_force_rate", "employed",
                            "employed_rate", "unemployed", "unemployed_rate")
        cols$month <- i
        cols$state <- datasets::state.name
        # Put data frames into a list to be rebound later.                             
        datalist[[i]] <- cols
    }
    df <- data.table::rbindlist(datalist)
    
    # Convert month colunm to ISO 8601 date format.
    df$month <- as.Date(paste('01', df$month), format = '%d %b %Y')
    # Yes, I know this is ugly but I didn't want to import dplyr for this one operation.
    cols$civ_pop <- as.numeric(gsub(",", "", cols$civ_pop))
    cols$labor_force <- as.numeric(gsub(",", "", cols$labor_force))
    cols$employed <- as.numeric(gsub(",", "", cols$employed))
    cols$unemployed <- as.numeric(gsub(",", "", cols$unemployed))
    # Add colunm for state fips codes.
    state_fips<-state_fips
    df <- merge(df, state_fips, by = "state")
    df <- df[order(df$month, df$state),]
                                                                                                                        
return(df)
}