#' Plot a heat map of accepted samples by scenario
#'
#' @param proportion_allowed data.frame of allowed proportions as 
#' produced by `proportion_allowed_by_condition`
#' by `condition_and_report_on_cases`.
#'
#' @return
#' 
#' @export
#' @importFrom tidyr complete
#' @importFrom dplyr mutate_at
#' @importFrom ggplot2 ggplot aes geom_tile scale_fill_continuous facet_grid theme_minimal theme guides guide_colorbar labs
#' @importFrom scales percent
#' @author Sam Abbott
#' @examples
#' 
#' 
plot_scenario_tile <- function(proportion_allowed = NULL) {
  
  proportion_allowed %>% 
    tidyr::complete(event_duration, event_size, serial_mean, upper_R0,
                    fill = list(allowed_per = 0)) %>% 
    dplyr::mutate_at(.vars = c("event_duration", "event_size"), factor) %>% 
    ggplot2::ggplot(ggplot2::aes(x = event_duration, 
                                 y = event_size, fill = allowed_per)) + 
    ggplot2::geom_tile(alpha = 0.95) +
    ggplot2::scale_fill_continuous(label = scales::percent,
                                   type = "viridis", direction = 1) + 
    ggplot2::facet_grid(serial_mean ~ upper_R0) +
    ggplot2::theme_minimal() +
    ggplot2::theme(legend.position = "bottom") +
    ggplot2::guides(fill = ggplot2::guide_colorbar(title = "Percentage of samples accepted")) +
    ggplot2::labs(x = "Seeding event duration", 
                  y = "Seeding event size")
}