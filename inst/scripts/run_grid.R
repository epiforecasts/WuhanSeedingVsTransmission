# Set up parallisation
future::plan(future::multiprocess)

# Run grid
grid_results <- WuhanSeedingVsTransmission::run_scenario_grid(
                                  end_date = "2020-01-25", 
                                  samples = 1000, 
                                  upper_case_bound = 4000, 
                                  show_progress = TRUE)



fst::write.fst(grid_results, "inst/results/grid.fst", 100)