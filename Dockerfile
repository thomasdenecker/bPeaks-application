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

RUN wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN tar jxvf phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN ln -s $PWD/phantomjs-2.1.1-linux-x86_64.tar.bz2/ $PWD/phantomjs
RUN ln -s $PWD/phantomjs/bin/phantomjs /bin/phantomjs
RUN mv phantomjs-2.1.1-linux-x86_64/bin/phantomjs /bin/

## install packages from CRAN (and clean up)

RUN Rscript -e "install.packages(installed.packages()[,'Package'])"
RUN Rscript -e "install.packages(c('shiny','shinyjs','shinyFiles','evobiR','plotly','ape', 'bPeaks', 'RPostgreSQL', 'rJava', 'mailR', 'shinyalert', 'googleVis', 'shinytest', 'packrat'), repos='https://cran.rstudio.com/', dependencies = TRUE)" \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds


## install packages from github (and clean up)
RUN Rscript -e "devtools::install_github('rstudio/shinytest','rstudio/webdriver')" \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

## install phantomjs
RUN Rscript -e "webdriver::install_phantomjs()"


RUN Rscript -e "install.packages('testthat', repos='https://cran.rstudio.com/', dependencies = TRUE)" \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds
