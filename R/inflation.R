#' @title Convert the Value of a US Dollar to a Given month on or after 1947.
#' @description Returns a data frame that uses data from the Consumer Price Index (All Goods) to convert the value of a US Dollar [$1.00 USD] over time.
#' @param base_date = A string argument to represent the base month that you would like dollar values converted to. 
#' For example, if you want to see the value of a Jan. 2015 dollar in Jan. 2023, you would select "2015-01-01" as a base date and find Jan 2023 in the table.
#' @param ... additional arguments
#' @keywords bls api economics cpi unemployment inflation
#' @importFrom stats aggregate lag
#' @importFrom dplyr mutate select rename arrange pull
#' @importFrom tibble as_tibble
#' @export inflation_adjust
#' @return A tibble from the BLS API.
#' @examples
#' \dontrun{
#' ## Get historical USD values based on a dollar from Jan 2015.
#' values <- inflation_adjust(base_year = "2015-01-01")
#' }
#' 
inflation_adjust <- function(base_date=NA, ...){
    # Set some dummy variables. This keeps CRAN check happy.
    series_id=period=index=coredata=footnote_codes=value=Group.1=x=year=NULL
    
    # Check args
    if (!is.na(base_date)) {
        if (!grepl("^\\d{4}-\\d{2}-\\d{2}$", base_date)) {
            stop("base_date must be in yyyy-mm-dd format.")
        }
        if (as.Date(base_date) <= as.Date("1947-01-01")) {
            stop("base_date must be greater than 1947-01-01.")
        }
    } else {
        stop("base_date argument is required.")
    }
    
    #Load file from local data
    cu_main_dat <- blscrapeR::cu_main
    # Get last year from cu_main
    cu_dat_year <- max(cu_main_dat$year)
    
    #Make API call for to API using max year as the startyear, and the current year as the endyear.
    if (Sys.getenv("BLS_KEY") != "") {
        cu_temp <- bls_api("CUUR0000SA0", startyear = cu_dat_year, endyear = as.numeric(format(Sys.Date(), "%Y")),
                           Sys.getenv("BLS_KEY"))
    } else {
        cu_temp <- bls_api("CUUR0000SA0", startyear = cu_dat_year, endyear = as.numeric(format(Sys.Date(), "%Y")))
    }
    
    # Data prep.
    cu_main <- cu_temp %>%
        dplyr::mutate(date=as.Date(paste(year, period,"01",sep="-"),"%Y-M%m-%d"), year=format(date, '%Y')) %>% 
        dplyr::select(date, period, year, value)
    # Bind data sets.
    cu_bound <- dplyr::bind_rows(cu_main, cu_main_dat)
    
    # Annual aggregation.
    base_value <- cu_bound %>%
        filter(date == base_date) %>%
        select(value) %>%
        pull()
    
    # Calculate the adjustment factor
    df_out <- cu_bound %>%
        filter(date >= base_date) %>%
        arrange(date) %>%
        mutate(base_date = base_date) %>%
        # Formula for calculating inflation example: $1.00 * (1980 CPI/ 2014 CPI) = 1980 price.
        #mutate(adj_dollar_value = round(value / base_value, 2)) %>%
        mutate(adj_dollar_value = ceiling(value / base_value * 100) / 100) %>%
        mutate(month_ovr_month_pct_change = (value / lag(value) - 1) * 100)

return(df_out)

}