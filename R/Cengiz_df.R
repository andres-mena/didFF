#' Cengiz et. al (2019) data set
#'
#' A dataset containing quarterly U.S. wage density and minimun wage by state between years 1979 and 2016
#'
#' @format A data frame with 914736 rows and 14 variables:
#' \describe{
#'   \item{wagebinstate}{wagebin-state id}
#'   \item{wagebins}{wagebin id}
#'   \item{statenum}{state id}
#'   \item{year}{year}
#'   \item{quarterdate}{quarter}
#'   \item{overallcountpc}{employment per capita at wagebin-state-quarter level}
#'   \item{treated_quarter}{was state treated (quarterly)}
#'   \item{treated_year}{Was state treated (cumulative for the last 4 quarters)}
#'   \item{L0logmw}{log of minimun wage at quarter t}
#'   \item{MW}{minimun wage at quarter t}
#'   \item{population}{population at state-quarter level}
#'   \item{wtoverall1979}{fixed 1979 weights}
#'   \item{treated}{treatment indicator}
#'   \item{w}{Total employment at wagebin-state-quarter level}
#'   ...
#' }
#' @source \url{https://doi.org/10.1093/qje/qjz014}
"Cengiz_df"
