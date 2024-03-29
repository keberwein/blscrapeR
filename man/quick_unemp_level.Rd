% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/quick_functions.R
\name{quick_unemp_level}
\alias{quick_unemp_level}
\title{Quick unemployment level function}
\usage{
quick_unemp_level()
}
\value{
A tibble from the BLS API.
}
\description{
Returns the unemployment level. SeriesID: LNS13000000.
If you installed a BLS_KEY with the \code{set_bls_key()} function, it will detect it and use your key. This counts against your daily query limit.
}
\examples{
\dontrun{
df <- quick_unemp_level()
}

}
\keyword{quick}
\keyword{rate}
\keyword{unemployment}
