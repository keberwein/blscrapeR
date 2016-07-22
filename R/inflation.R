#' @title Convert the Value of a US Dollar to a Given Year
#' @description Returns a data frame that uses data from the Consumer Price Index (All Goods) to convert the value of a US Dollar [$1.00 USD] over time.
#' @param base_year = A string or integer argument to represent the base year that you would like dollar values converted to. 
#' For example, if you want to see the value of a 2007 dollar in 2015, you would select 2015 as a base year and find 2007 in the table.
#' @keywords bls api economics cpi unemployment inflation
#' @importFrom xts xts apply.yearly
#' @importFrom zoo index coredata
#' @export inflation_adjust
#' @examples
#' \dontrun{
#' ## Get historical USD values based on a 2010 dollar.
#' values <- inflation_adjust(base_year = 2010)
#' }
#' 
inflation_adjust <- function(base_year=NA){
    # Set some dummy variables. This keeps CRAN check happy.
    series_id=period=index=coredata=footnote_codes=NULL
    if (nchar(base_year) != 4){
        stop(message("Please enter your date as a four-digit integer."))
    }
        #Load file from BLS servers
        temp<-tempfile()
        download.file("http://download.bls.gov/pub/time.series/cu/cu.data.1.AllItems",temp)
        cu_main<-read.table(temp,
                            header=FALSE,
                            sep="\t",
                            skip=1,
                            stringsAsFactors=FALSE,
                            strip.white=TRUE)
        colnames(cu_main)<-c("series_id", "year", "period", "value", "footnote_codes")
        unlink(temp)
        # Data prep.
        cu_main <- subset(cu_main, series_id=="CUSR0000SA0" &
                              period!="M13" &
                              period!="S01" &
                              period!="S02" &
                              period!="S03") 
        cu_main$date <-as.Date(paste(cu_main$year, cu_main$period,"01",sep="-"),"%Y-M%m-%d")
        cu_main <- cu_main[c('date','value')]
        cpi_main <- xts::xts(cu_main[,-1], order.by=cu_main[,1])
        
        # Get average yearly CPI.
        avg.cpi <- xts::apply.yearly(cpi_main, mean)
        avg.cpi <- round(avg.cpi, 1)
        # Formula for calculating inflation example: $1.00 * (1980 CPI/ 2014 CPI) = 1980 price
        cf <- avg.cpi/as.numeric(avg.cpi[as.character(base_year)])
        colnames(cf) <- "adj_value"
        #cf <- round(cf, 2)
        dat <- merge(avg.cpi, cf)
        
        # Xts object to data frame
        dat <- data.frame(date=zoo::index(dat), zoo::coredata(dat))
        dat$base.year <- as.character(base_year)
        dat$pct_increase <- (1-dat$adj_value) * -100
        # Round dollar amounts
        dat$adj_value <- round(dat$adj_value, 2)
        # Reorder cols in a more usable fassion
        dat <- dat[c("date", "base.year", "adj_value", "pct_increase")]
        colnames(dat)<-c("date", "base_year", "adj_value", "pct_increase")
        return(dat)
}