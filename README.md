# OpenStreetMap Tiles

Docker images incldues the following software stack for OpenStreetMap

- postgis, database to store OpenStreetMap data.
_ osm2pgsql, Convert OSM planet snapshot data to SQL suitable for loading
 into a PostgreSQL database with PostGIS geospatial extensions.
- mod_tile
    - mapnik
    - Cascadenik
    - mod_tile + renderd
    - carto & millstone
    - Mapnik stylesheet http://svn.openstreetmap.org/applications/rendering/mapnik
    - openstreetmap-carto https://github.com/gravitystorm/openstreetmap-carto.git
    - osm-bright https://github.com/mapbox/osm-bright.git
    - leafletjs frontend
