# bPeaks-application
This is a Web Application developed to facilitate the use of the bPeaks R package. It helps 1) tu run a peak calling analysis with bPeaks and 2) to explore the obtained results.

## Requirements

We use Docker to develop and manage the bPeaks application. We invite you to verify that the following requirements are correctly satisfied before trying to bootstrap the application:

* [Docker 1.12.6+](https://docs.docker.com/engine/installation/)

> We recommend you to follow Docker's official documentations to install
required docker tools (see links above).

**Docker must be on for the duration of bPeaks application use.**

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

Double click on bPeaks-application file and open your internet browser, typing the following url: http://localhost:3838/ and it should work™.

**NOTE** (MAC users) : You may need to repeat the same manipulation as for the installation file (only once).

## Citation
If you use bPeaks application, please cite the bPeaks R package:

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
