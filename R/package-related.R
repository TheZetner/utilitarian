# Library and package related functions

#' Package installing and loading function
#'
#' The usePackage function takes a single command, the name of a package,
#' and will install it, if not already installed, and then load it.
#' Taken from \url{https://github.com/sussyfuss/usefulScripts}
#' @param p A package name as a string in quotes.
#' @keywords use pack
#' @export
#' @examples
#' usePackage("readr")

usePackage <- function(p) {

  if (!is.element(p, installed.packages()[, 1])) {

    message(paste("Package", p, "not found, installing..."))
    install.packages(p, dep = TRUE)

  }

  message(paste0("Loading Package ", p, "..."))
  require(p, character.only = TRUE)

}

#' Call multiple library statements at once
#'
#' Attach a number of library packages at once
#' @author Adrian Zetner
#' @importFrom dplyr enquos
#'
#' @param ... Package names
#' @param verbose Logical whether to announce via message() what packages are being attached.
#' @param quoted Logical whether package names supplied bare or quoted as character
#' @keywords utilitarian library packages
#' @export
#' @examples
#' libraries(dichromat, jsonlite)
#' libraries("dichromat", "jsonlite", quoted = T)
#' libraries(c("dichromat", "jsonlite"), quoted = T)
#' libraries(dichromat, verbose = TRUE)


libraries <- function(..., verbose = F, quoted = F) {
  if (quoted) {
    pkgs <- unlist(list(...))
  } else {
    pkgs <- gsub("~", "", as.character(enquos(...)))
  }
  sapply(pkgs, library, character.only = T)
  if (verbose) {
    message(paste("Attached packages:",
                  paste(pkgs, collapse = ", ")))
    }
}
