#' Compare Sequences
#'
#' Produces a table showing all the variants between two DNAString objects
#'
#' @param ref Reference
#' @param seq Sequence to compare
#' @return 3 column tibble of Position, Ref, and ALT
#'
#' @importFrom tibble tibble
#'
#' @examples
#' \dontrun{
#'  compareSeq(aln[[1]], aln[[2]])
#'  }
#' @export

compareSeq <- function(ref, seq){
  diffsites <- which(!as.matrix(ref) == as.matrix(seq))
  tibble(POS = diffsites,
         REF = strsplit(as.character(ref),"")[[1]][diffsites],
         ALT = strsplit(as.character(seq),"")[[1]][diffsites])
}
