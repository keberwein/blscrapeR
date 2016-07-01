
#' @title Function that returns county-level labor statistics for the last three months.
#' @description Helper function to download and format state employment data.
#' @param date_mth The month or months you would like data for. Accepts full month names and four-digit year.
#' @param seasonality TRUE or FALSE. The default value is TRUE.
#' @importFrom utils download.file read.csv read.table
#' @importFrom dplyr select mutate rename bind_rows left_join
#' @export get_bls_state
#' @examples  \dontrun{
#' # Single series
#' get_bls_state(date_mth = "May 2016", seasonality = TRUE)
#' 
#' # Multiple series
#' get_bls_state(date_mth = c("April 2016", "May 2016"), seasonality = FALSE)
#' }
#'
# TODO need to figure out way to do a FIPS match and add a column.

get_bls_state <- function(date_mth, seasonality = NA){
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
        cols$month <- i
        cols$state <- state.name
        
        cols <- cols %>%
            select(8:9, 1:8) %>%
            mutate(V1=as.numeric(gsub(",", "", V1)), V2=as.numeric(gsub(",", "", V2)),
                   V4=as.numeric(gsub(",", "", V4)), V6=as.numeric(gsub(",", "", V6)),
                   V3=V3/100, V5=V5/100, V7=V7/100) %>%
            rename(civ_pop=V1, labor_force=V2, labor_force_rate=V3,
                   employed=V4, employed_rate=V5, unemployed=V6, unemployed_rate=V7)
        datalist[[i]] <- cols
    }
    df <- bind_rows(datalist)
    # Convert month colunm to ISO 8601 date format.
    df$month <- as.Date(paste('01', df$month), format = '%d %b %Y')
    # Add colunm for state fips codes.
    state_fips<-state_fips
    df <- left_join(df, state_fips, by="state")
    
    return(df)
}