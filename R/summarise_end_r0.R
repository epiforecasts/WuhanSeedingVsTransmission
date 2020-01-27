#' Summarise R0 estimates across samples
#'
#' @inheritParams restrict_by_condition
#' @return A dataframe of R0 estimates for each scenario
#' @export
#' @importFrom dplyr group_by filter summarise ungroup mutate_at mutate n
#' @author Sam Abbott
#' @examples
#' 
#' ## Code
#' summarise_end_r0
summarise_end_r0 <- function(sims) {
  
  ## NULL out for CRAN
  event_size <- NULL; event_duration <- NULL; time <- NULL;
  R0 <- NULL; median_R0 <- NULL; min_R0 <- NULL; max_R0 <- NULL;
  
  restricted_scenarios <- sims  %>% 
    dplyr::group_by(event_size, event_duration) %>% 
    dplyr::filter(time == max(time)) %>% 
    dplyr::group_by(event_size, event_duration) %>% 
    dplyr::summarise(median_R0 = stats::median(R0, na.rm = TRUE), 
                     min_R0 = min(R0, na.rm = TRUE), 
                     max_R0 = max(R0, na.rm = TRUE),
                     samples = dplyr::n()) %>% 
    dplyr::ungroup() %>% 
    dplyr::mutate_at(.vars = c("median_R0", "min_R0", "max_R0"), ~ round(., 1)) %>% 
    dplyr::mutate(R0 = paste0(median_R0, " (", min_R0, " - ", max_R0, ")"))
}

