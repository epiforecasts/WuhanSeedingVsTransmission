#' Proportion of samples per scenario allowed by condition
#'
#' @param samples Numeric, the number of samples that were used.
#' @param group_var Character vector, the grouping variables to use to split scenarios.
#' @return A data.table listing the proportion allowed by scenario
#' @export
#' @inheritParams restrict_by_condition
#' @import data.table
#' @author Sam Abbott
#' @examples
#' 
#' 
#' sims <- data.table::data.table(sample = 1:10, event_duration = 1,
#'                                event_size = 1:10)

#' proportion_allowed_by_condition(sims, samples = 100, 
#'                                 group_var = c("event_duration"))
proportion_allowed_by_condition <- function(sims, samples = NULL, 
                                            group_var = c("scenario", "event_duration", 
                                                          "event_size", "serial_mean", 
                                                          "upper_R0", "lower_R0")) {
  
  ## NULL out for CRAN check
  . <- NULL; allowed_per <- NULL; 
  
  out <- sims[, .(allowed_per = .N / samples), 
              by = group_var]
  
  return(out)
}
