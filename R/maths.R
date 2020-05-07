#' Normalize
#'
#' Normalizes a vector of values to a range of 0-1
#' x - min(x)) / (max(x) - min(x)
#'
#' @param x Vector of values
#' @param newlims numeric vector of new minimum and maximum eg. c(2,4)
#' @return Normalized vector of values to newmax and newmin
#' @examples
#' \dontrun{
#'  normalize(x)
#'  }
#' @export
normalize <- function(x, newlims = c(0,1)){
  x <- (x - min(x)) / (max(x) - min(x))
  x * (newlims[2] - newlims[1]) + newlims[1]
}



#' Not In
#'
#' Opposite of \%in\%
#'
#' @param x Vector of values
#' @param y Another vector of values
#' @return Vector of values that are in X but not in Y
#' @examples
#' \dontrun{
#'  x %!in% y
#'  }
#' @export
`%!in%` <- function(x,y) {!(x %in% y)}
