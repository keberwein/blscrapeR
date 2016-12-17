#
#' @title Install a BLS API Key in Your \code{.Renviron} File for Repeated Use
#' @description This function will add your BLS API key to your \code{.Renviron} file so it can be called securely without being stored 
#' in your code. After you have installed your key, it can be called any time by typing \code{Sys.getenv("BLS_KEY")} and can be 
#' used in package functions by simply typing BLS_KEY. If you do not have an \code{.Renviron} file, the function will create on for you. 
#' If you already have an \code{.Renviron} file, the function will append the key to your existing file, while making a backup of your 
#' original file for disaster recovery purposes.
#' @param key The API key provided to you from the BLS formated in quotes. A key can be aquired at \url{https://data.bls.gov/registrationEngine/}
#' @param overwrite If this is set to TRUE, it will overwrite an existing BLS_KEY that you already have in your \code{.Renviron} file.
#' @importFrom utils write.table
#' @export set_bls_key
#' @examples
#' 
#' \dontrun{
#' set_bls_key("111111abc")
#' # First time, relead your enviornment so you can use the key without restarting R.
#' readRenviron("~/.Renviron")
#' # You can check it with:
#' Sys.getenv("BLS_KEY")
#' }
#' 
#' \dontrun{
#' # If you need to overwrite an existing key:
#' set_bls_key("111111abc", overwrite = TRUE)
#' # First time, relead your enviornment so you can use the key without restarting R.
#' readRenviron("~/.Renviron")
#' # You can check it with:
#' Sys.getenv("BLS_KEY")
#' }

set_bls_key <- function(key=NA, overwrite=NA){
    # go to the home dir. and look for an .Renviron file. If not, create one.
    setwd(Sys.getenv("HOME"))
    if(file.exists(".Renviron")){
        # Backup original .Renviron before doing anything else here.
        file.copy(".Renviron", ".Renviron_backup")
    }
    if(!file.exists(".Renviron")){
        file.create(".Renviron")
    }
    else{
        if(isTRUE(overwrite)){
            message("Your original .Renviron will be backed up and stored in your R HOME directory if needed.")
            oldenv=read.table(".Renviron", stringsAsFactors = FALSE)
            newenv <- oldenv[-grep("BLS_KEY", oldenv),]
            write.table(newenv, ".Renviron", quote = FALSE, sep = "\n",
                        col.names = FALSE, row.names = FALSE)
        }
        else{
        tv <- readLines(".Renviron")
        if(isTRUE(any(grepl("BLS_KEY",tv)))){
            stop("A BLS_KEY already exists. You can overwrite it with the argument overwrite=TRUE", call.=FALSE)
            }
        }
    }

    keyconcat <- paste("BLS_KEY=","'",key,"'", sep = "")
    # Append API key to .Renviron file
    write(keyconcat, ".Renviron", sep = "\n", append = TRUE)
    message('Your API key has been stored in your .Renviron and can be accessed by Sys.getenv("BLS_KEY")')
    return(key)
}
