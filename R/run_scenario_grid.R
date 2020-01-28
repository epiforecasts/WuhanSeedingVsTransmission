#' Run the scenario analysis grid. 
#'
#' @param end_date Character string in the format `"2020-01-01"`. The date to run the model too.
#' @param start_date Character string in the format `"2020-01-01"`. The date to start the outbreak from + the event duration.
#' @param samples Numeric, defaults to 1. The number of samples to take for each scenario.
#' @param upper_case_bound Numeric, defaults to `NULL`. The upper bound on the number of cases that will be 
#' modelled
#' @param delay_sample_func Function to generate sample reporting delays. If not supplied defaults to 
#' a delay function fitted to the linelist of Chinese cases.
#' @param kept_dates Character vector with dates in the format `"2020-01-01"`. Indicates which dates to return data on. Defaults to all
#' time points
#' @importFrom tibble tibble
#' @importFrom tidyr expand_grid
#' @importFrom purrr map_dbl
#' @inheritParams scenario_analysis
#' @return A data.frame of scenarios as returned by `scenario_analysis`
#' @export
#' @author Sam Abbott
#'
#' @examples
#' 
#' ## Example
#' \dontrun{
#' grid_results <- run_scenario_grid(end_date = "2020-01-25", samples = 1, 
#'                   upper_case_bound = 100, show_progress = TRUE, 
#'                   kept_dates = c("2020-01-01", "2020-01-08", "2020-01-15", "2020-01-25"))
#'                   
#'grid_results
#' }
#' 
#' ## Code
#' run_scenario_grid

run_scenario_grid <- function(end_date = NULL, samples = 1, upper_case_bound = NULL,
                              start_date = "2019-12-31", show_progress = FALSE, 
                              delay_sample_func = NULL, kept_dates = NULL) {

  ## Use default delay func if not supplied
  if (is.null(delay_sample_func)) {
    delay_sample_func <- WuhanSeedingVsTransmission::fitted_delay_sample_func
  }
  
  ## Work out the model times from kept dates
  if (!is.null(kept_dates)) {
    kept_times <-  purrr::map_dbl(kept_dates,
                                     ~ as.numeric(lubridate::as_date(.) - lubridate::as_date(start_date)))
  }else{
    kept_times <- NULL
  }

  ## Set up scenarios
  scenarios <- tidyr::expand_grid(
    event_size = c(20, 40, 60, 80, 100, 200, 400),
    event_duration = c(1, 7, 14, 21, 28),
    ## Serial mean (normal)
    serial = list(tibble::tibble(
      serial_type = c("MERS-like", "SARS-like", "initial SARS-like"),
      serial_mean = c(6.8, 8.4, 10),
      serial_sd = c(4.1, 3.8, 2.8),
      serial_fn = c(WuhanSeedingVsTransmission::rgamma_with_mean_sd, 
                    WuhanSeedingVsTransmission::rweibull_with_mean_sd,
                    WuhanSeedingVsTransmission::rweibull_with_mean_sd)
    )),
    #From Lispsitch et al. (2003);  6, 4, 12 assumption driven
    ## Bounds on the reproduction number
    ## Sampled from a uniform distribution 
    R0 = list(tibble::tibble(upper_R0 = c(1, 2, 3, 4),
                            lower_R0 = c(0, 1, 2, 3)))
  ) %>% 
    ## Add a scenario id
    tidyr::unnest("R0") %>% 
    tidyr::unnest("serial") %>%
    dplyr::mutate(scenario = 1:dplyr::n())
  
  ## Sample paramters and set assumptions
  sampled_and_set_parameters <- tibble::tibble(
    sample = 1:samples,
    ## Scenario analysis parameters
    ## Serial sd (normal)
    ## k
    k = 0.16, ## from Lloyd-Smith (2005).
    ##Outbreak length
    outbreak_length = (lubridate::as_date(end_date) - lubridate::as_date(start_date)) %>% 
      as.numeric(),
    ## Define an upper case bound currently
    upper_case_bound = upper_case_bound
  )
  
  
  ## Run scenarios and samples against sims
  scenario_sims <- scenarios %>% 
    WuhanSeedingVsTransmission::scenario_analysis(sampled_and_set_parameters, 
                                                  delay_sample_func,
                                                  show_progress = show_progress,
                                                  kept_times = kept_times)
  
  return(scenario_sims)
}
