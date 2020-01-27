##' Get the latest compiled linelist
##'
##' @return a tibble with the lineist
##'   delays to randomly sample
##' @importFrom readr read_csv
##' @importFrom dplyr bind_rows rename mutate
##' @author Sebastian Funk <sebastian.funk@lshtm.ac.uk>
##'
##' @export
get_linelist <- function() {
  gids <- c(outside_hubei = 0, hubei = 429276722)
  urls <- paste0("https://docs.google.com/spreadsheets/d/",
           "1itaohdPiAeniCXNlntNztZ_oRvjh0HsGuJXUJWET008/pub",
           "?single=true&output=csv&gid=", gids)
  linelists <- lapply(urls, readr::read_csv)
  
  
  
  linelists <- dplyr::bind_rows(linelists) %>% 
    dplyr::rename(
      date_onset_symptoms_str = "date_onset_symptoms",
      date_admission_hospital_str = "date_admission_hospital",
      date_confirmation_str = "date_confirmation"
    ) %>%
    dplyr::mutate(
      date_onset_symptoms =
        as.Date(date_onset_symptoms_str, format = "%d.%m.%Y"),
      date_admission_hospital =
        as.Date(date_admission_hospital_str, format = "%d.%m.%Y"),
      date_confirmation =
        as.Date(date_confirmation_str, format = "%d.%m.%Y")
    ) %>%
    dplyr::mutate(
      delay_confirmation =
        date_confirmation - date_onset_symptoms,
      delay_admission =
        date_admission_hospital - date_onset_symptoms
    )
  
  return(linelists)
}
