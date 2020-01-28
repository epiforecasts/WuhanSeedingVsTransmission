##' Get a sampling function for reporting delays
##'
##' This connects to the Google Sheet containing the collated linelist; the
##'   first time this is run, it may require authentiction with Google
##' @return a function that takes one parameter, `n`, the number of reporting
##'   delays to randomly sample
##' @importFrom dplyr filter
##' @importFrom fitdistrplus fitdist gofstat
##' @author Sebastian Funk <sebastian.funk@lshtm.ac.uk>
##' 
##' @export
##' 
##' @examples 
##' 
##' ## Example
##' \dontrun{
##' get_rep_sample_fun()
##' }
##' 
##' ## Code 
##' get_rep_sample_fun
get_rep_sample_fun <- function() {
  
  ## CRAN check - dealing with global variables flag
  delay_confirmation <- NULL; country <- NULL; . <- NULL;

  
  message("Downloading linelist")
  confirmation_delays <- get_linelist() %>%
    dplyr::filter(!is.na(delay_confirmation), country == "China") %>%
    .$delay_confirmation %>%
    as.integer()

  ## fit normal and exponential
  test_distributions <- c("geom", "pois", "nbinom")

  fits <- lapply(stats::setNames(test_distributions, test_distributions), function(x) {
    fitdistrplus::fitdist(confirmation_delays, x)
  })

  gof <- fitdistrplus::gofstat(fits, fitnames = names(fits))

  best_fit <- names(which.min(gof$aic))
  
  message("Best fitting distribution: ", best_fit)
  
  good_fit <- (gof$chisqpvalue[best_fit] > 0.05) ## arbitrary threshold at 0.05

  if (!good_fit) { ## no good fit obtained
    message("Fit below threshold. Sampling from data.")
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
