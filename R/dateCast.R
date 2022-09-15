#' @title Cast a date column to data frame returned by the bls_api() function
#' @description A helper function to create a continuous date from Year and Period columns.
#' @param api_df The data frame you wish to cast a date column to. Be sure the data frame contains 'year' and 'period' columns as returned
#' by the \code{bls_api()} function.
#' @param dt_format A character string containing a valid date format. The default will return the ISO 8601 date format.
#' @export dateCast
#' @return A tibble from the source \code{api_df} with an additional date column based on the date format given in \code{dt_format}.
#' @examples
#' 
#' ## Cast a date column to data frame returned by the bls_api() function.
#' df <- bls_api("LAUCN040010000000005") %>%
#' dateCast()
#' 
#' 
dateCast <- function (api_df=NULL, dt_format=NULL){
    period <- api_df$period
    year <- api_df$year
    
    if ("year" %in% colnames(api_df) & "period" %in% colnames(api_df)){
        api_df$date <- as.Date(paste(api_df$year, ifelse(api_df$period == "M13", 12, substr(api_df$period, 2, 3)), "01", sep="-"))
    }else{
        message("Please be sure to have columns named 'year' and 'period' in your dataframe as they are returned from the bls_api() function.")
    }
    if (!is.null(dt_format)) {
        as.character(dt_format)
        api_df$date <- format(api_df$date, format=dt_format)
    }
    return(api_df)
}
