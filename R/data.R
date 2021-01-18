#' Plain English CIGAR Operation Names
#'
#' A dataset containing the translations from codes to english for CIGAR operations
#'
#' @format A tibble with 9 rows and 2 variables:
#' \describe{
#'   \item{operation}{CIGAR codes: M I D N S H P = X}
#'   \item{Operation}{Translated codes: Match Insertion Deletion Skipped Soft Clip Hard Clip Padding Sequence Match Sequence Mismatch}
#'   ...
#' }
#' @source \url{https://drive5.com/usearch/manual/cigar.html}
"ops"

#' Plain English SAM Column Names
#'
#' A dataset containing the columns of a SAM file
#'
#' @format An 11-element character vector:
#' \describe{
#'   \item{chr}{column names: QNAME FLAG RNAME POS MAPQ CIGAR RNEXT PNEXT TLEN SEQ QUAL}
#'   ...
#' }
#' @source \url{http://samtools.github.io/hts-specs/SAMv1.pdf}
"samcols"




