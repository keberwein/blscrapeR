#
#' @title Basic Request Mechanism for BLS Tables
#' @description Return data frame from one or more requests via the US Bureau of Labor Statistics API. Provided arguments are in the form of BLS series ids.
#' @param bls_id a specific BLS series id or a list of series ids to be called.
#' @param api.version An integer of the BLS veriosn number (1 or 2), 1 is the default, version 2 requires registration.
#' @keywords bls api economics cpi unemployment inflation
#' @import RCurl RJSONIO
#' @export get_data
#' @examples
#' 
#' ## Not run:
#' ## API Version 1.0 R Script Sample Code
#' ## Single Series request
#' df <- get_data('LNS14000000')
#' 
#' ## End (Not run)
#' 
#' ## Not run:
#' ## Multiple Series
#' bls_id <- list('seriesid'=c('LNS12300000','LNS14000000'))
#' df <- get_data(bls_id)
#' 
#' ## End (Not run)
#' 
#' ## Not run:
#' ## One or More Series, Specifying Years
#' bls_id <- list(
#'     'seriesid'=c('LNS14000000','LNS12300000'),
#'     'startyear'=2010,
#'     'endyear'=2012)
#' df <- get_data(bls_id)
#' 
#' ## End (Not run)
#' 
#' ## Not run:
#' ## API Version 2.0 R Script Sample Code
#' ## Single Series
#' df <- get_data('LNS14000000', api.version=2)
#' 
#' ## End (Not run)
#' 
#' ## Not run:
#' ## Multiple Series
#' bls_id <- list('seriesid'=c('LNS14000000','LNS12300000'))
#' df <- get_data(bls_id, 2)
#' 
#' ## End (Not run)
#' 
#' ## Not run:
#' ## One or More Series with Optional Parameters
#' bls_id <- list(
#'     'seriesid'=c('LNS14000000','LNS12300000'),
#'     'startyear'=2010,
#'     'endyear'=2012,
#'     'catalog'=FALSE,
#'     'calculations'=TRUE,
#'     'annualaverage'=TRUE,
#'     'registrationKey'='2a8526b8746f4889966f64957c56b8fd')
#' df <- get_data(bls_id, api.version=2)
#'
#' ## End (Not run)
#'
#'
get_data <- function(bls_id=NA, api.version=1){
    h = basicTextGatherer()
    h$reset()
    if(class(bls_id)=='logical'){
        message('Please provide a valid BLS ID.')
    }
    else{
        api.url <- paste0('http://api.bls.gov/publicAPI/v',api.version,'/timeseries/data/')
        if(is.list(bls_id)){
            bls_id <- toJSON(bls_id)
            m <- regexpr('\\"seriesid\\":\\"[a-zA-Z0-9]*\\",', bls_id)
            str <- regmatches(bls_id, m)
            if(length(str)>0){
                replace <- sub(',', '],', sub(':', ':[',str))
                bls_id <- sub(str, replace, bls_id)
            }
            curlPerform(url=api.url,
                        httpheader=c('Content-Type' = "application/json;"),
                        postfields=bls_id,
                        verbose = FALSE, 
                        writefunction = h$update
            )
        }else{
            curlPerform(url=paste0(api.url,bls_id),
                        verbose = FALSE, 
                        writefunction = h$update
            )
        }
        h$value()  
    }
    jsondat <- fromJSON(h$value())
    jsondat <-  jsondat$Results$series[[1]]$data
    jsondat <- lapply(jsondat, function(x) {
        x[sapply(x, is.null)] <- NA
        unlist(x)
    })
    df = as.data.frame(do.call("rbind", jsondat))
    return(df)
}