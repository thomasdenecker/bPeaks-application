# bPeaks-application
Web application to generate and view bPeaks package results

## Requirements

We use Docker to develop and run bPeaks application. We invite you to ensure you have
installed the following requirements before trying to bootstrap the application:

* [Docker 1.12.6+](https://docs.docker.com/engine/installation/)

> We recommend you to follow Docker's official documentations to install
required docker tools (see links above).

**Docker must be on for the duration of bPeaks application use.**

## Quick start

Have you read the "Requirements" section above?

### bPeaks application project installation

Download the zip file, extract this file and copy it where you want. If you move the folder, the installation procedure will have to be redone.

In this folder, you will find a file called INSTALLATION_MAC_LINUX.sh (for MAC and Linux users) and INSTALLATION_WINDOWS.bat (for Windows users). By double clicking on it, the installation will begin. This may take a little time depending on your internet connection. When the installation was completed, two new files will appear. They allow to launch bPeaks application.

**NOTE** (MAC users)

If you want doucle click in INSTALLATION_MAC_LINUX.sh, you must do a small manipulation (1 time only).
In Finder, right-click INSTALLATION_MAC_LINUX.sh and select "Open with" and then "Other...".

Here you select the application you want the file to execute into, in this case it would be Terminal. To be able to select terminal you need to switch from "Recommended Applications" to "All Applications". (The Terminal.app application can be found in the Utilities folder)

Check "Always Open With" and after clicking OK you should be able to execute you script by simply double-clicking it.

### bPeaks application utilisation

Double click on bPeaks-application file and open your favorite browser with the following url: http://localhost:3838/ and it should work™.

**NOTE** (MAC users) : You may need to repeat the same manipulation as for the installation file (only once).

## Citation
If you use bPeaks application, please cite this tool as:

Merhej J., Frigo A., Le Crom S. Camadro J.‐M. Devaux F. and Lelandais G. (2014),
bPeaks: a bioinformatics tool to detect transcription factor binding sites from ChIPseq data in yeasts and other organisms with small genomes, 
Yeast, 31, pages 375–391, doi: 10.1002/yea.3031

## Contributing

Please, see the [CONTRIBUTING](CONTRIBUTING.md) file.

## Contributor Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](http://contributor-covenant.org/). By participating in this project you
agree to abide by its terms. See [CODE_OF_CONDUCT](CODE_OF_CONDUCT.md) file.

## License

bPeaks application is released under the BSD-3 License. See the bundled [LICENSE](LICENSE)
file for details.
