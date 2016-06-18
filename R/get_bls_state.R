#' @title Gather State Employment Data from the BLS.
#' @description Returns state level data from 1976 to current in a dataframe. Data includes, Civilian Labor Force, 
#' Number of Employed, Number of Unemployed and Unemployment rate.
#' NOTE: These data are from a text file and do not count against your daily API calls.
#' @keywords bls employment, unemployment, labor force, data
#' @importFrom dplyr bind_rows select mutate rename left_join
#' @param seasonality TRUE or FALSE. Would you like seasonally adjusted data? The default value is TRUE.
#' @export get_bls_state
#' @examples
#' 
#' ## Not run:
#' df <- get_bls_state(seasonality = TRUE)
#' 
#' ## End (Not run)
#'
#'

get_bls_state <- function(seasonality = NA){
    if (missing(seasonality)){
        message("The default seasonality is seasonally adjusted.......")
        message("Downloading data, please be patient..................")
        seasonality = TRUE
    }
    else{
        df <- bind_rows(lapply(state.name, bls_state_data, seasonality))
        message("Downloading data, please be patient..................")
    }
    state_fips<-state_fips
    df <- left_join(df, state_fips, by="state")
    return(df)
}