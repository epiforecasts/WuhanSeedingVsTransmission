#' Condition on known cases
#'
#' @param days_since_end_seed Numeric, the number of days since the end of the seeding event.
#' @param lower_bound Numeric, the estimated lower bound on cases.
#' @param upper_bound Numeric, the estimated upper bound on cases.
#'
#' @inheritParams restrict_by_condition
#' @return
#' @export
#' @importFrom dplyr filter select
#' @author Sam Abbott
#' @examples
#' 
#' 
condition_on_known <- function(sims, days_since_end_seed = NULL, lower_bound = NULL, 
                               upper_bound = NULL) {
  sims %>% 
    dplyr::filter(time == event_duration + days_since_end_seed,
                  size < upper_bound, size > lower_bound) %>% 
    dplyr::select(sample, scenario,  event_duration, event_size, serial_mean, upper_R0)
}
