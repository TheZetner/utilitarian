#' Not In
#'
#' Opposite of %in%
#'
#' @param x Vector of values
#' @param y Another vector of values
#' @return Vector of values that are in X but not in Y
#' @examples
#' \dontrun{
#'  x %notin% y
#'  }
#' @export
`%notin%` <- function(x,y) {!(x %in% y)}
