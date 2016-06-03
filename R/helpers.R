#
#' @title Helper funtion for state map.
#' @description Helper function to download and format state employment data.
#' @param state A list of states to run through the loop.
#' @param seasonality TRUE or FALSE. The default value is TRUE.
#' @importFrom utils download.file read.csv read.table
#' @export format_state_data
#'
# Borrowed this bit from the following link.
# https://rud.is/b/2015/03/12/streamgraph-htmlwidget-version-0-7-released-adds-support-for-markers-annotations/
# TODO re-write the function so it doesn't depend on dplyr.
# TODO need to figure out way to do a FIPS match and add a column.


format_state_data <- function(state, seasonality = NA){
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
               labor_force=V2, labor_force_pct=V3,
               employed=V4, employed_pct=V5,
               unemployed=V6, unemployed_pct=V7)
}

#
#' @title Helper funtion for county map
#' @description Helper function to download and format state employment data.
#' @export format_county_data
#'
format_county_data <- function(){
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
                             "civilian_labor_force", "employed", "unemp_level", "unemp_rate")
    unlink(temp)
    #Get rid of empty rows at the bottom.
    countyemp <- na.omit(countyemp)
    #Set period to proper date format.
    countyemp$period <- as.Date(paste("01-", countyemp$period, sep = ""), format = "%d-%b-%y")
    #Subset data frame to selected month.
    recent <- max(countyemp$period)
    countyemp <- countyemp[ which(countyemp$period==recent), ]
    
    #Correct column data fromats
    countyemp$unemp_level <- as.numeric(gsub(",", "", as.character(countyemp$unemp_level)))
    countyemp$employed <- as.numeric(gsub(",", "", as.character(countyemp$employed)))
    countyemp$civilian_labor_force <- as.numeric(gsub(",", "", as.character(countyemp$civilian_labor_force)))
    
    #Get the FIPS code: Have to add leading zeros to any single digit number and combine them.
    countyemp$fips_county <- formatC(countyemp$fips_county, width = 3, format = "d", flag = "0")
    countyemp$fips_state <- formatC(countyemp$fips_state, width = 2, format = "d", flag = "0")
    countyemp$fips=paste(countyemp$fips_state,countyemp$fips_county,sep="")
    return(countyemp)
}