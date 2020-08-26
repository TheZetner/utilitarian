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
    select(QNAME, RNAME, POS, MAPQ, CIGAR) %>%
    mutate(CIGAR2 = strsplit(CIGAR, "(?<=[MIDNSHP=X])", perl = T)) %>%
    unnest(CIGAR2) %>%
    separate(CIGAR2, into=c("A","B"), sep = -1) %>%
    group_by(QNAME, RNAME, POS) %>%
    mutate(CIGARPOS = cumsum(A)) %>%
    arrange(QNAME, RNAME, POS, CIGARPOS) %>%
    mutate(CIGARPOS2 = lag(CIGARPOS)+1) %>%
    replace_na(list(CIGARPOS2 = 1)) %>%
    rename(CIGARstart = CIGARPOS2, CIGARend = CIGARPOS) %>%
    mutate(POSstart = POS + CIGARstart,
           POSend = POS + CIGARend) %>%
    left_join(ops, by = c("B" = "operation")) %>%
    filter(!is.na(Operation)) %>%
    select(QNAME, RNAME, MAPQ, POS, POSstart, POSend, CIGARstart, CIGARend, Operation)
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
    group_by(RNAME, POS) %>%
    ggplot(aes(y = Operation)) +
    geom_segment(aes(yend = Operation, x = CIGARstart-0.5, xend = CIGARend+0.5, colour = Operation), size = 2) +
    scale_x_continuous(breaks = c(1, seq(5, max(x$CIGARend), by = 5), max(x$CIGARend)), minor_breaks = c(1, seq(5, max(x$CIGARend), by = 5))) +
    facet_grid(RNAME + POS ~ ., scales = "free", labeller = label_both) +
    labs(x = "Cigar Position",
         y = "Operation",
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
    group_map(~ plot_cigar(.x, first(.y)), .keep=T)
  set_names(p, unique(x$QNAME))
}



#' Write SAM to Fasta file
#'
#' Write Query sequences to file as fasta with with QNAME as identifier
#'
#' @param x SAM file in tabular format (eg. as read by read_sam())
#' @param file Path to output file
#' @return Nothing. File written to disk
#'
#' @import readr
#'
#' @export
sam_to_fasta <- function(x, file){

  seqs <- paste(">", x$QNAME, "\n", x$SEQ, "\n", sep = "")
  write_lines(seqs, file)

}
