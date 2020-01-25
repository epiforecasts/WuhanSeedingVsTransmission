##' Get a sampling function for reporting delays
##'
##' This connects to the Google Sheet containing the collated linelist; the
##'   first time this is run, it may require authentiction with Google
##' @param n nu
##' @return a function that takes one parameter, `n`, the number of reporting
##'   delays to randomly sample
##' @importFrom dplyr mutate bind_rows rename filter
##' @importFrom googlesheets4 read_sheet
##' @importFrom fitdistrplus fitdist gofstat
##' @author Sebastian Funk <sebastian.funk@lshtm.ac.uk>
get_rep_sample_fun <- function() {
  url <- "https://docs.google.com/spreadsheets/d/1itaohdPiAeniCXNlntNztZ_oRvjh0HsGuJXUJWET008/edit#gid=0"
  hubei <- googlesheets4::read_sheet(url, sheet = "Hubei")
  outside_hubei <- googlesheets4::read_sheet(url, sheet = "outside_Hubei")

  linelist <- hubei %>%
    dplyr::mutate(sheet = "Hubei") %>%
    dplyr::bind_rows(outside_hubei %>%
                     mutate(sheet = "outside_Hubei")) %>%
    dplyr::rename(date_onset_symptoms_str = "date_onset_symptoms",
                  date_admission_hospital_str = "date_admission_hospital",
                  date_confirmation_str = "date_confirmation") %>%
    dplyr::mutate(date_onset_symptoms =
                    as.Date(date_onset_symptoms_str, format = "%d.%m.%Y"),
                  date_admission_hospital =
                    as.Date(date_admission_hospital_str, format = "%d.%m.%Y"),
                  date_confirmation =
                    as.Date(date_confirmation_str, format = "%d.%m.%Y")) %>%
    dplyr::mutate(delay_confirmation =
                    date_confirmation - date_onset_symptoms,
                  delay_admission =
                    date_admission_hospital - date_onset_symptoms)

  confirmation_delays <- linelist %>%
    dplyr::filter(!is.na(delay_confirmation), country == "China") %>%
    .$delay_confirmation %>%
    as.integer()

  ## fit normal and exponential
  test_distributions <- c("geom", "pois", "nbinom")

  fits <- lapply(setNames(test_distributions, test_distributions), function(x) {
    fitdistrplus::fitdist(confirmation_delays, x)
  })

  gof <- fitdistrplus::gofstat(fits, fitnames = names(fits))

  best_fit <- names(which.min(gof$aic))
  good_fit <- (gof$chisqpvalue[best_fit] > 0.05) ## arbitrary threshold at 0.05

  if (!good_fit) { ## no good fit obtained
    sample_function <- function(n) {
      sample(confirmation_delays, n, replace = TRUE)
    }
  } else {
    pars <- fits[[best_fit]]$estimate
    sample_function <- function(n) {
      do.call(paste0("r", best_fit), c(list(n = n), as.list(pars)))
    }
  }

  return(sample_function)
}
