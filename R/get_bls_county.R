#
#' @title Function that returns county-level labor statistics for the last three months.
#' @description Helper function to download and format state employment data. Note: This returns only non-seasonally adjusted data.
#' @importFrom stats na.omit
#' @export get_bls_county
#'
get_bls_county <- function(){
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
    #Get rid of empty rows at the bottom.
    countyemp <- na.omit(countyemp)
    #Set period to proper date format.
    countyemp$period <- as.Date(paste("01-", countyemp$period, sep = ""), format = "%d-%b-%y")
    #Subset data frame to selected month.
    recent <- max(countyemp$period)
    countyemp <- countyemp[ which(countyemp$period==recent), ]
    
    #Correct column data fromats
    countyemp$unemployed <- as.numeric(gsub(",", "", as.character(countyemp$unemployed)))
    countyemp$employed <- as.numeric(gsub(",", "", as.character(countyemp$employed)))
    countyemp$labor_force <- as.numeric(gsub(",", "", as.character(countyemp$labor_force)))
    
    #Get the FIPS code: Have to add leading zeros to any single digit number and combine them.
    countyemp$fips_county <- formatC(countyemp$fips_county, width = 3, format = "d", flag = "0")
    countyemp$fips_state <- formatC(countyemp$fips_state, width = 2, format = "d", flag = "0")
    countyemp$fips=paste(countyemp$fips_state,countyemp$fips_county,sep="")
    return(countyemp)
}