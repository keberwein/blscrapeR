% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/quick_functions.R
\name{quick_unemp_rate}
\alias{quick_unemp_rate}
\title{Quick unemployment rate function}
\usage{
quick_unemp_rate()
}
\value{
A tibble from the BLS API.
}
\description{
Returns the "official" unemployment rate. That is, seasonally adjusted, 16 year and over, or the "U-3" rate. SeriesID: LNS14000000.
If you installed a BLS_KEY with the \code{set_bls_key()} function, it will detect it and use your key. This counts against your daily query limit.
}
\examples{
\dontrun{
df <- quick_unemp_rate()
}

}
\keyword{quick}
\keyword{rate}
\keyword{unemployment}
