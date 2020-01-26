#' Negative binomial branching process model
#'
#' @param n Numeric, number of initial cases
#' @param n_length Numeric, the number of days in the initial seeding event
#' @param mean_si Numeric, the mean of the serial interval
#' @param sd_si Numeric, the sd of the serial interval
#' @param R0 Numeric, the estimated reproduction number
#' @param k Numeric, the dispersion of the negative binomial branching process
#' @param tf Numeric, the end time of the branching process
#' @param max_potential_cases Numeric, the maximum number of cases
#' @param delay_sample A function to sample from reporting delays
#'
#' @return
#' @export
#' @importFrom bpmodels chain_sim
#' @author Sebastian Funk, Sam Abbott, James Munday
#' @examples
#' 
#' 
run_sim  = function(n, n_length, mean_si, sd_si, R0, 
                    k=0.16, tf=37, max_potential_cases,
                    delay_sample) {
  
  t0 <- sample(seq(1, n_length), n, replace = TRUE)  

  ## simulate chains
  sim <- bpmodels::chain_sim(n, "nbinom", serial = function(x) rnorm(x, mean_si, sd_si),
                   mu = R0, size = k, t0 = t0, tf = tf, infinite = max_potential_cases)
  
  ## add reporting delays
  sim$time <- sim$time + delay_sample(length(sim$time))
  sim <- sim[sim$time < tf, ]
  
  ## summarise outbreak size
    size <- data.frame(
      time = 0:tf,
      size = unlist(lapply(0:tf, function(x) { 
    tmp <- sim[sim$time < x,] 
    nrow(tmp)}))
    )
  
    return(size)
}
