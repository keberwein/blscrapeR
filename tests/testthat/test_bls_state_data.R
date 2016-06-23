context("Test State Data Lookup")
# Make sure base code returns same data frame as the function call.

# Base code
state <- "Florida"
seasonality <- TRUE
seas <- "http://www.bls.gov/lau/ststdsadata.txt"
notseas <- "http://www.bls.gov/lau/ststdnsadata.txt"

dat <- readLines(seas)

    
section <- paste("^%s|    (", paste0(month.name, sep="", collapse="|"), ")\ +[[:digit:]]{4}", sep="", collapse="")
section <- sprintf(section, state)
vals <- gsub("^\ +|\ +$", "", grep(section, dat, value=TRUE))
    
state_vals <- gsub("^.* \\.+", "", vals[seq(from=2, to=length(vals), by=2)])
    
cols <- read.table(text=state_vals)
cols$month <- as.Date(sprintf("01 %s", vals[seq(from=1, to=length(vals), by=2)]),
                          format="%d %B %Y")
cols$state <- state
    
cols %>%
        select(8:9, 1:8) %>%
        mutate(V1=as.numeric(gsub(",", "", V1)),
               V2=as.numeric(gsub(",", "", V2)),
               V4=as.numeric(gsub(",", "", V4)),
               V6=as.numeric(gsub(",", "", V6)),
               V3=V3/100,
               V5=V5/100,
               V7=V7/100) %>%
        rename(civ_pop=V1,
               labor_force=V2, labor_force_rate=V3,
               employed=V4, employed_rate=V5,
               unemployed=V6, unemployed_rate=V7)

# Function
outfunc <- bls_state_data("Florida", seasonality = TRUE)

# Test
expect_identical(dim(cols), dim(outfunc))
