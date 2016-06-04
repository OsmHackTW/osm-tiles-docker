FROM osmtw/modtile:v3.0.9
MAINTAINER Rex Tsai <rex.cc.tsai@gmail.com>

RUN apt-get update \
 && apt-get dist-upgrade -y

# Install the Mapnik stylesheet and the coastline data
RUN apt-get install -y subversion unzip wget \
 && svn co http://svn.openstreetmap.org/applications/rendering/mapnik /usr/local/src/mapnik-style \
 && bash -e /usr/local/src/mapnik-style/get-coastlines.sh /usr/local/share \
 && cd -

## Configure mapnik style-sheets
ADD settings.sed /tmp/
ADD fontset-settings.xml.inc /usr/local/src/mapnik-style/inc/fontset-settings.xml.inc
ADD datasource-settings.sh /usr/local/bin/datasource-settings.sh
RUN cd /usr/local/src/mapnik-style/inc \
 && sed --file /tmp/settings.sed  settings.xml.inc.template > settings.xml.inc \
 && chmod 755 /usr/local/bin/datasource-settings.sh \
 && chown -R www-data /usr/local/src/mapnik-style/inc \
 && cd -

# Install openstreetmap-carto
ENV OSM_CARTO_VERSION=v2.39.0
RUN git clone --depth 1 --branch ${OSM_CARTO_VERSION} https://github.com/gravitystorm/openstreetmap-carto.git /usr/local/src/openstreetmap-carto \
 && cd /usr/local/src/openstreetmap-carto \
 && ./get-shapefiles.sh \
 && cd -

# Install osm-bright
ENV OSM_BRIGHT_VERSION=master
RUN git clone --depth 1 --branch ${OSM_BRIGHT_VERSION} https://github.com/mapbox/osm-bright.git /usr/local/src/osm-bright \
 && sed -e s%unifont%Unifont% -i /usr/local/src/osm-bright/osm-bright/palette.mss \
 && ln -s /usr/local/src/openstreetmap-carto/data /usr/local/src/osm-bright/shp
RUN chown -R www-data.www-data /usr/local/src/

# Setup web pages
RUN rm -rf /var/www/html
ADD leafletjs-localmap /var/www/html

# Configure renderd
ADD renderd.conf /usr/local/etc/renderd.conf
RUN install --owner=www-data --group=www-data -d /var/run/renderd

# Setup supervisord
ENV SUPERVISOR_VERSION=3.2.0-2
ADD supervisord.conf /etc/supervisord.conf
RUN apt-get install -y supervisor=${SUPERVISOR_VERSION}

# Clean up APT when done
RUN apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80
CMD ["/usr/bin/supervisord", "--nodaemon", "--configuration=/etc/supervisord.conf"]
