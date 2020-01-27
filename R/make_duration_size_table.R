#' Make seeding event duration vs event size table
#'
#' @param results The output from `summarised_end_r0` 
#'
#' @return A data.frame comparing transmission event size with duration
#' @export
#' @importFrom dplyr select rename mutate_all
#' @importFrom tidyr spread replace_na
#' @author Sam Abbott
#' @examples
#' 
#' ## Code
#' make_duration_size_table
make_duration_size_table <- function(results = NULL) {
  
  ## NULL out variables for CRAN
  median_R0 <- NULL; min_R0 <- NULL; max_R0 <- NULL;
  samples <- NULL; event_size <- NULL;
  
  results %>% 
    dplyr::select(-median_R0, -min_R0, -max_R0, -samples) %>% 
    tidyr::spread(key = "event_duration", 
                  value = "R0") %>% 
    dplyr::mutate_all(tidyr::replace_na, " - ") %>% 
    dplyr::rename(`Transmission event size vs. Transmission event duration` = event_size)
}
