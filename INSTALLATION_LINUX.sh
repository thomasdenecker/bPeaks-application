#!/bin/bash

BASEDIR=$(pwd)
echo "$BASEDIR"

docker pull tdenecker/bpeaks_docker
docker pull tdenecker/bpeaks_db
docker run --name bPeaksDB -d tdenecker/bpeaks_db
docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" bPeaksDB > $BASEDIR/Database/ipDB.txt

echo '#!/bin/bash' > $BASEDIR/bPeaks_application.sh
echo docker stop bPeaksDB >> $BASEDIR/bPeaks_application.sh
echo docker start bPeaksDB >> $BASEDIR/bPeaks_application.sh
echo 'docker run --rm --link bPeaksDB:postgres -p 3838:3838 -v' $BASEDIR':/srv/shiny-server tdenecker/bpeaks_docker' >> $BASEDIR/bPeaks_application.sh

chmod +x $BASEDIR/bPeaks_application.sh
