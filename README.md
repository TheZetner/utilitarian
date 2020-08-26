# utilitarian <img src="man/figures/logo.png" align="right" />

![](man/figures/trolley.png "Trolley https://qph.fs.quoracdn.net/main-qimg-3b9c36fceab7d0170fb30e912f145287")

> *Utilitarian Ethics:*  
> An action is right if it leads to the most happiness for the greatest number of people.

> *Utilitarian Functions:*  
> A function is worthwhile if it leads to the most usefulness for the greatest number of users.

_utilitarian_ is a package 'full' of useful R functions that reduce the day to day pain of using R as experienced by its author.

### Installation

```remotes::install_github("TheZetner/utilitarian")```

### Current functions:

_Sources listed if written by other than Adrian_

**Package Related**  

  * `usePackage()` 
      - Tries to attach a package, if missing: tries to install it. [Source](https://github.com/sussyfuss/usefulScripts)  
  * `libraries()`  
      - Attach numerous packages at once using bare names, quoted names, or a character vector of names  

**Addins**

  * `insertViewAddin()`  
      - To quickly cut a pipeline short and view the tibble at that step. Find in the Addin menu or bind it to something convenient.
  * `insertGlimpseAddin()`  
      - To quickly cut a pipeline short and glimpse the tibble at that step. Find in the Addin menu or bind it to something convenient.

**Maths**

  * `normalize()`
      - Normalize a numeric vector over a supplied range 

**Quality of Life**

  * `%notin%`
      - Not In. Find out what's in one vector and... not in another.
      
**Sciences**

  * `compareSeq()`
      - Produces a table showing all the variants between two DNAString objects
  
  * `read_sam()`
      - Read in SAM file as tibble
      
  * `tidy_cigar()`
      - Split and tidy CIGARS from read_sam's tibble. Groups by QNAME and RNAME
      
  * `plot_cigar()`
      - Plot one Query's CIGAR data, facet by RNAME, and colour by Operation

  * `plot_all_cigars()`
      - Plot all Queries from tidied cigar table, facet by Reference, and colour by Operation
      
  * `sam_to_fasta()`
      - Write SAM Query sequences to file as fasta with with QNAME as identifier
