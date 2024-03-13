#' @title Return a dataframe of county FIPS codes by state.
#' @description Returns a data frame that uses data from the US Census FIPS code list.
#' @param state = A string containing a standard state short abbreviation, i.e. FL, WA, OH, etc.
#' @param ... additional arguments
#' @importFrom stats aggregate
#' @importFrom dplyr filter
#' @importFrom tibble as_tibble
#' @importFrom stringr str_trim
#' @export county_fips
#' @return A tibble from the BLS API.
#' @examples
#' \dontrun{
#' ## Get historical USD values based on a 2010 dollar.
#' values <- county_fips(state = "FL")
#' }
#' 

county_fips <- function(state, ...) {
    # Define a list of valid state abbreviations
    valid_states <- c("AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA",
                      "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD",
                      "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ",
                      "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC",
                      "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY",
                      "AS", "DC", "FM", "GU", "MH", "MP", "PW", "PR", "VI")
    
    # Convert the input to uppercase and trim white space
    state_in <- toupper(str_trim(state))
    
    # Check if the input is a valid state abbreviation
    if (!(state_in %in% valid_states)) {
        stop("Invalid state abbreviation. Please provide a valid US state or territory.")
    }
    
    fips_in <- blscrapeR::county_fips
    
    fips <- fips_in %>% filter(state == state_in) %>% tibble::as_tibble()
    
    return(fips)
}



