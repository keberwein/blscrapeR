#' @title Basic Request Mechanism for BLS Tables
#' @description Return data frame from one or more requests via the US Bureau of Labor Statistics API. Provided arguments are in the form of BLS series ids.
#' @param seriesid The BLS id of the series your trying to load. A common format would be 'LAUCN040010000000005'. 
#' WARNING: All seriesIDs must contain the same time resolution. For example, monthly data sets can not be combined with annual or semi-annual data.
#' If you need help finding seriesIDs, check the BLS website or the BLS Data Finder--links below. 
#' @param startyear The first year in your data set.
#' @param endyear The last year in your data set.
#' @param registrationKey The API key issued to you from the BLS website.
#' @param catalog Series description information available only for certain data sets.
#' @param calculations Returns year-over-year calculations if set to TRUE.
#' @param annualaverage Returns an annual average if set to TRUE.
#' @param ... additional arguments
#' @keywords bls api economics cpi unemployment inflation
#' @importFrom jsonlite toJSON
#' @importFrom httr content POST content_type_json
#' @importFrom purrr map
#' @importFrom tibble as_tibble
#' @export bls_api
#' @seealso \url{https://www.bls.gov/data/}
#' @seealso \url{https://beta.bls.gov/dataQuery/search}
#' @examples
#' 
#' 
#' ## API Version 1.0 R Script Sample Code
#' ## Single Series request
#' df <- bls_api("LAUCN040010000000005")
#' 
#' \dontrun{
#' ## API Version 1.0 R Script Sample Code
#' ## Multiple Series request with date params.
#' df <- bls_api(c("LAUCN040010000000005", "LAUCN040010000000006"), 
#' startyear = "2010", endyear = "2012")
#' 
#' 
#' ## API Version 1.0 R Script Sample Code
#' ## Multiple Series request with date params.
#' df <- bls_api(c("LAUCN040010000000005", "LAUCN040010000000006"), 
#' startyear = "2010", endyear = "2012")
#' 
#' 
#' ## API Version 2.0 R Script Sample Code
#' ## Multiple Series request with full params allowed by v2.
#' df <- bls_api(c("LAUCN040010000000005", "LAUCN040010000000006"),
#' startyear = "2010", endyear = "2012",
#' registrationKey = "BLS_KEY", 
#' calculations = TRUE, annualaverage = TRUE, catalog = TRUE)
#' }
#' 
# #TODO: Put an a warning if user exceeds maximun number of years allowed by the BLS.
bls_api <- function (seriesid, startyear = NULL, endyear = NULL, registrationKey = NULL, 
                     catalog = FALSE, calculations = FALSE, annualaverage = FALSE, ...){
    # Set some dummy variables. This keeps CRAN check happy.
    year=period=':='=seriesID=NULL
    # Begin constructing payload.
    payload <- list(seriesid = seriesid)
    # Check for start and end years
    if (!is.null(startyear) & is.null(endyear)){
        endyear <- format(Sys.Date(), "%Y")
        message("The API requires both a start and end year." 
                ,"\nThe endyear argument has automatically been set to ", format(Sys.Date(), "%Y"),".")
    }
    # Payload won't take NULL values, have to check every field.
    # Probably a more elegant way do do this.
    if (exists("registrationKey") & !is.null(registrationKey)){
        if (registrationKey=="BLS_KEY"){
            payload["registrationKey"] <- as.character(Sys.getenv("BLS_KEY"))
        }
        else{
            payload["registrationKey"] <- as.character(registrationKey)
        }
        # Base URL for V2 for folks who have a key.
        base_url <- "https://api.bls.gov/publicAPI/v2/timeseries/data/"
        if (exists("catalog") & !is.null(catalog)){
            if (!is.logical(catalog)){
                message("Please select TRUE or FALSE for catalog argument.")
            }
            payload["catalog"] <- tolower(as.character(catalog))
        }
        if (exists("calculations") & !is.null(calculations)){
            if (!is.logical(calculations)){
                message("Please select TRUE or FALSE for calculations argument.")
            }
            payload["calculations"] <- tolower(as.character(calculations))
        }
        if (exists("annualaverage") & !is.null(annualaverage)){
            if (!is.logical(annualaverage)){
                message("Please select TRUE or FALSE for calculations argument.")
            }
            payload["annualaverage"] <- tolower(as.character(annualaverage))
        }
    } else {
        # Base URL for everyone else.
        base_url <- "https://api.bls.gov/publicAPI/v1/timeseries/data/"
    }
    # Both sets of users can select these args.
    if (exists("startyear") & !is.null(startyear)){
        payload["startyear"] <- as.character(startyear)
    }
    if (exists("endyear") & !is.null(endyear)){
        payload["endyear"] <- as.character(endyear)
    }
    # Manually construct payload since the BLS formatting is wakey.
    payload <- jsonlite::toJSON(payload)
    loadparse <- regmatches(payload, regexpr("],", payload), invert = TRUE)
    parse1 <- loadparse[[1]][1]
    parse2 <- gsub("\\[|\\]", "", loadparse[[1]][2])
    payload <- paste(parse1, parse2, sep = "],")
    
    # Here's the actual API call.
    jsondat <- httr::content(httr::POST(base_url, body = payload, httr::content_type_json()))
    
    if(jsondat$status == "REQUEST_SUCCEEDED") {
        df <- purrr::map_dfr(jsondat$Results$series, function(s) {
            out <- purrr::map_dfr(s$data, function(d) {
                d[["footnotes"]] <- paste(unlist(d[["footnotes"]]), collapse = " ")
                d[["seriesID"]] <- paste(unlist(s[["seriesID"]]), collapse = " ")
                d <- purrr::map(purrr::map(d, unlist), paste, collapse=" ")
            })
        })
        
        df$value <- as.numeric(as.character(df$value))
        
        if ("year" %in% colnames(df)){
            df$year <- as.numeric(as.character(df$year))
        }
        
        message(jsondat$status)
    } else {
        # If request fails, return an empty data frame plus the json status and message.
        df <- data.frame()
        message(jsondat$status)
        message(jsondat$message)
    }
    return(df)
}