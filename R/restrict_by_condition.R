#' Restrict scenarios based on allowed scenarios
#'
#' @param sims A dataframe as produced by `scenario_analysis`.
#' @param allowed_scenarios A dataframe of allowed scenarios. Must include a scenario and sample
#' variable.
#'
#' @return
#' @export
#' @importFrom dplyr right_join select
#' @examples
#' 
#' 
restrict_by_condition <- function(sims, allowed_scenarios) {
  
  allowed_scenarios <- allowed_scenarios %>% 
    dplyr::select(scenario, sample)
  
  restrict_sims <- sims %>% 
    dplyr::right_join(allowed_scenarios, by = c("scenario", "sample")) 
  
  return(restrict_sims)
}