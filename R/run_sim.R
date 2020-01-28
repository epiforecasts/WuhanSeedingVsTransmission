#' Negative binomial branching process model
#'
#' @param n Numeric, number of initial cases
#' @param n_length Numeric, the number of days in the initial seeding event
#' @param mean_si Numeric, the mean of the serial interval
#' @param sd_si Numeric, the sd of the serial interval
#' @param serial_fn Function from which to sample the serial interval must 
#' accepted a number of samples argument followed by a mean and standard deviation. If
#' missing defaults to a normal distribution.
#' @param R0 Numeric, the estimated reproduction number
#' @param k Numeric, the dispersion of the negative binomial branching process
#' @param tf Numeric, the end time of the branching process
#' @param max_potential_cases Numeric, the maximum number of cases
#' @param delay_sample A function to sample from reporting delays
#' @param kept_times Numeric, a vector of timepoints to keep information on. Defaults to all
#' time points
#'
#' @return A dataframe containing the simulation time and outbreak size
#' @export
#' @importFrom bpmodels chain_sim
#' @author Sebastian Funk, Sam Abbott, James Munday
#' @examples
#' 
#' ## Example
#' 
#' run_sim(n = 1, n_length = 7, mean_si = 5, sd_si = 2, R0 = 2, 
#'         k=0.16, tf=37, max_potential_cases= 100, 
#'         delay_sample = function(x) {rnorm(x, 6, 1)})
#'         
#' ## Code
#' run_sim
run_sim  = function(n, n_length, mean_si, sd_si, serial_fn = NULL, R0, 
                    k=0.16, tf=37, kept_times = NULL, max_potential_cases,
                    delay_sample) {
  
  if (is.null(kept_times)) {
    kept_times <- 0:tf
  }
  
  if (is.null(serial_fn)) {
    serial_fn <- function(x) {stats::rnorm(x, mean_si, sd_si)}
  }
  
  t0 <- sample(seq(1, n_length), n, replace = TRUE)  

  ## simulate chains
  sim <- bpmodels::chain_sim(n, "nbinom", serial = serial_fn,
                   mu = R0, size = k, t0 = t0, tf = tf, infinite = max_potential_cases)
  
  ## add reporting delays
  sim$time <- sim$time + delay_sample(length(sim$time))
  sim <- sim[sim$time < tf, ]
  
  ## summarise outbreak size
    size <- data.frame(
      time = kept_times,
      size = unlist(lapply(kept_times, function(x) { 
    tmp <- sim[sim$time < x,] 
    nrow(tmp)}))
    )
  
    return(size)
}
