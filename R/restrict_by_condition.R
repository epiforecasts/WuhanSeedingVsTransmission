#' Restrict scenarios based on allowed scenarios
#'
#' @param sims A data.table from `scenario_analysis`.
#' @param allowed_scenarios A data.table of allowed scenarios. Must include a scenario and sample
#' variable.
#' @param restriction_var Character vector of variables to use to restrict scenarios. Defaults to "scenario" and 
#' "sample".
#' @return A data frame of scenarios restricted by the allowed scenarios
#' @export
#' @import data.table
#' @author Sam Abbott
#' @examples
#' 
#' 
#' ## Example
#' sims <- data.table::data.table(scenario = 1:10, sample = 1:10, value = 1:10)
#' 
#' allowed_scenarios <- data.table::data.table(scenario = c(1,4,6), sample = c(1, 4, 6))
#' 
#' restrict_by_condition(sims, allowed_scenarios)
#' 
#' ## Code 
#' restrict_by_condition
restrict_by_condition <- function(sims, allowed_scenarios, restriction_var = c("scenario", "sample")) {
  
  ## NULL out for CRAN 
  scenario <- NULL; sample <- NULL;
  
  allowed_scenarios <- allowed_scenarios[, colnames(allowed_scenarios) %in% restriction_var, with = FALSE]
  
  restrict_sims <- sims[allowed_scenarios, on = restriction_var]
  
  return(restrict_sims)
}