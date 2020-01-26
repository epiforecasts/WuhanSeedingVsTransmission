#' Summarise R0 estimates across samples
#'
#' @inheritParams restrict_by_condition
#' @return
#' @export
#' @importFrom dplyr group_by filter summarise ungroup mutate_at mutate n
#' @author Sam Abbott
#' @examples
#' 
#' 
summarise_end_r0 <- function(sims) {
  restricted_scenarios <- sims  %>% 
    dplyr::group_by(event_size, event_duration) %>% 
    dplyr::filter(time == max(time)) %>% 
    dplyr::group_by(event_size, event_duration) %>% 
    dplyr::summarise(median_R0 = median(R0, na.rm = TRUE), 
                     min_R0 = min(R0, na.rm = TRUE), 
                     max_R0 = max(R0, na.rm = TRUE),
                     samples = dplyr::n()) %>% 
    dplyr::ungroup() %>% 
    dplyr::mutate_at(.vars = c("median_R0", "min_R0", "max_R0"), ~ round(., 1)) %>% 
    dplyr::mutate(R0 = paste0(median_R0, " (", min_R0, " - ", max_R0, ")"))
}

