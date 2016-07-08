
#' @title Quick unemployment rate function
#' @description Returns the "official" unemployment rate. That is, seasonally adjusted, 16 year and over, or the "U-3" rate. SeriesID: LNS14000000.
#' If you installed a BLS_KEY with the \code{set_bls_key()} function, it will dectect it and use your key. This counts against your daily query limit.
#' @keywords quick unemployment rate
#' @export quick_unemp_rate
#' @examples
#' \dontrun{
#' df <- quick_unemp_rate()
#' }
#' 

quick_unemp_rate <- function (){
    if(Sys.getenv("BLS_KEY")=="BLS_KEY"){
        bls_api("LNS14000000", registrationKey = "BLS_KEY")
    }
    else{
        bls_api("LNS14000000")
    }
}


#' @title Quick unemployment level function
#' @description Returns the unemployment level. SeriesID: LNS13000000.
#' If you installed a BLS_KEY with the \code{set_bls_key()} function, it will dectect it and use your key. This counts against your daily query limit.
#' @keywords quick unemployment rate
#' @export quick_unemp_level
#' @examples
#' \dontrun{
#' df <- quick_unemp_level()
#' }
#' 

quick_unemp_level <- function (){
    if(Sys.getenv("BLS_KEY")=="BLS_KEY"){
        bls_api("LNS13000000", registrationKey = "BLS_KEY")
    }
    else{
        bls_api("LNS13000000")
    }
}


#' @title Quick employed rate
#' @description Returns the "employment to population ratio." SeriesID: LNS12300000
#' If you installed a BLS_KEY with the \code{set_bls_key()} function, it will dectect it and use your key. This counts against your daily query limit.
#' @keywords quick unemployment rate
#' @export quick_employed_rate
#' @examples
#' \dontrun{
#' df <- quick_employed_rate()
#' }
#' 

# Employment Population Ratio
quick_employed_rate <- function (){
    if(Sys.getenv("BLS_KEY")=="BLS_KEY"){
        bls_api("LNS12300000", registrationKey = "BLS_KEY")
    }
    else{
        bls_api("LNS12300000")
    }
}



#' @title Quick employed level
#' @description Returns the employment level. SeriesID: LNS12000000
#' If you installed a BLS_KEY with the \code{set_bls_key()} function, it will dectect it and use your key. This counts against your daily query limit.
#' @keywords quick unemployment rate
#' @export quick_employed_level
#' @examples
#' \dontrun{
#' df <- quick_employed_level()
#' }
#' 
quick_employed_level <- function (){
    if(Sys.getenv("BLS_KEY")=="BLS_KEY"){
        bls_api("LNS12000000", registrationKey = "BLS_KEY")
    }
    else{
        bls_api("LNS12000000")
    }
}


#' @title Quick Civilian Labor Force Level
#' @description Returns the civilian labor force level. SeriesID: LNS11000000.
#' If you installed a BLS_KEY with the \code{set_bls_key()} function, it will dectect it and use your key. This counts against your daily query limit.
#' @keywords quick unemployment rate
#' @export quick_laborForce_level
#' @examples
#' \dontrun{
#' df <- quick_laborForce_level()
#' }
#'
quick_laborForce_level <- function (){
    if(Sys.getenv("BLS_KEY")=="BLS_KEY"){
        bls_api("LNS11000000", registrationKey = "BLS_KEY")
    }
    else{
        bls_api("LNS11000000")
    }
}


#' @title Quick Civilian Labor Force Rate
#' @description Returns the civilian labor force participation rate. SeriesID: LNS11300000.
#' If you installed a BLS_KEY with the \code{set_bls_key()} function, it will dectect it and use your key. This counts against your daily query limit.
#' @keywords quick unemployment rate
#' @export quick_laborForce_rate
#' @examples
#' \dontrun{
#' df <- quick_laborForce_rate()
#' }
#'
quick_laborForce_rate <- function (){
    if(Sys.getenv("BLS_KEY")=="BLS_KEY"){
        bls_api("LNS11300000", registrationKey = "BLS_KEY")
    }
    else{
        bls_api("LNS11300000")
    }
}
