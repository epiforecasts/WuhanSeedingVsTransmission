#' Make seeding event duration vs event size table
#'
#' @param results The output from `summarised_end_r0` 
#'
#' @return
#' @export
#' @importFrom dplyr select rename
#' @importFrom tidyr spread
#' @author Sam Abbott
#' @examples
#' 
#' 
make_duration_size_table <- function(results = NULL) {
  results %>% 
    dplyr::select(-median_R0, -min_R0, -max_R0, -samples) %>% 
    tidyr::spread(key = "event_duration", 
                  value = "R0") %>% 
    dplyr::rename(`Seeding event size vs. Seeding event duration` = event_size)
}
