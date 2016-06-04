# OpenStreetMap Tiles

Docker compose config incldues the following software stack for OpenStreetMap

- postgis, database to store OpenStreetMap data.
_ osm2pgsql, Convert OSM planet snapshot data to SQL suitable for loading
 into a PostgreSQL database with PostGIS geospatial extensions.
- mod_tile
    - mapnik
    - Cascadenik
    - mod_tile + renderd
    - carto & millstone

# Frontend server
The docker instances will build and servie tile based on the following stylesheets.
- Mapnik stylesheet http://svn.openstreetmap.org/applications/rendering/mapnik
- openstreetmap-carto https://github.com/gravitystorm/openstreetmap-carto.git
- osm-bright https://github.com/mapbox/osm-bright.git
- leafletjs frontend

# Usage

Start the server
```
$ docker-compose up
```

If this is your first time launch the instances, the renderd would not be ready before the osm data been imported into postgis. You need restart apache and renderd after the postgis is done.
```
$ docker exec -t -i osmtiles_web_1 supervisorctl restart renderd apache2
```

Once the database is inited, it will be saved in volume, and you don't need to restart the services manually.

After the server is ready, launch a browser to [localhost:8080](http://localhost:8080). You should able to switch to differnet style from the leaflet map controller.
