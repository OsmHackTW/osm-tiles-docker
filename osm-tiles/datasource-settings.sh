#!/bin/sh

# mapnik-style
sed -e "s/%(password)s/${PG_ENV_POSTGRES_PASSWORD}/" \
    -e "s/%(host)s/${PG_PORT_5432_TCP_ADDR}/" \
    -e "s/%(port)s/${PG_PORT_5432_TCP_PORT}/" \
    -e "s/%(user)s/${PG_ENV_POSTGRES_USER}/" \
    -e "s/%(dbname)s/${PG_ENV_POSTGRES_DB}/" \
    -e "s/%(estimate_extent)s/false/" \
    -e "s/%(extent)s/-20037508,-19929239,20037508,19929239/" \
    /usr/local/src/mapnik-style/inc/datasource-settings.xml.inc.template > /usr/local/src/mapnik-style/inc/datasource-settings.xml.inc

# osm-carto setup
cd /usr/local/src/openstreetmap-carto/
git checkout -- project.mml
sed -i "s/\"dbname\": \"gis\"/\"host\": \"$PG_PORT_5432_TCP_ADDR\",\n \
    \"port\": \"$PG_PORT_5432_TCP_PORT\",\n \
    \"user\": \"$PG_ENV_POSTGRES_USER\",\n \
    \"password\": \"$PG_ENV_POSTGRES_PASSWORD\",\n \
    \"dbname\":\"$PG_ENV_POSTGRES_DB\"/" project.mml
carto project.mml > style.xml

# osm-bright setup
cd /usr/local/src/osm-bright
cp configure.py.sample configure.py
sed -i -e "s|^config\[\"path\"\].*|config\[\"path\"\] = \"$(pwd)\"|" \
       -e "s/^config\[\"postgis\"\]\[\"host\"\].*/config\[\"postgis\"\]\[\"host\"\] = \"$PG_PORT_5432_TCP_ADDR\"/" \
       -e "s/^config\[\"postgis\"\]\[\"port\"\].*/config\[\"postgis\"\]\[\"port\"\] = \"$PG_PORT_5432_TCP_PORT\"/" \
       -e "s/^config\[\"postgis\"\]\[\"dbname\"\].*/config\[\"postgis\"\]\[\"dbname\"\] = \"$PG_ENV_POSTGRES_DB\"/" \
       -e "s/^config\[\"postgis\"\]\[\"user\"\].*/config\[\"postgis\"\]\[\"user\"\] = \"$PG_ENV_POSTGRES_USER\"/" \
       -e "s/^config\[\"postgis\"\]\[\"password\"\].*/config\[\"postgis\"\]\[\"password\"\] = \"$PG_ENV_POSTGRES_PASSWORD\"/" \
       configure.py
./make.py
cd OSMBright
millstone project.mml > project.local.mml
carto project.local.mml > style.xml
