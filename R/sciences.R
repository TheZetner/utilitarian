#' Compare Sequences
#'
#' Produces a table showing all the variants between two DNAString objects
#'
#' @param ref Reference
#' @param seq Sequence to compare
#' @return 3 column tibble of Position, Ref, and ALT
#'
#' @import tibble
#'
#' @export

compareSeq <- function(ref, seq){
  diffsites <- which(!as.matrix(ref) == as.matrix(seq))
  tibble::tibble(POS = diffsites,
         REF = strsplit(as.character(ref),"")[[1]][diffsites],
         ALT = strsplit(as.character(seq),"")[[1]][diffsites])
}

# CIGAR Related ####


# Functions ####


#' Read SAM
#'
#' Read in SAM file as tibble
#'
#' @param file path to file
#' @return 11 column tibble of QNAME, FLAG, RNAME, POS, MAPQ, CIGAR, RNEXT, PNEXT, TLEN, SEQ, QUAL
#'
#' @import readr
#'
#' @export

read_sam <- function(file){
  readr::read_delim(file,
             "\t",
             escape_double = FALSE,
             col_names = samcols,
             comment = "@",
             trim_ws = TRUE)
}


#' Tidy CIGAR Data
#'
#' Split and tidy CIGARS from read_sam's tibble. Groups by QNAME and RNAME.
#'
#' @param x SAM in tibble format
#' @return 6 column tibble of QNAME, RNAME, MAPQ, CIGARstart, CIGARend, Operation
#' @import tibble dplyr tidyr
#'
#'
#' @export

tidy_cigar <- function(x){
  x %>%
    select(QNAME, RNAME, MAPQ, CIGAR) %>%
    mutate(CIGAR2 = strsplit(CIGAR, "(?<=[MIDNSHP=X])", perl = T)) %>%
    unnest(CIGAR2) %>%
    separate(CIGAR2, into=c("A","B"), sep = -1) %>%
    group_by(QNAME, RNAME) %>%
    mutate(CIGARPOS = cumsum(A)) %>%
    do(add_row(., QNAME = unique(.$QNAME), RNAME = first(.$RNAME, 1), MAPQ = first(.$MAPQ, 1), CIGAR = first(.$CIGAR, 1), A = first(.$A, 1), B = first(.$B, 1), CIGARPOS = 1)) %>%
    arrange(QNAME, CIGARPOS) %>%
    mutate(CIGARPOS2 = lag(CIGARPOS)) %>%
    filter(!is.na(CIGARPOS2)) %>%
    rename(CIGARstart = CIGARPOS2, CIGARend = CIGARPOS) %>%
    select(QNAME, RNAME, MAPQ, CIGARstart, CIGARend, operation = B) %>%
    left_join(ops, by = "operation") %>%
    filter(!is.na(Operation))
}


#' Plot CIGAR
#'
#' Plot one Query's CIGAR data, facet by RNAME, and colour by Operation
#'
#' @param x tidied cigar data from tidy_cigar
#' @param qname Query Template Name eg. Read ID
#' @return Plot of the CIGAR, facetted by Reference
#'
#' @import dplyr ggplot2
#'
#' @export

plot_cigar <- function(x, qname){
  x %>%
    filter(QNAME == qname) %>%
    ggplot(aes(x = Operation)) +
    geom_segment(aes(xend = Operation, y = CIGARstart, yend = CIGARend, colour = Operation), size = 4) +
    facet_grid(RNAME ~ ., scales = "free") +
    coord_flip() +
    labs(y = "Cigar Position",
         x = "Operation",
         title = qname)
}


#' Plot All CIGARs
#'
#' Plot all Queries from tidied cigar table, facet by Reference, and colour by Operation
#'
#' @param x tidied cigar data from tidy_cigar
#' @param lg Create large lists: will warn if over 20 reads in SAM. Better to filter prior
#' @return List of Plots
#'
#' @import dplyr ggplot2 purrr
#'
#' @export

plot_all_cigars <- function(x, lg = F){
  if(n_distinct(x$QNAME) > 20 & lg == FALSE){return(message("Are you sure you want to create ", n_distinct(x$QNAME), " plots? Use argument lg=TRUE or filter your reads."))}
  p <- x %>%
    group_by(QNAME) %>%
    group_map(~ plot_cigar(.x, unique(.y)), .keep=T)
  p
}

