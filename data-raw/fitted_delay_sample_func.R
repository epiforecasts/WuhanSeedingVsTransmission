## code to fit the delay_sampl_func goes here
## Requires a working install of WuhanSeedingVsTransmission
require(WuhanSeedingVsTransmission)


## Default reporting delay
delay_mean <- 6.17
## Default standard deviation of the reporting delay
delay_sd <- 2


## Try getting empirical reporting distribution from Google Sheet, otherwise
## use default value 
fitted_delay_sample_func <-
  tryCatch(WuhanSeedingVsTransmission::get_rep_sample_fun(),
           error = function(e) {
             warning("Could not get Google Sheet; ",
                     "will use default reporting values" )
             function(n) rnorm(n, mean = 6.17, sd = 2)
           })


usethis::use_data(fitted_delay_sample_func, overwrite = TRUE)
