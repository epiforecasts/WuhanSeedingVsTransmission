#' Proportion of samples per scenario allowed by condition
#'
#' @param samples Numeric, the number of samples that were used.
#'
#' @return
#' @export
#' @inheritParams restrict_by_condition
#' @import data.table
#' @author Sam Abbott
#' @examples
#' 
#' 
proportion_allowed_by_condition <- function(sims, samples = NULL) {
  
  
  out <- sims[, .(allowed_per = .N / samples), 
              by = .(scenario, event_duration, event_size, serial_mean, upper_R0)]
  
  return(out)
}
