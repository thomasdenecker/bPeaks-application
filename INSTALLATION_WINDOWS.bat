docker pull tdenecker/bpeaks_db
docker run --name bPeaksDB -d tdenecker/bpeaks_db
docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" bPeaksDB > Database/ipDB.txt

docker pull tdenecker/bpeaks_docker
echo docker stop bPeaksDB > bPeaks_application.bat
echo docker start bPeaksDB >> bPeaks_application.bat
echo docker run --rm --link bPeaksDB:postgres -p 3838:3838 -v %CD%:/srv/shiny-server tdenecker/bpeaks_docker >> bPeaks_application.bat
