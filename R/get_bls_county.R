#
#' @title A function that returns county-level labor statistics
#' @description A function to download and format state employment data.
#' Due to limitations in the data source, the function can only return data from the last 12 months.
#' NOTE: Unlike many other BLS data sets, these data are never estimated, meaning the most current data may be as much as
#' 60 days behind the current data. The county data are also never seasonally adjusted.
#' @param date_mth The month you would like data for. Accepts full month names and four-digit year.
#' If NULL, it will return the most recent month in the database.
#' @param stateName is an optional argument if you only want data for certain state(s). The argument is NULL by default and
#' will return data for all 50 states.
#' @importFrom stats na.omit
#' @importFrom data.table rbindlist
#' @export get_bls_county
#' @examples  \dontrun{
#' # Most recent month in the data set.
#' get_bls_county()
#' 
#' # A specific month
#' df <- get_bls_county("May 2016")
#' 
#' # Multiple months
#' df <- get_bls_county(c("April 2016","May 2016"))
#' 
#' # A specific state
#' df <- get_bls_county(stateName = "Florida")
#' 
#' # Multiple states, multiple months
#' df<- get_bls_county(date_mth = "April 2015", 
#'              stateName = c("Florida", "Alabama"))
#'}
#'

get_bls_county <- function(date_mth = NULL, stateName = NULL){
    # Set some dummy variables. This keeps CRAN check happy.
    countyemp=contyemp=fips_state=NULL
    state_fips <- blscrapeR::state_fips
    temp<-tempfile()
    download.file("http://www.bls.gov/web/metro/laucntycur14.txt", temp)
    countyemp <- read.csv(temp,
                        fill=TRUE,
                        header=FALSE,
                        sep="|",
                        skip=6,
                        stringsAsFactors=FALSE,
                        strip.white=TRUE)
    colnames(countyemp) <- c("area_code", "fips_state", "fips_county", "area_title", "period",
                             "labor_force", "employed", "unemployed", "unemployed_rate")
    unlink(temp)
    # Get rid of empty rows at the bottom.
    countyemp <- na.omit(countyemp)
    
    # Set period to proper date format.
    period <- contyemp$period
    countyemp$period <- as.Date(paste("01-", countyemp$period, sep = ""), format = "%d-%b-%y")
    
    # Check to see if user selected specific state(s).
    if (!is.null(stateName)){
        # Check to see if states exists.
        state_check <- sapply(stateName, function(x) any(grepl(x, state_fips$state)))
        if(any(state_check==FALSE)){
            stop(message("Please make sure you state names are spelled correctly using full state names."))
        }
        # If state list is valid. Grab State FIPS codes from internal data set and subset countyemp
        state_rows <- sapply(stateName, function(x) grep(x, state_fips$state))
        state_selection <- state_fips$fips_state[state_rows]
        statelist <- list()
        for (s in as.numeric(state_selection)) {
            state_vals <- subset(countyemp, fips_state==s)
            statelist[[s]] <- state_vals
        }
        
        countyemp <- data.table::rbindlist(statelist)
    }
    
    # Check for date or dates.
    if (!is.null(date_mth)){
        date_mth <- as.Date(paste("01", date_mth, sep = ""), format = '%d %b %Y')
    
        if (is.null(date_mth)){
            date_mth <- max(countyemp$period)
            date_mth <- as.Date(paste("01", date_mth, sep = ""), format = '%d %b %Y')
        }
    }

    # Check to see if users date exists in data set.
    dt_exist <- sapply(date_mth, function(x) any(grepl(x, countyemp$period)))
    if(any(dt_exist==FALSE)){
        message("Are you sure your date(s) is published? Please check the BLS release schedule.")
        if(i>Sys.Date()-54){
            stop(message("County-wide statistics are usually published on the third Friday of each month for the previous month."))
        }
        if(i<Sys.Date()-360){
            stop(message("This data set only goes back one year. Make sure your date(s) is correct."))
        }
    }
    
    # Put months to loop in list.
    if (is.null(date_mth)){
        date_mth <- max(countyemp$period)
    }
    datalist <- list()
    for (i in date_mth) {
        mth_vals <- subset(countyemp, period==i)
        datalist[[i]] <- mth_vals
    }
    # Rebind.
    df <- data.table::rbindlist(datalist)
    # Correct column data fromats.
    df$unemployed <- as.numeric(gsub(",", "", as.character(df$unemployed)))
    df$employed <- as.numeric(gsub(",", "", as.character(df$employed)))
    df$labor_force <- as.numeric(gsub(",", "", as.character(df$labor_force)))
    
    # Get the FIPS code: Have to add leading zeros to any single digit number and combine them.
    df$fips_county <- formatC(df$fips_county, width = 3, format = "d", flag = "0")
    df$fips_state <- formatC(df$fips_state, width = 2, format = "d", flag = "0")
    df$fips <- paste(df$fips_state,df$fips_county,sep="")
    
    return(df)
}