#' Run the scenario analysis grid. 
#'
#' @param end_date Character string in the format `"2020-01-01"`. The date to run the model too.
#' @param samples Numeric, defaults to 1. The number of samples to take for each scenario.
#' @param upper_case_bound Numeric, defaults to `NULL`. The upper bound on the number of cases that will be 
#' modelled
#' @param delay_sample_func Function to generate sample reporting delays. If not supplied defaults to 
#' a delay function fitted to the linelist of Chinese cases.
#' @importFrom tibble tibble
#' @importFrom tidyr expand_grid
#' @inheritParams scenario_analysis
#' @return A data.frame of scenarios as returned by `scenario_analysis`
#' @export
#' @author Sam Abbott
#'
#' @examples
#' 
#' \dontrun{
#' grid_results <- run_scenario_grid("2020-01-25", samples = 1, 
#'                   upper_case_bound = 100, show_progress = TRUE)
#'                   
#'grid_results
#' }

run_scenario_grid <- function(end_date = NULL, samples = 1, upper_case_bound = NULL,
                              show_progress = FALSE, delay_sample_func = NULL) {

  ## Use default delay func if not supplied
  if (is.null(delay_sample_func)) {
    delay_sample_func <- WuhanSeedingVsTransmission::fitted_delay_sample_func
  }

  ## Set up scenarios
  scenarios <- tidyr::expand_grid(
    event_size = c(20, 40, 60, 80, 100, 200, 400, 800),
    event_duration = c(7, 14, 21, 28),
    ## Serial mean (normal)
    serial_mean = c(4, 8.4, 12),
    #8.4 from Lispsitch et al. (2003);  12 is assumption driven
    ## Uppper bound on the reproduction number
    ## Sampled from a uniform distribution 
    R0 = list(tibble::tibble(upper_R0 = c(1, 2, 3, 4, 4),
                        lower_R0 = c(0, 1, 2, 3, 0))),
  ) %>% 
    ## Add a scenario id
    tidyr::unnest("R0") %>% 
    dplyr::mutate(scenario = 1:dplyr::n())
  
  ## Sample paramters and set assumptions
  sampled_and_set_parameters <- tibble::tibble(
    sample = 1:samples,
    ## Scenario analysis parameters
    ## Serial sd (normal)
    serial_sd =  3.8, ## from Lispsitch et al. (2003)
    ## k
    k = 0.16, ## from Lloyd-Smith (2005).
    ##Outbreak length
    outbreak_length = (lubridate::as_date(end_date) - lubridate::as_date("2019-12-31")) %>% 
      as.numeric(),
    ## Define an upper case bound currently
    upper_case_bound = upper_case_bound
  )
  
  
  ## Run scenarios and samples against sims
  scenario_sims <- scenarios %>% 
    WuhanSeedingVsTransmission::scenario_analysis(sampled_and_set_parameters, 
                                                  delay_sample_func,
                                                  show_progress = show_progress)
  
  return(scenario_sims)
}
