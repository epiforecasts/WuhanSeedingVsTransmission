FROM rocker/binder:latest

USER root
COPY . ${HOME}
RUN chown -R ${NB_USER} ${HOME}

## Become normal user again
USER ${NB_USER}

RUN R -e "install.packages('remotes')"

RUN R -e "remotes::install_github('epiforecasts/WuhanSeedingVsTransmission', dependencies = TRUE)"