#' Restrict scenarios based on allowed scenarios
#'
#' @param sims A dataframe as produced by `scenario_analysis`.
#' @param allowed_scenarios A dataframe of allowed scenarios. Must include a scenario and sample
#' variable.
#'
#' @return
#' @export
#' @import data.table
#' @author Sam Abbott
#' @examples
#' 
#' 
restrict_by_condition <- function(sims, allowed_scenarios) {
  
  allowed_scenarios <- allowed_scenarios[, .(scenario, sample)]
  
  restrict_sims <- sims[allowed_scenarios, on = .(scenario, sample)]
  
  return(restrict_sims)
}