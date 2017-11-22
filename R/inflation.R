#' @title Convert the Value of a US Dollar to a Given Year
#' @description Returns a data frame that uses data from the Consumer Price Index (All Goods) to convert the value of a US Dollar [$1.00 USD] over time.
#' @param base_year = A string or integer argument to represent the base year that you would like dollar values converted to. 
#' For example, if you want to see the value of a 2007 dollar in 2015, you would select 2015 as a base year and find 2007 in the table.
#' @param ... additional arguments
#' @keywords bls api economics cpi unemployment inflation
#' @importFrom stats aggregate
#' @importFrom dplyr mutate select rename
#' @importFrom tibble as_tibble
#' @export inflation_adjust
#' @examples
#' 
#' ## Get historical USD values based on a 2010 dollar.
#' values <- inflation_adjust(base_year = 2015)
#' 
#' 
inflation_adjust <- function(base_year=NA, ...){
    # Set some dummy variables. This keeps CRAN check happy.
    series_id=period=index=coredata=footnote_codes=value=Group.1=x=year=NULL
    if (nchar(base_year) != 4){
        stop(message("Please enter your date as a four-digit integer."))
    }
    #Load file from BLS servers
    temp <- tempfile()
    # Add urlEXists here.
    
    download.file("https://download.bls.gov/pub/time.series/cu/cu.data.1.AllItems",temp)
    cu_temp <- read.table(temp, header=FALSE, sep="\t", skip=1, stringsAsFactors=FALSE, strip.white=TRUE)
    colnames(cu_temp) <- c("series_id", "year", "period", "value", "footnote_codes")
    unlink(temp)
    
    # Data prep.
    cu_main <- subset(cu_temp, series_id=="CUSR0000SA0" & period!="M13" & period!="S01" & period!="S02" & period!="S03") %>% tibble::as_tibble() %>%
        dplyr::mutate(date=as.Date(paste(year, period,"01",sep="-"),"%Y-M%m-%d"), year=format(date, '%Y')) %>% 
        dplyr::select(date, period, year, value)
    # Annual aggregation.
    avg.cpi <- aggregate(cu_main$value, by=list(cu_main$year), FUN=mean) %>% dplyr::rename(year=Group.1, avg_cpi=x)
    # Formula for calculating inflation example: $1.00 * (1980 CPI/ 2014 CPI) = 1980 price.
    avg.cpi$adj_value <- avg.cpi[,2] / avg.cpi[as.numeric(which(avg.cpi$year==as.character(base_year))),2]
    avg.cpi$base_year <- as.character(base_year)
    avg.cpi$pct_increase <- (1-avg.cpi$adj_value) * -100
    avg.cpi$adj_value <- round(avg.cpi$adj_value, 2)
    tibble::as_tibble(avg.cpi)
}

