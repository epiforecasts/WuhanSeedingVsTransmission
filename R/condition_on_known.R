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
#' ## Example
#' sims <- data.table::data.table(
#'                    time = rep(1:10, 10),
#'                    size = rep(1:10, 10),
#'                    sample = unlist(lapply(1:10, function(.) {rep(., 10)})),
#'                    scenario = c(rep(1, 5), rep(1, 5)),
#'                    tmp = c(rep(1, 5), rep(1, 5)),
#'                    event_duration = 1
#'                   )
#' 
#'  sims <- data.table::data.table(scenario = 1:10, sample = 1:10, size = 1:10,
#'                                 event_duration = rep(c(1, 2), 5), time = 1:10)
#'                                 
#' condition_on_known(sims, upper_bound = 5, lower_bound = 3, days_since_end_seed = 0)
#' 
#' 
#' ## Code 
#' condition_on_known
condition_on_known <- function(sims, days_since_end_seed = NULL, 
                               lower_bound = NULL, 
                               upper_bound = NULL) {
  
  ## NULL out variables for CRAN checks
  time <- NULL; event_duration <- NULL; size <- NULL;
  
  out <- sims[time == event_duration + days_since_end_seed & 
                size < upper_bound &
                size > lower_bound, !"time"]
  
  return(out)
}
