% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sciences.R
\name{plot_cigar}
\alias{plot_cigar}
\title{Plot CIGAR}
\usage{
plot_cigar(x, qname)
}
\arguments{
\item{x}{tidied cigar data from tidy_cigar}

\item{qname}{Query Template Name eg. Read ID}
}
\value{
Plot of the CIGAR, facetted by Reference
}
\description{
Plot one Query's CIGAR data, facet by RNAME, and colour by Operation
}
