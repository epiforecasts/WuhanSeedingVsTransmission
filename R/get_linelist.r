##' Get the latest compiled linelist
##'
##' @return a tibble with the lineist
##'   delays to randomly sample
##' @importFrom readr read_csv
##' @author Sebastian Funk <sebastian.funk@lshtm.ac.uk>
##'
##' @export
get_linelist <- function() {
  gids <- c(outside_hubei = 0, hubei = 429276722)
  urls <-
    paste0("https://docs.google.com/spreadsheets/d/",
           "1itaohdPiAeniCXNlntNztZ_oRvjh0HsGuJXUJWET008/pub",
           "?single=true&output=csv&gid=", gids)
  linelists <- lapply(urls, read_csv)
  return(bind_rows(linelists))
}
