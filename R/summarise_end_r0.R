#' Summarise R0 estimates across samples
#'
#'
#' @param group_var Character vector indicating the groups to show. Defaults to
#' `event_duration` and `event_size`
#' @inheritParams restrict_by_condition
#' @return A dataframe of R0 estimates for each scenario
#' @export
#' @importFrom dplyr group_by filter summarise ungroup mutate_at mutate n
#' @importFrom tidyr replace_na
#' @author Sam Abbott
#' @examples
#' 
#' ## Code
#' summarise_end_r0
summarise_end_r0 <- function(sims, group_var = c("event_size", "event_duration")) {
  
  ## NULL out for CRAN
  time <- NULL; R0 <- NULL; median_R0 <- NULL; 
  lower_R0 <- NULL; upper_R0 <- NULL; sample <- NULL;
  scenario <- NULL; date_confirmation_str <- NULL;
  
  restricted_scenarios <- sims  %>% 
    dplyr::group_by(sample, scenario) %>% 
    dplyr::filter(time == max(time)) %>% 
    dplyr::group_by(.dots = group_var) %>% 
    dplyr::summarise(median_R0 = stats::median(R0, na.rm = TRUE), 
                     lower_R0 = stats::quantile(R0, probs = 0.05, na.rm = TRUE), 
                     upper_R0 = stats::quantile(R0, probs = 0.95, na.rm = TRUE),
                     samples = dplyr::n()) %>% 
    dplyr::ungroup() %>% 
    dplyr::mutate_at(.vars = c("median_R0", "lower_R0", "upper_R0"), ~ round(., 1)) %>% 
    dplyr::mutate(R0 = paste0(lower_R0, " - ", upper_R0))
}

