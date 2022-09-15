
#' Pipe operator
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
#' @return No return value, a utility function to export magrittr pipes to be used in internal package code.
#' @export
NULL

#' Compound_pipe
#'
#' @name %<>%
#' @rdname compound_pipe
#' @keywords internal
#' @importFrom magrittr %<>%
#' @usage lhs \%<>\% rhs
#' @return No return value, a utility function to export magrittr pipes to be used in internal package code.
#' @export
NULL


#' @title urlExists
#' @description A utility function to run a tryCatch on a URL.
#' @param target url
#' @importFrom utils capture.output
#' @return A logical of \code{TRUE} or \code{FALSE}.
#' @export urlExists
urlExists <- function(target) {  
    tryCatch({  
        con <- url(target)  
        a  <- capture.output(suppressWarnings(readLines(con)))  
        close(con)  
        TRUE;  
    },  
    error = function(err) {  
        occur <- grep("cannot open the connection", capture.output(err));  
        if(length(occur) > 0) {
            close(con)
            FALSE;
        }  
    })  
}  

#' Internal function to cast the first letter of a word to upper-case.
#' @param x A word or string to capatalize
#' @param ... additional arguments.
#' @keywords internal
#' @return A string with the first letter of \code{x} as capital letter.
#' @export
firstupper <- function(x) {
    substr(x, 1, 1) <- toupper(substr(x, 1, 1))
    x
}
