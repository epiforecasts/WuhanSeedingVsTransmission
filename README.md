# Wuhan: Seeding vs transmission

**Aim:** Can we rule out transmission scenarios and give thresholds for other potential scenarios?

## Scenarios

1. Massive point source with very low human to human transmission (low R0).
2. Smaller point source with ongoing human -> human transmission (higher R0).

## Explore

* Look at transmission and point source scenarios to see what the probability is that R0 is greater than 1.
* Need multiple scenarios to check with generation time (could look at short and long (SARS ~ 8.7 days))
* Scenarios around how long the point source lasted (gene sequences indicate the 16th of December as the point estimate).

## Usage

### Set up

* Set your working directory to the home directory of this project (or use the provided Rstudio project).

* Install the analysis and all dependencies with: 

```r
remotes::install_github("epiforecasts/WuhanSeedingVsTransmission", dependencies = TRUE)
```

### Run analysis

* Run the analysis with the following:

```bash
Rscript inst/scripts/run_grid.R
```


### Inspect results

* Use `vignettes/output.Rmd.orig` to inspect the results of the analysis interactively.


### Render output

* Render the output to all formats with the following:

```bash
Rscript inst/scripts/render_output.R
```

## Docker


This analysis was developed in a docker container based on the tidyverse docker image. 

To build the docker image run (from the `WuhanSeedingVsTransmission` directory):

```bash
docker build . -t WuhanSeedingVsTransmission
```

To run the docker image run:

```bash
docker run -d -p 8787:8787 --name WuhanSeedingVsTransmission -e USER=WuhanSeedingVsTransmission -e PASSWORD=WuhanSeedingVsTransmission WuhanSeedingVsTransmission
```

The rstudio client can be found on port :8787 at your local machines ip. The default username:password is WuhanSeedingVsTransmission:WuhanSeedingVsTransmission, set the user with -e USER=username, and the password with - e PASSWORD=newpasswordhere. The default is to save the analysis files into the user directory.

To mount a folder (from your current working directory - here assumed to be `tmp`) in the docker container to your local system use the following in the above docker run command (as given mounts the whole `WuhanSeedingVsTransmission` directory to `tmp`).

```{bash, eval = FALSE}
--mount type=bind,source=$(pwd)/tmp,target=/home/WuhanSeedingVsTransmission
```

To access the command line run the following:

```{bash, eval = FALSE}
docker exec -ti WuhanSeedingVsTransmission bash
```