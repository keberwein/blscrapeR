#
#' @title Function that returns county-level labor statistics for a selected month within the last year.
#' @description Helper function to download and format state employment data. Note: This returns only non-seasonally adjusted data.
#' @param date_mth The month you would like data for. Accepts full month names and four-digit year.
#' If NULL, it will return the most recent month in the database.
#' @importFrom stats na.omit
#' @export get_bls_county
#' @examples  \dontrun{
#' # Most recent month in the data set.
#' get_bls_county()
#' 
#' # A specific month
#' get_bls_county("June 2016")
#' }
#'

get_bls_county <- function(date_mth = NULL){
    temp<-tempfile()
    download.file("http://www.bls.gov/lau/laucntycur14.txt", temp)
    countyemp<-read.csv(temp,
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
    countyemp$period <- as.Date(paste("01-", countyemp$period, sep = ""), format = "%d-%b-%y")
    
    # Figure out what date is wanted.
    if(!is.null(date_mth)){
        date_mth <- as.Date(paste('01', date_mth), format = '%d %b %Y')
    }
      else{
        date_mth <- max(countyemp$period)
    }
    
    # Check to see if users date exists
    dt_exist <- any(grepl(date_mth, countyemp$period))
    if(dt_exist==FALSE){
        message("Are you sure that month is published? Please check the BLS release schedule.")
        if(date_mth>Sys.Date()-54){
            stop(
            message("County-wide statistics are usually published on the third Friday of each month for the previous month."))
        }
        if(date_mth<Sys.Date()-360){
            stop(
                message("This data set only goes back one year. Make sure your date is correct.")
            )
        }
    }
    
   if(!is.null(date_mth)){
    # Subset data frame to selected month.
    countyemp <- subset(countyemp, period==date_mth)
   }
     else{
        current <- max(countyemp$period)
        countyemp <- countyemp[ which(countyemp$period==current), ]
        
    }
    
    # Correct column data fromats
    countyemp$unemployed <- as.numeric(gsub(",", "", as.character(countyemp$unemployed)))
    countyemp$employed <- as.numeric(gsub(",", "", as.character(countyemp$employed)))
    countyemp$labor_force <- as.numeric(gsub(",", "", as.character(countyemp$labor_force)))
    
    # Get the FIPS code: Have to add leading zeros to any single digit number and combine them.
    countyemp$fips_county <- formatC(countyemp$fips_county, width = 3, format = "d", flag = "0")
    countyemp$fips_state <- formatC(countyemp$fips_state, width = 2, format = "d", flag = "0")
    countyemp$fips=paste(countyemp$fips_state,countyemp$fips_county,sep="")
    return(countyemp)
}
