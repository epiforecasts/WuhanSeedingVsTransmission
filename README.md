# Evaluating the transmissibility of the coronavirus virus in the 2019-20 Wuhan Outbreak: Exploring initial animal-to-human event sizes and durations using scenario analysis

## Abstract

### Background

### Methods

### Results


## Usage

### Set up

 your working directory to the home directory of this project (or use the provided Rstudio project).

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