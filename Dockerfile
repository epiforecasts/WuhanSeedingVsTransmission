
## Start with the latest tidyvere image - once development is complete
## needs to be version locked with tags
FROM rocker/tidyverse:latest

## Copy files to working directory of server
ADD . /home/rstudio/WuhanSeedingVsTransmission

## Set working directory to be this folder
WORKDIR /home/rstudio/WuhanSeedingVsTransmission

## Install missing packages - using pacman.
RUN Rscript -e "devtools::install_dev_deps()"

## Install latex using tinytex
RUN Rscript -e "tinytex::install_latex()"