library(blscrapeR)
library(zoo)
library(data.table)
library(testthat)

### TEST DATA SOURCE FOR get_bls_county()
stateName = NULL
date_mth = NULL
countyemp=contyemp=fips_state=NULL
state_fips <- blscrapeR::state_fips
temp<-tempfile()
download.file("https://www.bls.gov/web/metro/laucntycur14.txt", temp)
countyemp <- read.csv(temp,
                      fill=TRUE,
                      header=FALSE,
                      sep="|",
                      skip=6,
                      stringsAsFactors=FALSE,
                      strip.white=TRUE)
colnames(countyemp) <- c("area_code", "fips_state", "fips_county", "area_title", "period",
                         "labor_force", "employed", "unemployed", "unemployed_rate")
unlink(temp)
# Get rid of empty rows at the bottom.
countyemp <- na.omit(countyemp)

# Set period to proper date format.
period <- contyemp$period
countyemp$period <- as.Date(paste("01-", countyemp$period, sep = ""), format = "%d-%b-%y")

# Check to see if user selected specific state(s).
if (!is.null(stateName)){
    # Check to see if states exists.
    state_check <- sapply(stateName, function(x) any(grepl(x, state_fips$state)))
    if(any(state_check==FALSE)){
        stop(message("Please make sure you state names are spelled correctly using full state names."))
    }
    # If state list is valid. Grab State FIPS codes from internal data set and subset countyemp
    state_rows <- sapply(stateName, function(x) grep(x, state_fips$state))
    state_selection <- state_fips$fips_state[state_rows]
    statelist <- list()
    for (s in as.numeric(state_selection)) {
        state_vals <- subset(countyemp, fips_state==s)
        statelist[[s]] <- state_vals
    }
    
    countyemp <- data.table::rbindlist(statelist)
}

# Check for date or dates.
if (!is.null(date_mth)){
    date_mth <- as.Date(paste("01", date_mth, sep = ""), format = '%d %b %Y')
    
    if (is.null(date_mth)){
        date_mth <- max(countyemp$period)
        date_mth <- as.Date(paste("01", date_mth, sep = ""), format = '%d %b %Y')
    }
}

# Check to see if users date exists in data set.
dt_exist <- sapply(date_mth, function(x) any(grepl(x, countyemp$period)))
if(any(dt_exist==FALSE)){
    message("Are you sure your date(s) is published? Please check the BLS release schedule.")
    if(i>Sys.Date()-54){
        stop(message("County-wide statistics are usually published on the third Friday of each month for the previous month."))
    }
    if(i<Sys.Date()-360){
        stop(message("This data set only goes back one year. Make sure your date(s) is correct."))
    }
}

# Put months to loop in list.
if (is.null(date_mth)){
    date_mth <- max(countyemp$period)
}
datalist <- list()
for (i in date_mth) {
    mth_vals <- subset(countyemp, period==i)
    datalist[[i]] <- mth_vals
}
# Rebind.
df <- data.table::rbindlist(datalist)
# Correct column data fromats.
df$unemployed <- as.numeric(gsub(",", "", as.character(df$unemployed)))
df$employed <- as.numeric(gsub(",", "", as.character(df$employed)))
df$labor_force <- as.numeric(gsub(",", "", as.character(df$labor_force)))

# Get the FIPS code: Have to add leading zeros to any single digit number and combine them.
df$fips_county <- formatC(df$fips_county, width = 3, format = "d", flag = "0")
df$fips_state <- formatC(df$fips_state, width = 2, format = "d", flag = "0")
df$fips <- paste(df$fips_state,df$fips_county,sep="")

# Check actual fucntion
out <- get_bls_county()
testthat::expect_identical(nrow(out), nrow(df))



### TEST DATA SOURCE FOR get_bls_state()


date_mth=NULL
seasonality = TRUE
state.name=NULL
seas <- "https://www.bls.gov/web/laus/ststdsadata.txt"
dat <- readLines(seas)

# If no date_mth is specified, find the latest month and return.
# Not happy with this method. Would rather find max(month) in data. But data format is a bit crazy.
if (isTRUE(any(grepl(format(zoo::as.yearmon(Sys.Date()-30), "%B %Y"), dat)))){
    date_mth <- format(zoo::as.yearmon(Sys.Date()-30), "%B %Y")
}else{
    if (isTRUE(any(grepl(format(zoo::as.yearmon(Sys.Date()-60), "%B %Y"), dat)))){
        date_mth <- format(zoo::as.yearmon(Sys.Date()-60), "%B %Y")
    }else{date_mth <- format(zoo::as.yearmon(Sys.Date()-90), "%B %Y")}
}

# Make an empty list for data frames and iterate in big nasty for loop.
datalist <- list()
for (i in date_mth) {
    #datebegin <- unique(grep(paste(i, collapse = "|"),dat)) + 3
    datebegin <- grep(i, dat) +3
    dateend = datebegin+52
    vals <- gsub("^\ +|\ +$", "", dat[datebegin:dateend])
    vals <- unique(grep(paste(state.name, sep="", collapse="|"), 
                        vals, value=TRUE))
    # Get rid of MSAs in the data (DC, LA and NYC).
    # There's a more elegant way to do this but don't have time at the moment.
    nycrow <- grep(c("New York city"), vals)
    larow <- grep(c("Los Angeles County"), vals)
    dcrow <- grep(c("District of Columbia"), vals)
    vals <- vals[-c(nycrow)]
    vals <- vals[-c(larow)]
    vals <- vals[-c(dcrow)]
    
    # Split out state names, so read.table doesn't get confused.
    state_vals <- gsub("^.* \\.+", "", vals)
    cols <- read.table(text=state_vals)
    colnames(cols) <- c("civ_pop", "labor_force", "labor_force_rate", "employed",
                        "employed_rate", "unemployed", "unemployed_rate")
    cols$month <- i
    cols$state <- datasets::state.name
    # Put data frames into a list to be rebound later.                             
    datalist[[i]] <- cols
}
df <- data.table::rbindlist(datalist)

# Convert month colunm to ISO 8601 date format.
df$month <- as.Date(paste('01', df$month), format = '%d %b %Y')
# Yes, I know this is ugly but I didn't want to import dplyr for this one operation.
cols$civ_pop <- as.numeric(gsub(",", "", cols$civ_pop))
cols$labor_force <- as.numeric(gsub(",", "", cols$labor_force))
cols$employed <- as.numeric(gsub(",", "", cols$employed))
cols$unemployed <- as.numeric(gsub(",", "", cols$unemployed))
# Add colunm for state fips codes.
state_fips<-state_fips
df <- merge(df, state_fips, by = "state")
df <- df[order(df$month, df$state),]

# Check actual fucntion
out <- get_bls_state()
testthat::expect_identical(nrow(out), nrow(df))
    