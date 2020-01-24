condition_on_known <- function(sims, days_since_31st = NULL, lower_bound = NULL, upper_bound = NULL) {
  sims %>% 
    dplyr::filter(time == event_duration + days_since_31st, size < upper_bound, size > lower_bound) %>% 
    dplyr::select(sample, scenario, event_duration, event_size)
}