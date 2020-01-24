
scenario_analysis <- function(scenarios = NULL, sampled_and_set_parameters = NULL) { 
  ## Run scenarios and samples against sims
  scenario_sims <- scenarios %>% 
    dplyr::rowwise() %>% 
    dplyr::mutate(sims = list(
      furrr::future_map(
        1:samples, 
        ~ tibble::tibble( 
          size = list(run_ncov_sim(
            n = event_size,
            n_length = event_duration,
            mean_si = sampled_and_set_parameters$serial_mean[.x], 
            sd_si = sampled_and_set_parameters$serial_sd[.x], 
            R0 = sampled_and_set_parameters$R0[.x], 
            k = sampled_and_set_parameters$k[.x], 
            tf = sampled_and_set_parameters$outbreak_length[.x] + event_duration,
            max_potential_cases = upper_case_bound + 1)),
          sample = .x,
          R0 = sampled_and_set_parameters$R0[.x]
        ), 
        .progress = FALSE
      ))) %>% 
    dplyr::ungroup() %>% 
    tidyr::unnest(c("sims")) %>% 
    tidyr::unnest("sims") %>% 
    tidyr::unnest("size")
  }