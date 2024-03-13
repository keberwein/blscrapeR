#library(utils)
#library(usethis)


# Get CU data from the following link. May require a manual download since the BLS has browser agent protection.
# https://download.bls.gov/pub/time.series/cu/cu.data.1.AllItems

# Trim white space
cu_temp <- cu.data %>%
    mutate(series_id = trimws(series_id, "right"))
# Subset only all items
cu_parse <- subset(cu_temp, series_id=="CUSR0000SA0" & period!="M13" & period!="S01" & period!="S02" & period!="S03") 
# Clean data formats.
cu_main <- cu_parse %>% tibble::as_tibble() %>%
    dplyr::mutate(date=as.Date(paste(year, period,"01",sep="-"),"%Y-M%m-%d"), year=format(date, '%Y')) %>% 
    dplyr::select(date, period, year, value)

#Filter for the end of the last year, so all years are complete.
#cu_main <- cu_main %>% dplyr::filter(date < lubridate::as_date("2024-01-01"))

write.csv(cu_main, file = "cu_main.csv", row.names = FALSE)

# Use devtools to save data set.
usethis::use_data(cu_main, overwrite = TRUE)
rm(cu_main)