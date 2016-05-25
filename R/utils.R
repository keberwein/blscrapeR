#
#' @title Helper funtion.
#' @description Helper function to download and format state employment data.
#' @param state A list of states to run through the loop.
#' @param seasonality TRUE or FALSE
#' @export format_state_data
#'
# Borrowed this bit from the following link.
# TODO re-write the function so it doesn't depend on pbapply or dplyr.
# https://rud.is/b/2015/03/12/streamgraph-htmlwidget-version-0-7-released-adds-support-for-markers-annotations/


format_state_data <- function(state, seasonality = TRUE){
    seas <- "http://www.bls.gov/lau/ststdsadata.txt"
    notseas <- "http://www.bls.gov/lau/ststdnsadata.txt"
    if (seasonality == TRUE){
        dat <- readLines(seas)
    }
    if (seasonality == FALSE){
        dat <- readLines(notseas)
    }
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
               labor_force=V2, labor_force_pct=V3,
               employed=V4, employed_pct=V5,
               unemployed=V6, unemployed_pct=V7)
}

# state_unemployment <- dplyr::bind_rows(pblapply(state.name, seasonality = TRUE, format_state_data))


