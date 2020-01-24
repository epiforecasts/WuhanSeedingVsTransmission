run_ncov_sim  = function(n, n_length, mean_si, sd_si, R0, k=0.16, tf=37, max_potential_cases){ 
  
  t0 <- sample(seq(1, n_length), n, replace = TRUE)  

  ## simulate chains
  sim <- chain_sim(n, "nbinom", serial = function(x) rnorm(x, mean_si, sd_si),
                   mu = R0, size = k, t0 = t0, tf = tf, infinite = max_potential_cases)
  
  ## add reporting delays
  times <- sim$time + 6.17 ## should use empirical distribution from linelist via the virological ink
  times <- times[times < tf]
  
  ## outbreak size
  size <- length(times)
  
  size
}
