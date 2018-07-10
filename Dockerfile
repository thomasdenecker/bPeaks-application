FROM rocker/shiny
MAINTAINER Thomas DENECKER (thomas.denecker@gmail.com)

## install R package dependencies (and clean up)
RUN apt-get update && apt-get install -y gnupg2 \
    libssl-dev \
    libpq-dev \
    default-jre \
    r-cran-rjava \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/ \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

## install packages from CRAN (and clean up)

RUN Rscript -e "install.packages(installed.packages()[,'Package'])"
RUN Rscript -e "install.packages(c('shiny','shinyjs','shinyFiles','evobiR','plotly','ape', 'bPeaks', 'RPostgreSQL', 'rJava', 'mailR', 'shinyalert', 'googleVis'), repos='https://cran.rstudio.com/', dependencies = TRUE)" \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds
