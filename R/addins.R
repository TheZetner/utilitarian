#' Insert \%>\% View() at cursor position
#'
#' Call this function as an addin to insert \code{ \%>\% View()} at the cursor position.
#' Useful for quickly checking pipeline status. Bind to ctrl+shift+V
#'
#' @export
insertViewAddin <- function() {
  rstudioapi::insertText(" %>% View()")
}

#' Insert \%>\% glimpse() at cursor position
#'
#' Call this function as an addin to insert \code{ \%>\% glimpse()} at the cursor position.
#' Useful for quickly checking pipeline status. Bind to ctrl+shift+V
#'
#'
#' @export
insertGlimpseAddin <- function() {
  rstudioapi::insertText(" %>% glimpse()")
}

#' Insert \%>\% clipExcel() at cursor position
#'
#' Call this function as an addin to insert \code{ \%>\% clipExcel()} at the cursor position.
#' Useful for quickly checking pipeline status. Bind to ctrl+shift+V
#'
#' @export
insertClipExcelAddin <- function() {
  rstudioapi::insertText(" %>% clipExcel()")
}
