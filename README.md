# Houston Incidents

[![Scrape, build, and deploy](https://github.com/c360e5f1/houstonincidents.com/actions/workflows/main.yaml/badge.svg)](https://github.com/c360e5f1/houstonincidents.com/actions/workflows/main.yaml)

Web page for incidents involving Houston Fire and Houston Police. Works on mobile and desktop. ~~Includes manifest as a progressive web app.~~

```main.sh``` runs as a bash script to pull JSON data from the Houston ArcGIS server. The JSON data is then parsed for relevant information, like the latitude/longitude, incident information, response type, etc, and plots it on a basic HTML page using OpenStreetMaps and Leaflet.

You can run this locally and use ```./web/index.html``` as the web page, or run it as a GitHub Workflow that exports to GitHub Pages. If run as a GitHub workflow, the cron can be configured to run every five minutes, but [due to instance queueing](https://upptime.js.org/blog/2021/01/22/github-actions-schedule-not-working/) realistically will only run a few times an hour. The source ArcGIS instance only updates at five minute intervals.

Live demo at https://houstonincidents.com

This project uses several external scripts and resources:
* https://www.openstreetmap.org/
* https://leafletjs.com/

This project was inspired by the following projects:
* https://github.com/adolph/getIncidentsGit
* https://github.com/d-m-wilson/HoustonIncidents
* https://www.arcgis.com/apps/dashboards/c51f262fdf8d43b39b6770d1b3d6aa53
* https://mycity.maps.arcgis.com/apps/instant/basic/index.html?appid=820ec3acdbcb41d29fc2a7d4062c0820

***

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
