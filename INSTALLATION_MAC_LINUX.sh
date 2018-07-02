#!/bin/bash

docker pull tdenecker/bpeaks_docker
docker pull tdenecker/bpeaks_db
docker run --name bPeaksDB -d tdenecker/bpeaks_db
docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" bPeaksDB > Database/ipDB.txt

BASEDIR=$(dirname "$0")
echo "$BASEDIR"

echo '#!/bin/bash' > $BASEDIR/bPeaks_application.sh
echo 'docker stop $(docker ps -a -q)' >> $BASEDIR/bPeaks_application.sh
echo docker start bPeaksDB >> bPeaks_application.bat
echo 'docker run --rm --link bPeaksDB:postgres -p 3838:3838 -v' $BASEDIR':/srv/shiny-server tdenecker/bpeaks_docker' >> $BASEDIR/bPeaks_application.sh

chmod +x $BASEDIR/bPeaks_application.sh
