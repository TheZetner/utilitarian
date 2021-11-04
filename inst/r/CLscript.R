#!/usr/bin/env Rscript

# Script ####

suppressPackageStartupMessages({
  library(optparse)
})

option_list <- list(
  make_option(c("-i", "--input"),
              action="store",
              default="../data/input1.tsv",
              help="National DB TSV"),
  make_option(c("-o", "--outdir"),
              action="store",
              default=paste(Sys.Date(), "_output", sep = ""),
              help="Output directory")
)

opt <- parse_args(OptionParser(option_list=option_list), positional_arguments = TRUE)

fileprefix <- tools::file_path_sans_ext(opt$options$output)

message(paste("I'm a stupid message telling you your args are:\n", 
              paste(names(opt$options), unlist(opt$options), sep = ":", collapse = ",\n"), 
              sep = "",
              collapse = ""))


