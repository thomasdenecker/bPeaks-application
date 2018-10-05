# bPeaks-application

[![Build Status](https://travis-ci.org/thomasdenecker/bPeaks-application.svg?branch=master)](https://travis-ci.org/thomasdenecker/bPeaks-application)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1324933.svg)](https://doi.org/10.5281/zenodo.1324933)

This is a Web Application developed to facilitate the use of the bPeaks R package. It helps 1) tu run a peak calling analysis with bPeaks and 2) to explore the obtained results. bPeaks application web site is available [here](https://thomasdenecker.github.io/bPeaks-application/)

## Requirements

We use Docker to develop and manage the bPeaks application. We invite you to verify that the following requirements are correctly satisfied before trying to bootstrap the application:

* [Docker 1.12.6+](https://docs.docker.com/engine/installation/)

> We recommend you to follow Docker's official documentations to install
required docker tools (see links above).To help you, explanatory videos for each operating system are available [here](https://www.bretfisher.com/installdocker/)

To increase the docker memory set to 2GB by default :
- [Windows](https://docs.docker.com/docker-for-windows/#advanced)
- [MacOS](https://docs.docker.com/docker-for-mac/#memory)
- [Linux](https://docs.docker.com/config/containers/resource_constraints/)

**Docker must be on for the duration of bPeaks application use.**


**Important** 

Note that the size of the RAM that should be allocated to the Docker depends on the size of the studied organism genome. For example, the case study presented here requires 3GB of RAM, as the studied genome is the one of the yeast S. cerevisiae (12 Mb). A workstation or a laboratory server with 16GB of RAM is therefore well dimensioned. To increase the allocated memory, go here for [mac](https://docs.docker.com/docker-for-mac/#memory), for [windows](https://docs.docker.com/docker-for-windows/#advanced) and for [linux](https://docs.docker.com/config/containers/resource_constraints/#limit-a-containers-access-to-memory)

## Quick start

Did you read the "Requirements" section above?

### bPeaks application project installation

Download the zip file, extract this file and copy the obtained folder where you want on your computer. Note that if you move the folder, the installation procedure will have to be redone.

In this folder, you will find a file named INSTALLATION_MAC_LINUX.sh (for MAC and Linux users) and INSTALLATION_WINDOWS.bat (for Windows users). By double clicking on it, the installation will begin. This may take a little time depending on the quality of your internet connection. When the installation will be completed, two new files will appear. They allow to launch the bPeaks application.

**NOTE** (MAC users)

You can also doucle click the file INSTALLATION_MAC_LINUX.sh. In this situation a small manipulation is required (1 time only).
In your Finder, right-click the file INSTALLATION_MAC_LINUX.sh and select "Open with" and then "Other...".

Here you can select the application you want the file to be execute with. In this case it should be the Terminal. To be able to select the Terminal, you have to switch from "Recommended Applications" to "All Applications"  (the Terminal.app application can be found in the Utilities folder).

Check "Always Open With" and after clicking OK you should be able to execute you SHELL script by simply double-clicking it.

### bPeaks application utilisation

Double click on bPeaks-application file and open your internet browser, typing the following url: http://localhost:3838/ and it should work™. Default user is admin with password : admin. We recommend you to change this password the first time you use it.

**NOTE** (MAC users) : You may need to repeat the same manipulation as for the installation file (only once).

## Development

### Launch in debug mode

During development, you will probably need to have the R outputs in the terminal. Passing through a docker, to have these outputs, you have to access the log file. The following command launches the application and has a log file that will be in the application folder. To help you in the choice of path of the application, you can look in the launch of the application.

```
docker run -ti --rm --link bPeaksDB:postgres -p 3839:3838 -v YOUR_APPLICATION_PATH:/srv/shiny-server -v YOUR_APPLICATION_PATH:/var/log/shiny-server tdenecker/bpeaks_docker
```

### Connect to database with command line:  
```
docker run -it --rm --link bPeaksDB:postgres postgres psql -h postgres -U docker
```
The default password is docker. If you change this password, remember to make the change in the application code.

### Connect to a R session

```
docker run -ti --rm --link bPeaksDB:postgres -p 3839:3838 -v YOUR_APPLICATION_PATH:/srv/shiny-server tdenecker/bpeaks_docker R
```

**Warning**: nothing is saved in this session (package installation, ...)


## Citation
If you use bPeaks application, please cite the bPeaks R package:

Merhej J., Frigo A., Le Crom S. Camadro J.‐M. Devaux F. and Lelandais G. (2014),
bPeaks: a bioinformatics tool to detect transcription factor binding sites from ChIPseq data in yeasts and other organisms with small genomes,
Yeast, 31, pages 375–391, doi: 10.1002/yea.3031

Thomas Denecker and Gaëlle Lelandais (2018)
Empowering the detection of ChIP-seq “basic peaks” (bPeaks) in small eukaryotic genomes with a web user-interactive interface
BMC Research Notes201811:698
https://doi.org/10.1186/s13104-018-3802-y

## Contributing

Please, see the [CONTRIBUTING](CONTRIBUTING.md) file.

## Contributor Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](http://contributor-covenant.org/). By participating in this project you
agree to abide by its terms. See [CODE_OF_CONDUCT](CODE_OF_CONDUCT.md) file.

## License

bPeaks application is released under the BSD-3 License. See the bundled [LICENSE](LICENSE)
file for details.
