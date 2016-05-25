#
#' @title Cloropleth mapping of BLS data.
#' @description Return a ggplot object to render a cloropleth map.
#' @keywords bls api economics unemployment map geo geography
#' @import ggplot2
#' @export bls_map
#' @examples
#' 
#' ## Not run:
#' 
#' bls_gg <- bls_map()
#' bls_gg
#' 
#' ## End (Not run)
#'
#'

bls_map <- function(){
#Maps by County
#Load pre-formatted map for ggplot.
#load("data/cb_2015_us_county.RData")
map = county_map
#Unemployment statistics by county: Get and process data.
temp<-tempfile()
download.file("http://www.bls.gov/lau/laucntycur14.txt", temp)
countyemp<-read.csv(temp,
                    fill=TRUE,
                    header=FALSE,
                    sep="|",
                    skip=6,
                    stringsAsFactors=FALSE,
                    strip.white=TRUE)
colnames(countyemp) <- c("area_code", "fips_state", "fips_county", "area_title", "period",
                         "civilian_labor_force", "employed", "unemp_level", "unemp_rate")
unlink(temp)
#Get rid of empty rows at the bottom.
countyemp <- na.omit(countyemp)
#Set period to proper date format.
countyemp$period <- as.Date(paste("01-", countyemp$period, sep = ""), format = "%d-%b-%y")
#Subset data frame to selected month.
recent <- max(countyemp$period)
countyemp <- countyemp[ which(countyemp$period==recent), ]

#Correct column data fromats
countyemp$unemp_level <- as.numeric(gsub(",", "", as.character(countyemp$unemp_level)))
countyemp$employed <- as.numeric(gsub(",", "", as.character(countyemp$employed)))
countyemp$civilian_labor_force <- as.numeric(gsub(",", "", as.character(countyemp$civilian_labor_force)))

#Get the FIPS code: Have to add leading zeros to any single digit number and combine them.
countyemp$fips_county <- formatC(countyemp$fips_county, width = 3, format = "d", flag = "0")
countyemp$fips_state <- formatC(countyemp$fips_state, width = 2, format = "d", flag = "0")
countyemp$fips=paste(countyemp$fips_state,countyemp$fips_county,sep="")

#Plot
ggplot() +
    geom_map(data=map, map=map,
             aes(x=long, y=lat, map_id=id, group=group),
             fill="#ffffff", color="#0e0e0e", size=0.15) +
    geom_map(data=countyemp, map=map, aes(map_id=fips, fill=unemp_rate),
             color="#0e0e0e", size=0.15) +
    scale_fill_gradientn(colors = terrain.colors(9)) +
    coord_equal() +
    labs(title="Current Unemployment Rate by State") + 
    theme_bw() +
    theme(axis.line=element_blank(),
          axis.text.x=element_blank(),
          axis.text.y=element_blank(),
          axis.ticks=element_blank(),
          axis.title.x=element_blank(),
          axis.title.y=element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.border = element_blank(),
          panel.background = element_blank())
}