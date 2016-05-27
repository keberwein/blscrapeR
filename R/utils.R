
#' Pipe operator
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL

#
#' @title Utility to store your BLS API key.
#' @description Stores your BLS API key in your .renviron file for security.
#' @export bls_key
#' @param force TRUE or FALSE. The default value is FALSE.
#' @examples
#' 
#' ## Not run:
#' bls_key()
#' 
#' ## End (Not run)
#'
bls_key <- function(force = FALSE) {
    env <- Sys.getenv('BLS_KEY')
    if (!identical(env, "") && !force) return(env)
    
    if (!interactive()) {
        stop("Please set env var BLS_KEY to your BLS API key",
             call. = FALSE)
    }
    
    message("Couldn't find env var BLS_KEY. See ?bls_key for more details.")
    message("Please enter your API key and press enter:")
    bls <- readline(": ")
    
    if (identical(bls, "")) {
        stop("Entry failed", call. = FALSE)
    }
    
    message("Updating BLS_key env var to BLS")
    Sys.setenv(BLS_KEY = bls)
    
    bls
}

#id <- Sys.getenv("BLS_KEY")