#' Expose Duplicates
#'
#' Sometimes datasets are expected to be tidy but aren't, finding distinct
#' rows of duplicated IDs is easy but finding why they're distinct in many
#' column tables is less straight forward. This functions returns the values
#' that resulted in any duplicated IDs in one of two forms either a named list
#' or a tibble
#'
#' @details Named list of two-column tibbles for each value resulting in duplicate IDs
#' \itemize{
#'  \item{Grouping Variable}
#'  \item{Distinct values}
#'  }
#'
#' @details Tibble with the following columns
#' \itemize{
#'  \item{Grouping Variable}
#'  \item{n * X.grpNdistinct} {number of distinct values for duplicated ID}
#'  \item{n * X.values} {values for that duplicated ID}
#' }
#'
#' https://dplyr.tidyverse.org/articles/programming.html
#'
#' @param x Tibble or Dataframe
#' @param grouping_var Column to look for duplicated values
#' @param listout Flag to return either list or tibble
#' @return List or Dataframe of results
#' @import tidyselect dplyr
#' @examples
#' \donttest{
#'   library(tidyselect)
#'   df <- data.frame(name = sample(letters, 20, replace = TRUE),
#'                month = sample(month.name, 20, replace = TRUE),
#'             letters = sample(LETTERS[1:10], 20, replace = TRUE),
#'             nums = floor(runif(20, 1, 15)))
#'   dplyr::count(df, name)
#'   exposeDupes(df, name)
#'   exposeDupes(df, name, listout = FALSE)
#'   }
#' @export

exposeDupes <- function(x, grouping_var, listout = TRUE){
  cname <- deparse(substitute(grouping_var))

  df <- x %>%
    group_by({{ grouping_var }}) %>%
    summarise(across(.fns = n_distinct)) %>% # Count distinct per group
    select({{ grouping_var }}, tidyselect::where( ~ is.numeric(.x) && max(.x) > 1)) # Select cols where not distinct


  if(ncol(df) == 1){
    stop(paste0("No duplicated rows detected for ", cname))
  }

  df <- df %>%
    filter_if(is.numeric, any_vars(. > 1)) %>%
    left_join(x, by = cname, suffix = c(".grpNdistinct", ".values")) %>%
    select({{ grouping_var }}, c(ends_with(".grpNdistinct"), ends_with(".values"))) %>%
    select({{ grouping_var }}, sort(tidyselect::peek_vars()))

  if(listout == TRUE){
    l <- df %>%
      mutate(across(.cols = -{{ grouping_var }}, .fns = as.character)) %>%
      pivot_longer(cols = c(-{{ grouping_var }}), names_to = "tempcolnames") %>%
      separate(tempcolnames, sep = "\\.", into = c("colname", "contents"), remove = FALSE) %>%
      group_by(colname) %>%
      split(.$colname)

    purrr::map2(l, names(l), ~ ungroup(.x) %>%
                  filter(contents == "grpNdistinct",
                         value > 1) %>%
                  select({{ grouping_var }}) %>%
                  semi_join(ungroup(.x), ., by = cname) %>%
                  filter(contents == "values") %>%
                  select({{ grouping_var }}, value) %>%
                  distinct() %>%
                  rename(!!.y := value))
  } else {
    df
  }
}

#' Clip Excel: Copy Tibble to Clipboard in Excel Compatible Format
#'
#' The clipExcel function takes in a tibble / dataframe and arguments for row
#' and column names. Its only return value is that tibble copied to the
#' clipboard in a format that can be easily pasted to Excel
#' Taken from \url{https://stackoverflow.com/questions/24704344/copy-an-r-data-frame-to-an-excel-spreadsheet}
#' @param x A tibble.
#' @param row.names Logical, include row names?
#' @param col.names Logical, include column names?
#' @param na What to do with NA values? Default to blank
#' @param ... Any further arguments to write.table
#' @keywords tibble
#' @import utils
#' @export
#' @examples
#' \donttest{ clipExcel(iris) }

clipExcel <- function(x,row.names=FALSE,col.names=TRUE, na = "", ...) {
  write.table(x,"clipboard",sep="\t",row.names=row.names,col.names=col.names,na=na,...)
}

