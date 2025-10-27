#!/bin/bash

# Houston ArcGIS endpoint
json_url="https://mycity2.houstontx.gov/pubgis01/rest/services/HEC/HEC_Active_Incidents/MapServer/0/query?f=json&cacheHint=true&resultOffset=0&resultRecordCount=500&where=1%3D1&orderByFields=CALL_TIME%20DESC&outFields=*&returnGeometry=false&spatialRel=esriSpatialRelIntersects"

# Time Zone
timezone="America/Chicago"

# Perform some quick sanity checks to make sure the temp files that we need exist
echo "Sanity checks and cleaning up..."
echo "" > ./tmp/houstonincidentsdata.json.tmp
echo "" > ./web/index.html
echo "" > ./tmp/poi.dat

# Start pulling data from the ArcGIS server and store it in a temp file
echo "Downloading JSON from ArcGIS..."
curl $json_url -s --compressed -o ./tmp/houstonincidentsdata.json.tmp

# Loop through all of the objects in the JSON file and build a POI marker for each item
# There is a better way to do this, I just threw this together on a Friday afternoon, need to revisit this later
echo "Building POI database..."
jq -c '.features[].attributes' ./tmp/houstonincidentsdata.json.tmp | while read i; do
  poi_agency=$(echo $i | jq '.Agency' | sed 's/\"//g')
  poi_address=$(echo $i | jq '.Address' | sed 's/\"//g')
  poi_crossstreet=$(echo $i | jq '.CrossStreet' | sed 's/\"//g')
  poi_calltime_unix=$(echo $i | jq '.CALL_TIME' | sed 's/\"//g')
  poi_calltime=$(TZ=$timezone date "@$poi_calltime_unix")
  poi_incidenttype=$(echo $i | jq '.IncidentType' | sed 's/\"//g')
  poi_alarmlevel=$(echo $i | jq '.ALARM_LEVEL' | sed 's/\"//g')
  poi_numunits=$(echo $i | jq '.NO_UNITS' | sed 's/\"//g')
  poi_units=$(echo $i | jq '.Units' | sed 's/\"//g')
  poi_lat=$(echo $i | jq '.LATITUDE' | sed 's/\"//g')
  poi_lon=$(echo $i | jq '.LONGITUDE' | sed 's/\"//g')

  echo "var marker = L.marker([$poi_lat, $poi_lon]).addTo(map);" >> ./tmp/poi.dat
  echo "marker.bindPopup("\""Request Type: $poi_agency<br>Address: $poi_address<br>Cross Street: $poi_crossstreet<br>Call Time: $poi_calltime<br>Incident Type: $poi_incidenttype<br>Number of Units: $poi_numunits<br>Units: $poi_units"\"");" >> ./tmp/poi.dat
done

# Concatonate our static header, POI index, and static footer to build the index.html document
echo "Building index.html..."
cat ./static/header.dat | sed "s/poots/$(TZ=$timezone date -Iminutes)/" >> ./web/index.html
cat ./tmp/poi.dat >> ./web/index.html
cat ./static/footer.dat >> ./web/index.html

# Cleanup section where we zero out our temp files, but we leave the built index.html
echo "Cleaning up..."
echo "" > ./tmp/poi.dat
echo "" > ./tmp/houstonincidentsdata.json.tmp
