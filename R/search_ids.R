#' Search the internal series_id data set.
#' @param keyword The keyword you want to search. This can be a fuzzy search of multiple keywords. For example \code{"unemployment women"}.
#' @param periodicity_code The period of time of the surveys you are interested in. This is usually monthly, quarterly or annually.
#' You can type full words or beginning letters. For example, \code{periodicity_code = "m"} or \code{periodicity_code = "monthly"}.
#' @param ... additional arguments
#' @importFrom dplyr filter
#' @importFrom stringr str_detect str_to_title
#' @importFrom purrr map_chr
#' @importFrom tibble as_tibble
#' @export
#' @examples
#' # Search for monthly Unemployment Rates for Women
#' ids <- search_ids(keyword = c("Unemployment Rate", "Women"), periodicity_code = "M")
#' 


search_ids <- function(keyword = NULL, periodicity_code = NULL, ...) {
    # Check for user errors.
    if(is.null(keyword)) message("Please enter a keyword to search for.")
    
    # Get the internal data.
    bls_ids <- blscrapeR::series_ids
    
    # We need to capitalize the first letters of the user input for the search to work properly.
    keyword <- sapply(keyword, stringr::str_to_title)
    
    if(!is.null(periodicity_code)) {
        periodicity_code <- firstupper(periodicity_code)
        periodicity_code <- ifelse(periodicity_code=="Monthly", "M",
                                   ifelse(periodicity_code=="Month", "M", periodicity_code))
        periodicity_code <- ifelse(periodicity_code=="Annually", "A",
                                   ifelse(periodicity_code=="Annual", "A", periodicity_code))
        periodicity_code <- ifelse(periodicity_code=="Quarterly", "Q",
                                   ifelse(periodicity_code=="Quarter", "Q", periodicity_code))
        bls_ids <- dplyr::filter(bls_ids, periodicity_code==periodicity_code)
    }

    # Need to format the keywords into a regex expression.
    regwords <- keyword %>% purrr::map_chr(~ paste0("(?=.*", .,")")) %>% paste(collapse = "")
    
    # Filter on the regex expression.
    search <- dplyr::filter(bls_ids, grepl(regwords, bls_ids$series_title, perl = T)) %>% tibble::as_tibble()
    
    return(search)
}


