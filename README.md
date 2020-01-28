# Evaluating the transmissibility of the coronavirus in the 2019-20 Wuhan Outbreak: Exploring initial point-source exposure sizes and durations using scenario analysis

## Abstract

### Background

The current coronavirus outbreak appears to have originated from a point-source exposure event at Huanan seafood wholesale market in Wuhan, China. There is still uncertainty around the scale and duration of this exposure event. This has implications for the likely transmissibility of the coronavirus and as such, these potential scenarios should be explored. 

### Methods

We used a stochastic branching process model - parameterised with available data where possible and otherwise informed by the 2002-2003 SARS outbreak - to simulate the Wuhan outbreak. We evaluated scenarios for the following parameters: the size, and duration of the initial transmission event, the serial interval, and the reproduction number (R0). We restricted model simulations based on the number of observed cases on the 25th of January, accepting samples that were within a 5% interval on either side of this estimate. Our analysis is available as an open-source tool in the form of an R package.

### Results

The most likely scenarios were those with a large transmission event and a short duration. Using a longer serial interval than estimated for SARs suggested a longer initial transmission event and a higher R0 estimate. Using a SARs like serial interval we found that the most likely scenario produced an R0 estimate of 2.4 (1.6 - 3.9). There were other plausible scenarios with smaller events sizes of longer duration that increased, and decreased respectively, the R0 estimates. Using a longer serial interval we found that the R0 estimate increased by approximately 1 across all scenarios considered. There were very few simulations that were able to reproduce the observed data when R0 was less than 1. 

### Conclusions

Our results indicate that an R0 of less than 1 was highly unlikely unless the size of the animal-to-human transmission event was much greater than currently reported. We found that a large initial crossover event was likely with a relatively short duration. Scenarios with a longer serial interval resulted in a higher R0 and were equally plausible to scenarios with SARs like serial intervals. Our work to make this analysis available as an open-source tool may be helpful to public health officials and other researchers.

## Usage

### Set up

Set your working directory to the home directory of this project (or use the provided Rstudio project).

Install the analysis and all dependencies with: 

```r
remotes::install_github("epiforecasts/WuhanSeedingVsTransmission", dependencies = TRUE)
```

### Run analysis

Run the analysis with the following:

```bash
Rscript inst/scripts/run_grid.R
```


### Inspect results

Use `vignettes/output.Rmd.orig` to inspect the results of the analysis interactively.

### Render output

Render the output to all formats with the following:

```bash
Rscript inst/scripts/render_output.R
```

### Update the fitted reporting delay function

In order to refit the reporting delay from linelist date on cases in China use the following:

```bash
Rscript data-raw/fitted_delay_sample_func.R
```

It is then neccessary to either rebuild the package or pass the updated function to `run_scenario_grid` explicitly. In normal usage this should not be neccessary for users of this analysis.

## Docker


This analysis was developed in a docker container based on the tidyverse docker image. 

To build the docker image run (from the `WuhanSeedingVsTransmission` directory):

```bash
docker build . -t wuhansvst
```

To run the docker image run:

```bash
docker run -d -p 8787:8787 --name wuhansvst -e USER=wuhansvst -e PASSWORD=wuhansvst wuhansvst
```

The rstudio client can be found on port :8787 at your local machines ip. The default username:password is wuhansvst:wuhansvst, set the user with -e USER=username, and the password with - e PASSWORD=newpasswordhere. The default is to save the analysis files into the user directory.

To mount a folder (from your current working directory - here assumed to be `tmp`) in the docker container to your local system use the following in the above docker run command (as given mounts the whole `wuhansvst` directory to `tmp`).

```{bash, eval = FALSE}
--mount type=bind,source=$(pwd)/tmp,target=/home/wuhansvst
```

To access the command line run the following:

```{bash, eval = FALSE}
docker exec -ti wuhansvst bash
```