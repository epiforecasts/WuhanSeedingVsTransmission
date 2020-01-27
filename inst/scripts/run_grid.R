# Set up parallisation
future::plan(future::multiprocess)


# Run grid
message("Running scenario grid")

grid_results <- WuhanSeedingVsTransmission::run_scenario_grid(
                                  end_date = "2020-01-25", 
                                  samples = 10000, 
                                  upper_case_bound = round(1975*1.05, 0), 
                                  show_progress = TRUE)


## Save raw grid
message("Saving complete grid")

fst::write.fst(grid_results, "inst/results/grid.fst")


## Filter by known cases on the 25th of January - bounded by potential cases
message("Conditioning on data from the 25th of January")
jan25_conditioned <- WuhanSeedingVsTransmission::condition_and_report_on_cases(
  grid_results, 
  condition_date = "2020-01-25",
  samples =  max(grid_results$sample),
  lower_bound = 1975*0.95, 
  upper_bound = 1975*1.05)


## Save results
message("Saving results")

fst::write.fst(jan25_conditioned$proportion_allowed_sims, 
               "inst/results/proportion_sims_allowed.fst", 100)

fst::write.fst(jan25_conditioned$conditioned_sims, 
               "inst/results/conditioned_grid.fst", 100)