#' @title A function that returns county-level labor statistics
#' @description A function to download and format state employment data.
#' Due to limitations in the data source, the function can only return data from the last 12 months.
#' NOTE: Unlike many other BLS data sets, these data are never estimated, meaning the most current data may be as much as
#' 60 days behind the current data. The county data are also never seasonally adjusted.
#' @param date_mth The month you would like data for. Accepts full month names and four-digit year.
#' If NULL, it will return the most recent month in the database.
#' @param stateName is an optional argument if you only want data for certain state(s). The argument is NULL by default and
#' will return data for all 50 states.
#' @param ... additional arguments
#' @importFrom purrr map map_lgl map_int
#' @importFrom stats na.omit
#' @importFrom tibble as_tibble
#' @importFrom dplyr rename mutate
#' @export get_bls_county
#' @return A tibble from the BLS API.
#' @examples
#' \dontrun{
#' # Most recent month in the data set.
#' get_bls_county()
#' 
#' # A specific month
#' df <- get_bls_county("May 2017")
#' 
#' # Multiple months
#' df <- get_bls_county(c("April 2017","May 2017"))
#' 
#' # A specific state
#' df <- get_bls_county(stateName = "Florida")
#' 
#' # Multiple states, multiple months
#' df<- get_bls_county(date_mth = "April 2017", 
#'              stateName = c("Florida", "Alabama"))
#'}
#'

get_bls_county <- function(date_mth = NULL, stateName = NULL, ...){
    # Set some dummy variables. This keeps CRAN check happy.
    countyemp=contyemp=fips_state=V1=V2=V3=V4=V5=V6=V7=V8=V9=period=i=unemployed=employed=labor_force=NULL
    state_fips <- blscrapeR::state_fips
    # See if URL is available
    target <- blscrapeR::urlExists("https://www.bls.gov/web/metro/laucntycur14.txt")
    if(!isTRUE(target)){
        message("Woops, looks like 'https://www.bls.gov/web/metro/laucntycur14.txt' is unavailable right now!")
    } else {
        temp<-tempfile()
        download.file("https://www.bls.gov/web/metro/laucntycur14.txt", temp)
    }
    countyemp <- read.csv(temp, fill=T, header=F, sep="|", skip=6, stringsAsFactors=F, strip.white=T) %>% 
        dplyr::rename(area_code=V1, fips_state=V2, fips_county=V3, area_title=V4, period=V5, labor_force=V6, employed=V7, 
                      unemployed=V8, unemployed_rate=V9) %>%
        # Get rid of empty rows at the bottom and set period to proper date format.
        na.omit() %>% dplyr::mutate(period=as.Date(paste("01-", period, sep = ""), format = "%d-%b-%y"))
    
    # Get the FIPS code: Have to add leading zeros to any single digit number and combine them.
    countyemp$fips_county <- formatC(countyemp$fips_county, width = 3, format = "d", flag = "0")
    countyemp$fips_state <- formatC(countyemp$fips_state, width = 2, format = "d", flag = "0")
    countyemp$fips <- paste(countyemp$fips_state,countyemp$fips_county,sep="")
    
    unlink(temp)
    
    # Check to see if user selected specific state(s).
    if (!is.null(stateName)){
        # Check to see if states exists.
        state_check <- purrr::map_lgl(stateName, function(x) any(grepl(x, state_fips$state)))
        if(any(state_check==FALSE)){
            stop(message("Please make sure you state names are spelled correctly using full state names."))
        }
        # If state list is valid. Grab State FIPS codes from internal data set and subset countyemp
        state_rows <- purrr::map_int(stateName, function(x) grep(x, state_fips$state))
        state_selection <- state_fips$fips_state[state_rows]
        
        statelist <- purrr::map(state_selection, function(s){
            state_vals <- subset(countyemp, fips_state==s)
        })
        
        countyemp <- do.call(rbind, statelist)
    }
    
    # Check for date or dates.
    if (!is.null(date_mth)){
        date_mth <- as.Date(paste("01", date_mth, sep = ""), format = '%d %b %Y')
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
    }
    
    if (is.null(date_mth)){
        date_mth <- max(countyemp$period)
        date_mth <- as.Date(date_mth, format = '%d %b %Y')
    }
    
    # Put months to loop in list.
    datalist <- purrr::map(date_mth, function(i){
        mth_vals <- subset(countyemp, period==i)
    })
    
    # Rebind.
    df <- do.call(rbind, datalist)
    
    # Correct column data types.
    df %<>% dplyr::mutate(unemployed=as.numeric(gsub(",", "", as.character(unemployed))), employed=as.numeric(gsub(",", "", as.character(employed))),
                          labor_force=as.numeric(gsub(",", "", as.character(labor_force)))) %>% tibble::as_tibble()
    
    return(df)
}
