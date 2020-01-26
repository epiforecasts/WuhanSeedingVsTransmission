#' Proportion of samples per scenario allowed by condition
#'
#' @param samples Numeric, the number of samples that were used.
#'
#' @return
#' @export
#' @inheritParams restrict_by_condition
#' @importFrom dplyr group_by summarise n ungroup
#' @author Sam Abbott
#' @examples
#' 
#' 
proportion_allowed_by_condition <- function(sims, samples = NULL) {
  sims %>% 
    group_by(scenario, event_duration, event_size, serial_mean, upper_R0) %>% 
    summarise(allowed_per = dplyr::n() / samples) %>% 
    dplyr::ungroup()
}
