#' @title Cast a date column to data frame returned by the bls_api() function
#' @description A helper function to create a continuous date from Year and Period columns. Dates are formatted in ISO 8601.
#' @param api_df The data frame you wish to cast a date column to. Be sure the data frame contains 'year' and 'period' columns as returned
#' by the \code{bls_api()} function.
#' @export dateCast
#' @examples
#' \dontrun{
#' ## Cast a date column to data frame returned by the bls_api() function.
#' df <- bls_api("LAUCN040010000000005")
#' df <- dateCast(df)
#' }
#' 
dateCast <- function (api_df=NULL){
    period <- api_df$period
    year <- api_df$year
    
    if ("year" %in% colnames(api_df) & "period" %in% colnames(api_df)){
        api_df$date <- as.Date(paste(api_df$year, ifelse(api_df$period == "M13", 12, substr(api_df$period, 2, 3)), "01", sep="-"))
    }else{
        message("Please be sure to have columns named 'year' and 'period' in your dataframe as they are returned from the bls_api() function.")
    }
    return(api_df)
}
