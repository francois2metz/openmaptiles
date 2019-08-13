#!/bin/bash

AREA=montrouge
DOCKER_COMPOSE_FILE=data/docker-compose-config.yml
BBOX=2.293611,48.807344,2.336998,48.825486

echo "http://www.overpass-api.de/api/xapi_meta?*\[bbox=${BBOX}\]"

curl "http://www.overpass-api.de/api/xapi_meta?*\[bbox=${BBOX}\]" > data/${AREA}.osm
curl http://m.m.i24.cc/osmconvert64 -o osmconvert
chmod +x osmconvert

./osmconvert --out-pbf data/${AREA}.osm > data/${AREA}.osm.pbf
./osmconvert --out-statistics data/${AREA}.osm.pbf > data/osmstat.txt

lon_min=$( cat data/osmstat.txt | grep "lon min:" |cut -d":" -f 2 )
lon_max=$( cat data/osmstat.txt | grep "lon max:" |cut -d":" -f 2 )
lat_min=$( cat data/osmstat.txt | grep "lat min:" |cut -d":" -f 2 )
lat_max=$( cat data/osmstat.txt | grep "lat max:" |cut -d":" -f 2 )
timestamp_max=$( cat data/osmstat.txt | grep "timestamp max:" |cut -d" " -f 3 )

echo "--------------------------------------------"
echo BBOX: "$lon_min,$lat_min,$lon_max,$lat_max"
echo TIMESTAMP MAX = $timestamp_max
echo "--------------------------------------------"

cat > $DOCKER_COMPOSE_FILE  <<- EOM
version: "2"
services:
  generate-vectortiles:
    environment:
      BBOX: "$lon_min,$lat_min,$lon_max,$lat_max"
      OSM_MAX_TIMESTAMP : "$timestamp_max"
      OSM_AREA_NAME: "$AREA"
      MIN_ZOOM: "14"
      MAX_ZOOM: "17"
EOM
