#' Make seeding event duration vs event size table
#'
#' @param results The output from `summarised_end_r0` 
#'
#' @return
#' @export
#' @importFrom dplyr select rename mutate_all
#' @importFrom tidyr spread replace_na
#' @author Sam Abbott
#' @examples
#' 
#' 
make_duration_size_table <- function(results = NULL) {
  results %>% 
    dplyr::select(-median_R0, -min_R0, -max_R0, -samples) %>% 
    tidyr::spread(key = "event_duration", 
                  value = "R0") %>% 
    dplyr::mutate_all(tidyr::replace_na, " - ") %>% 
    dplyr::rename(`Transmission event size vs. Transmission event duration` = event_size)
}
