proportion_allowed_by_condition <- function(df, samples = NULL) {
  df %>% 
    group_by(scenario, event_duration, event_size) %>% 
    summarise(allowed_per = dplyr::n() / samples)
}
