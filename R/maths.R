#' Normalize
#'
#' Normalizes a vector of values to a range of 0-1
#' x - min(x)) / (max(x) - min(x)
#'
#' @param x Vector of values
#' @param newlims numeric vector of new minimum and maximum eg. c(2,4)
#' @return Normalized vector of values to newmax and newmin
#' @examples
#' normalize(mtcars$mpg)
#' normalize(mtcars$mpg, c(5, 10))
#' @export
normalize <- function(x, newlims = c(0,1)){
  x <- (x - min(x)) / (max(x) - min(x))
  x * (newlims[2] - newlims[1]) + newlims[1]
}


