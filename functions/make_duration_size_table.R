make_duration_size_table <- function(results = NULL) {
  results %>% 
    dplyr::select(-median_R0, -lower_R0, -upper_R0, -samples) %>% 
    tidyr::spread(key = "event_duration", 
                  value = "R0") %>% 
    dplyr::rename(`Seeding event size vs. Seeding event duration` = event_size) %>% 
    knitr::kable()
}
