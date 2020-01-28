#' Plot density plots of the basic reproduction number
#'
#'
#' @inheritParams summarise_end_r0
#' @return A ggplot2 plot of R0 density over the scenarios explored
#' @export
#' @importFrom dplyr group_by filter ungroup
#' @importFrom ggplot2 ggplot aes stat scale_fill_continuous facet_grid theme_minimal labs theme guides guide_colorbar
#' @importFrom ggridges geom_density_ridges_gradient
#' @examples
#' 
#' ## Code
#' plot_R0_density
plot_R0_density <- function(sims = NULL) {
  
  
  ## CRAN check - dealing with global variables
  scenario <- NULL; time <- NULL; event_size <- NULL;
  x <- NULL; R0 <- NULL;
  
    
  
  
  plot <- sims %>% 
    dplyr::group_by(scenario, sample) %>% 
    dplyr::filter(time == max(time)) %>% 
    dplyr::ungroup() %>% 
    ggplot2::ggplot(ggplot2::aes(x = R0, y = factor(event_size), fill = stat(x))) +
    ggridges::geom_density_ridges_gradient(quantile_lines = TRUE, quantiles = c(0.05, 0.95)) +
    ggplot2::facet_grid(serial_mean ~ event_duration) +
    ggplot2::scale_fill_continuous(type = "viridis", direction = 1) + 
    ggplot2::theme_minimal() +
    ggplot2::labs(x = "Reproduction number (R0)", 
                  y = "Transmission event size") +
    ggplot2::theme(legend.position = "bottom") +
    ggplot2::guides(fill = ggplot2::guide_colorbar(title = "R0"))
  
  return(suppressWarnings(suppressMessages(plot)))
}