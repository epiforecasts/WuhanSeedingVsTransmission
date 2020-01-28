#' Plot a heat map of accepted samples by scenario
#'
#' @param proportion_allowed data.frame of allowed proportions as 
#' produced by `proportion_allowed_by_condition`
#' by `condition_and_report_on_cases`.
#'
#' @return A ggplot2 heat-map of accepted percentages by scenario
#' 
#' @export
#' @importFrom tidyr complete
#' @importFrom dplyr mutate_at mutate
#' @importFrom ggplot2 ggplot aes geom_tile scale_fill_continuous facet_grid theme_minimal theme guides guide_colorbar labs
#' @importFrom scales percent_format
#' @author Sam Abbott
#' @examples
#' 
#' ## Code
#' plot_per_accepted_tile
plot_per_accepted_tile <- function(proportion_allowed = NULL) {
  
  
  ## NULL out variables for CRAN
  event_duration <- NULL; event_size <- NULL; serial_mean <- NULL;
  upper_R0 <- NULL; allowed_per <- NULL;  lower_R0 <- NULL; joined_R0 <- NULL;
  
  
  proportion_allowed %>% 
    dplyr::mutate(joined_R0 = paste0(lower_R0, " - ", upper_R0)) %>%
    tidyr::complete(event_duration, event_size, serial_mean, joined_R0,
                    fill = list(allowed_per = 0)) %>% 
    dplyr::mutate_at(.vars = c("event_duration", "event_size"), factor) %>% 
    ggplot2::ggplot(ggplot2::aes(x = event_duration, 
                                 y = event_size, fill = allowed_per)) + 
    ggplot2::geom_tile(alpha = 0.95) +
    ggplot2::scale_fill_continuous(label = scales::percent_format(accuracy = 1L),
                                   type = "viridis", direction = 1) + 
    ggplot2::facet_grid(serial_mean ~ joined_R0) +
    ggplot2::theme_minimal() +
    ggplot2::theme(legend.position = "bottom") +
    ggplot2::guides(fill = ggplot2::guide_colorbar(title = "Percentage of samples accepted")) +
    ggplot2::labs(x = "Transmission event duration", 
                  y = "Transmission event size")
}