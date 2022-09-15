#' @title Request data from the Quarterly Census of Employment and Wages.
#' @description Return data from the QCEW API. This is separate from the main BLS API and returns quarterly data
#' sliced by industry, area or size. Industry is identified by NIACS code and area is identified by FIPS code.
#' A key is not required for the QCEW API.
#' @param year These data begin in 2012 and go to the most recent complete quarter. The argument can be entered
#' as an integer or a character. The default is 2012.
#' @param qtr Quarter: This can be any integer between 1 and 4, or "A" for annual. The argument can be entered
#' as an integer or a character. The default is 1, which returns the first quarter.
#' @param slice The slice should be one of the three data slices offered by the API; "industry", "area", or "size."
#' @param sliceCode The slice codes depend on what slice you select. For example, if you select the "area" slice,
#' your \code{sliceCode} should be a FIPS code. If you select "industry," your \code{sliceCode} should be a NIACS code.
#' There are three internal data sets containing acceptable slice codes to help with selections; \code{blscrapeR::niacs}
#' contains industry codes and descriptions, \code{blscrapeR::area_titles} contains FIPS codes and area descriptions,
#' and \code{blscrapeR::size_titles} contains industry size codes. These codes can be used for the \code{sliceCode} argument.
#' @param ... additional arguments
#' @importFrom tibble as_tibble
#' @keywords bls api economics cpi unemployment inflation
#' @export qcew_api
#' @seealso \url{https://data.bls.gov/cew/doc/access/csv_data_slices.htm}
#' @return A tibble from the BLS API.
#' @examples
#' 
#'  \dontrun{
#' # A request for the employment levels and wages for NIACS 5112: Software Publishers.
#' dat <- qcew_api(c(format(Sys.Date(), "%Y")), qtr="1", slice="industry", sliceCode=10)
#' }
#' 
qcew_api <- function(year=c(format(Sys.Date(), "%Y")), qtr="1", slice=NULL, sliceCode=NULL, ...){
    if (is.null("slice") | is.null("sliceCode")){
        message("Please specify a Slice and sliceCode. See function documentation for examples.")
    }
    
    year = as.numeric(year)
    
    # This API only keeps four years of data.
    if (year < as.numeric(format(Sys.Date(), "%Y")) - 4)
        warning("ERROR: The QCEW API only provides data for the last four years. Please ajust your arguments.")
    
    if (!is.character(year)) year <- as.character(year)
    if (!is.character(qtr)) qtr <- as.character(qtr)
    
    qtr <- tolower(qtr)
    
    slice.options <- c("industry", "area", "size")
    if (!is.character(slice)) slice <- as.character(slice)
    if (!is.character(sliceCode)) sliceCode <- as.character(sliceCode)
    if (!isTRUE(any(grepl(slice, slice.options)))){
        message("Please select slice as 'area', 'industry', or 'size'")
    }
    if (!is.numeric(year)){message("Please set a numeric year.")}
    if (slice=="area" & is.numeric(sliceCode) & !isTRUE(sliceCode %in% blscrapeR::area_titles$area_fips)){
        message("Invalid sliceCode, please check you FIPS code.")
    }
    if (slice=="industry" & is.numeric(sliceCode) & !isTRUE(sliceCode %in% blscrapeR::niacs$industry_code)){
        message("Invalid sliceCode, please check you NIACS code.")
    } 
    if (slice=="size" & is.numeric(sliceCode) & !isTRUE(sliceCode %in% blscrapeR::size_titles$size_code)){
        message("Invalid sliceCode, please enter an integer between 0 and 9.")
    }   
    baseURL <- "https://data.bls.gov/cew/data/api/"
    url <- paste0(baseURL, year, "/", qtr, "/", slice, "/", sliceCode, ".csv")

    out <- tryCatch(
        {
            message("Trying BLS servers...")
            temp <- tempfile()
            download.file(url, temp, quiet = TRUE)
            qcewDat <- read.csv(temp, fill=TRUE, header=TRUE, sep=",", stringsAsFactors=FALSE,
                                strip.white=TRUE)
            message("Payload successful.")
        },
        error=function(cond) {
            message(paste("URL does not seem to exist. Please check your parameters and try again.", url))
            return(NULL)
        },
        warning=function(cond) {
            message(paste("URL caused a warning. Please check your parameters and try again:", url))
            return(NULL)
        }
    ) %>% tibble::as_tibble()   
    return(qcewDat)
}
