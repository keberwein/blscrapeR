#
#' @title Basic Request Mechanism for BLS Tables
#' @description Return data frame from one or more requests via the US Bureau of Labor Statistics API. Provided arguments are in the form of BLS series ids.
#' @param seriesid The BLS id of the series your trying to load. A common format would be 'LAUCN040010000000005'
#' @param startyear The first year in your data set.
#' @param endyear The last year in your data set.
#' @param registrationKey The API key issued to you from the BLS website.
#' @param catalog Series description information available only for certian data sets.
#' @param calculations Returns year-over-year calculations if set to TRUE.
#' @param annualaverage Retruns an annual average if set to TRUE.
#' @keywords bls api economics cpi unemployment inflation
#' @import httr jsonlite data.table
#' @export get_data
#' @examples
#' 
#' ## Not run:
#' ## API Version 1.0 R Script Sample Code
#' ## Single Series request
#' df <- get_data('LAUCN040010000000005')
#' 
#' ## End (Not run)
#'
#'

# TODO: Put an a warning if user exceeds maximun number of years allowed by the BLS.
get_data <- function (seriesid, startyear = NULL, endyear = NULL, registrationKey = NULL, 
                  catalog = NULL, calculations = NULL, annualaverage = NULL){
    
    payload <- list(seriesid = seriesid)
    # Payload won't take NULL values, have to check every field.
    # Probably a more elegant way do do this using a list and apply function.
    if (exists("registrationKey") & !is.null(registrationKey)){
        if (exists("catalog") & !is.null(catalog)){
            payload["catalog"] <- tolower(as.character(catalog))}
        if (exists("calculations") & !is.null(calculations)){
            payload["calculations"] <- tolower(as.character(calculations))}
        if (exists("annualaverage") & !is.null(annualaverage)){
            payload["annualaverage"] <- tolower(as.character(annualaverage))}
        payload["registrationKey"] <- as.character(registrationKey)
        # Base URL for V2 for folks who have a key.
        base_url <- "http://api.bls.gov/publicAPI/v2/timeseries/data/"}
    else{
        if (exists("startyear") & !is.null(startyear)){
            payload["startyear"] <- as.character(startyear)}
        if (exists("endyear") & !is.null(endyear)){
            payload["endyear"] <- as.character(endyear)}
        # Base URL for no key.
        base_url <- "http://api.bls.gov/publicAPI/v1/timeseries/data/"}
    
    # Here's the actual API call.
    jsondat <- content(POST(base_url, body = toJSON(payload), content_type_json()))
    if(length(jsondat$Results) > 0) {
        # Put results into data.table format.
        # Try to figure out a way to do this without importing data.table with the package.
        # Method borrowed from here:
        # https://github.com/fcocquemas/bulast/blob/master/R/bulast.R
        dt <- data.table::rbindlist(lapply(jsondat$Results$series, function(s) {
            dt <- data.table::rbindlist(lapply(s$data, function(d) {
                d[["footnotes"]] <- paste(unlist(d[["footnotes"]]), collapse = " ")
                d <- lapply(lapply(d, unlist), paste, collapse=" ")
            }), use.names = TRUE, fill=TRUE)
            dt[, seriesID := s[["seriesID"]]]
            dt
        }), use.names = TRUE, fill=TRUE)
        
        # Convert periods to dates.
        # This is for convenience--don't want to touch any of the raw data.
        dt[, date := seq(as.Date(paste(year, ifelse(period == "M13", 12, substr(period, 2, 3)), "01", sep = "-")),
                         length = 2, by = "months")[2]-1,by="year,period"]
        jsondat$Results <- dt
        df <- as.data.frame(jsondat$Results)
        return(df)
    }
    else{
        message("Woops, something went wrong. Your request returned zero rows! Are you over your daily query limit?")
    }   
}
