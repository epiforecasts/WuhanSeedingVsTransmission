#' Make seeding event duration vs event size table
#'
#' @param results The output from `summarised_end_r0` 
#' @param required_var A character string of variables to select for the table.
#' @param spread_var A character variable indicating the variable to spread.
#' @param spread_value A character variable to use as the spreading value.
#' @param rename_var A character variable to rename.
#' @param renamed_var A character variable indicating the name of the renamed variable
#' @return A data.frame comparing transmission event size with duration
#' @export
#' @importFrom dplyr select rename_at mutate_all
#' @importFrom tidyr spread 
#' @author Sam Abbott
#' @examples
#' 
#' ## Example
#' results <- data.frame(R0 = runif(10, 0, 1), 
#'                       event_duration = 1:10, 
#'                       event_size = rep(c(1,2), 5),
#'                       tmp = 1:10)
#'                       
#' make_duration_size_table(results)
#' 
#' 
#' ## Code
#' make_duration_size_table
make_duration_size_table <- function(results = NULL, required_var = c("event_duration", "event_size", "R0"),
                                     spread_var = "event_duration", spread_value = "R0", rename_var = "event_size", 
                                     renamed_var = "Transmission event size vs. Transmission event duration (days)") {
  
  out <- results %>% 
    dplyr::select(required_var) %>% 
    tidyr::spread(key = spread_var, 
                  value = spread_value) %>% 
    dplyr::rename_at(.vars = rename_var, ~ paste0(renamed_var)) %>% 
    dplyr::mutate_all(~ tidyr::replace_na(., " - "))
  
  return(out)
}
