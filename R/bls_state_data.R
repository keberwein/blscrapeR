#' @title Gather State Employment Data from the BLS.
#' @description Returns data from 1976 to current in a dataframe. Data includes, Civilian Labor Force, Number of Employed, Number of Unemployed and Unemployment rate.
#' @keywords bls employment, unemployment, labor force, data
#' @importFrom dplyr bind_rows
#' @importFrom dplyr select
#' @importFrom dplyr mutate
#' @importFrom dplyr rename
#' @param seasonality TRUE or FALSE. Would you like seasonally adjusted data? The default value is TRUE.
#' @export bls_state_data
#' @examples
#' 
#' ## Not run:
#' df <- bls_state_data(seasonality = TRUE)
#' 
#' ## End (Not run)
#'
#'

bls_state_data <- function(seasonality = NA){
    if (missing(seasonality)){
        print("The default seasonality is seasonally adjusted.......")
        print("Downloading data, please be patient..................")
        seasonality = TRUE
    }
    else{
    df <- bind_rows(lapply(state.name, format_state_data, seasonality))
    print("Downloading data, please be patient..................")
    }
return(df)
}