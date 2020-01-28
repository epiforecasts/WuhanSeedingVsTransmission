
#' Run a scenario analyis
#'
#' @param scenarios Dataframe of potential scenarios
#' @param sampled_and_set_parameters Dataframe of sampled and fixed parameter values
#' @param delay_sample_func Function to generate sample reporting delays
#' @param show_progress Logical, defaults to FALSE. Show progress be shown.
#'
#' @inheritParams run_sim
#' @return A nested dataframe of scenarios combined with model simulations
#' @export
#' @importFrom dplyr rowwise mutate ungroup sample_frac bind_rows
#' @importFrom tidyr unnest 
#' @importFrom purrr map
#' @importFrom furrr future_map
#' @author Sam Abbott
#' @examples
#' 
#' ## Code 
#' scenario_analysis
scenario_analysis <- function(scenarios = NULL, 
                              sampled_and_set_parameters = NULL,
                              delay_sample_func = NULL,
                              show_progress = FALSE,
                              kept_times) { 
  
  ## NULL out for CRAN
  scenario <- NULL; data <- NULL;

  
  ## Run scenarios and samples against sims
  scenario_sims <- scenarios %>% 
    dplyr::group_by(scenario) %>% 
    tidyr::nest() %>% 
    dplyr::ungroup() %>% 
    ##Randomise the order of scenarios - helps share the load across cores
    dplyr::sample_frac(size = 1, replace = FALSE) %>%
    dplyr::mutate(sims = 
      furrr::future_map(
        data, 
        function(data) {
          
          ## sample R0 from scenario
          sampled_R0 <- stats::runif(nrow(sampled_and_set_parameters),
                                     data$lower_R0, 
                                     data$upper_R0)
          
          ## Run model for specified number of samples
          sims <- purrr::map(
          1:nrow(sampled_and_set_parameters), 
          function(.x) {
            sim <- tibble::tibble( 
            size = list(WuhanSeedingVsTransmission::run_sim(
              n = data$event_size,
              n_length = data$event_duration,
              mean_si = data$serial_mean, 
              sd_si = sampled_and_set_parameters$serial_sd[.x], 
              R0 = sampled_R0[.x], 
              k = sampled_and_set_parameters$k[.x], 
              tf = sampled_and_set_parameters$outbreak_length[.x] + data$event_duration,
              kept_times = kept_times + data$event_duration,
              max_potential_cases = sampled_and_set_parameters$upper_case_bound + 1,
              delay_sample = delay_sample_func)),
            sample = .x,
            R0 = sampled_R0[.x]
          )
          sim <-  tidyr::unnest(sim, "size")
           
          return(sim)
          }
        )
          
          sims <- dplyr::bind_rows(sims)
          
          }, 
        .progress = show_progress
      ))
  
  
  scenario_sims <- tidyr::unnest(scenario_sims, "data")
  scenario_sims <- tidyr::unnest(scenario_sims, "sims")
  
  return(scenario_sims)
  }
