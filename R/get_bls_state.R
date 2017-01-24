
#' @title A function that returns county-level labor statistics
#' @description A function to download and format state employment data. These data begin on January 1976 to current. 
#' NOTE: The most current data will always be at least 30 days behind the current date, and depending on the day of your query, those numbers may be estimates.
#' @param date_mth The month or months you would like data for. Accepts full month names and four-digit year.
#' @param seasonality TRUE or FALSE. The default value is TRUE.
#' @import datasets
#' @importFrom utils download.file read.csv read.table
#' @importFrom data.table rbindlist
#' @importFrom zoo as.yearmon
#' @export get_bls_state
#' @examples
#' \dontrun{
#' # Single series
#' get_bls_state(date_mth = "May 2016", seasonality = TRUE)
#' 
#' # Multiple series
#' get_bls_state(date_mth = c("April 2016", "May 2016"), seasonality = FALSE)
#' }
#'

get_bls_state <- function(date_mth=NULL, seasonality = TRUE){
    state.name=NULL
    seas <- "https://www.bls.gov/web/laus/ststdsadata.txt"
    notseas <- "https://www.bls.gov/web/laus/ststdnsadata.txt"
    if (seasonality == TRUE){
        dat <- readLines(seas)
    }
    if (seasonality == FALSE){
        dat <- readLines(notseas)
    }
    
    # If no date_mth is specified, find the latest month and return.
    # Not happy with this method. Would rather find max(month) in data. But data format is a bit crazy.
    if (is.null(date_mth)){
        if (isTRUE(any(grepl(format(zoo::as.yearmon(Sys.Date()-30), "%B %Y"), dat)))){
            date_mth <- format(zoo::as.yearmon(Sys.Date()-30), "%B %Y")
        }else{
            if (isTRUE(any(grepl(format(zoo::as.yearmon(Sys.Date()-60), "%B %Y"), dat)))){
                date_mth <- format(zoo::as.yearmon(Sys.Date()-60), "%B %Y")
            }else{date_mth <- format(zoo::as.yearmon(Sys.Date()-90), "%B %Y")}
        }
    }
    
    # Make an empty list for data frames and iterate in big nasty for loop.
    datalist <- list()
    for (i in date_mth) {
        if(i=="January 1976"){
            datebegin=4
        }else{
            datebegin <- grep(i, dat) +3
        }
        dateend = datebegin+52
        vals <- gsub("^\ +|\ +$", "", dat[datebegin:dateend])
        vals <- unique(grep(paste(state.name, sep="", collapse="|"), 
                            vals, value=TRUE))
        # Get rid of MSAs in the data (DC, LA and NYC).
        # There's a more elegant way to do this but don't have time at the moment.
        nycrow <- grep(c("New York city"), vals)
        larow <- grep(c("Los Angeles County"), vals)
        dcrow <- grep(c("District of Columbia"), vals)
        if(length(nycrow)>0){
            vals <- vals[-c(nycrow)]
        }
        if(length(larow)>0){
            vals <- vals[-c(larow)]
        }
        if(length(dcrow)>0){
            vals <- vals[-c(dcrow)]
        }
        
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
    state_fips<-blscrapeR::state_fips
    df <- merge(df, state_fips, by = "state")
    df <- df[order(df$month, df$state),]
    
    return(df)
}