#!/bin/bash

docker pull tdenecker/bpeaks_docker

BASEDIR=$(dirname "$0")
echo "$BASEDIR"

echo '#!/bin/bash' > $BASEDIR/bPeaks_application.sh
echo 'docker stop $(docker ps -a -q)' >> $BASEDIR/bPeaks_application.sh
echo 'docker run --rm -p 3838:3838 -v' $BASEDIR':/srv/shiny-server tdenecker/bpeaks_docker' >> $BASEDIR/bPeaks_application.sh

chmod +x $BASEDIR/START-R_analyzer.sh
chmod +x $BASEDIR/START-R_viewer.sh
