#' Proportion of samples per scenario allowed by condition
#'
#' @param samples Numeric, the number of samples that were used.
#'
#' @return A data.table listing the proportion allowed by scenario
#' @export
#' @inheritParams restrict_by_condition
#' @import data.table
#' @author Sam Abbott
#' @examples
#' 
#' ## Code 
#' proportion_allowed_by_condition
proportion_allowed_by_condition <- function(sims, samples = NULL) {
  
  ## NULL out for CRAN check
  . <- NULL; allowed_per <- NULL; scenario <- NULL; event_duration <- NULL;
  event_size <- NULL; serial_mean <- NULL; upper_R0 <- NULL;
  
  out <- sims[, .(allowed_per = .N / samples), 
              by = .(scenario, event_duration, event_size, serial_mean, upper_R0)]
  
  return(out)
}
