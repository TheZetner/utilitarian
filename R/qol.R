#' Not In
#'
#' Opposite of %in%
#'
#' @param x Vector of values
#' @param y Another vector of values
#' @return Vector of logical values inverting X %in% Y
#' @examples
#' \donttest{
#'  names(iris) %notin% "Species"
#'  }
#' @export
`%notin%` <- function(x,y) {!(x %in% y)}
