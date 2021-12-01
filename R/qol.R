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


#' interleave
#'
#' Interleave two vectors
#' @param v1 Vector 1
#' @param v2 Vector 2
#' @examples interleave(v1 = c(1,2,3) , v2 = c(4,5,6) )
#' @export

interleave <-function (v1, v2) {
  ord1 <- 2 * (1:length(v1)) - 1
  ord2 <- 2 * (1:length(v2))
  c(v1, v2)[order(c(ord1, ord2))]
}


#' gg_color_hue
#'
#' Create an interleaved high-low-luminance pal
#' @param n Number of colours in palette
#' @examples gg_color_hue(n = 10 )
#' @export

gg_color_hue <-function (n) {
  hues = seq(600, 0, length = n)
  interleave(hcl(h = hues, l = 70, c = 70, fixup = T)[1:floor(n/2)], hcl(h = hues, l = 50, c = 70,
                                                                         fixup = T)[1:ceiling(n/2)])
}
