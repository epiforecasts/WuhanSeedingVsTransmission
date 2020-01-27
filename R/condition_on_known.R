#' Condition on known cases
#'
#' @param days_since_end_seed Numeric, the number of days since the end of the seeding event.
#' @param lower_bound Numeric, the estimated lower bound on cases.
#' @param upper_bound Numeric, the estimated upper bound on cases.
#'
#' @inheritParams restrict_by_condition
#' @return A data.table of conditioned scenarios
#' @export
#' @import data.table
#' @author Sam Abbott
#' @examples
#' 
#' ## Code
#' condition_on_known
condition_on_known <- function(sims, days_since_end_seed = NULL, lower_bound = NULL, 
                               upper_bound = NULL) {
  
  ## NULL out variables for CRAN checks
  time <- NULL; event_duration <- NULL; size <- NULL;
  . <- NULL; scenario <- NULL; event_size <- NULL; 
  serial_mean <- NULL; upper_R0 <- NULL;
  
  out <- sims[time == event_duration + days_since_end_seed & 
                size < upper_bound &
                size > lower_bound,
              .(sample, scenario,  event_duration, event_size, serial_mean, upper_R0)]
  
  return(out)
}
