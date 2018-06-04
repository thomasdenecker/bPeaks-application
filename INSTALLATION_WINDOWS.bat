docker pull tdenecker/bpeaks_docker

echo FOR /F "tokens=*" %%%%g IN ('docker ps -a -q') do (docker stop %%%%g) > bPeaks_application.bat
echo docker run --rm -p 3838:3838 -v %CD%:/srv/shiny-server tdenecker/bpeaks_docker >> bPeaks_application.bat

a
