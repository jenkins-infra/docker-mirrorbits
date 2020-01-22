FROM ubuntu:latest AS geoip

ARG GEOIP_ID
ARG GEOIP_KEY

RUN \
  apt-get update && \
  apt-get install -y geoipupdate && \
  apt-get clean && \
  find /var/lib/apt/lists -type f -delete

COPY config/GeoIP.conf /etc/GeoIP.conf

RUN \
  sed -i "s/__ACCOUNTID__/$GEOIP_ID/" /etc/GeoIP.conf && \
  sed -i "s/__LICENSEKEY__/$GEOIP_KEY/" /etc/GeoIP.conf

RUN geoipupdate

####
FROM ubuntu:latest AS mirrorbits

ARG VERSION

ENV MIRRORBIT_VERSION $VERSION

RUN \
  apt-get update && \
  apt-get install -y tar curl && \
  apt-get clean && \
  find /var/lib/apt/lists -type f -delete

# Download Binary
RUN \
  mkdir /mirrorbits && \
  curl -L https://github.com/etix/mirrorbits/releases/download/${MIRRORBIT_VERSION}/mirrorbits-${MIRRORBIT_VERSION}.tar.gz -O && \
  tar xvzf /mirrorbits-${MIRRORBIT_VERSION}.tar.gz -C / && \
  rm /mirrorbits-${MIRRORBIT_VERSION}.tar.gz

######

FROM ubuntu:latest

EXPOSE 8080

ARG VERSION

ENV MIRRORBIT_VERSION $VERSION
LABEL maintainer="https://github.com/olblak"
LABEL mirrorbit_version=$VERSION
LABEL repository="https://github.com/olblak/mirrorbits"

RUN \
  useradd -M mirrorbits && \
  mkdir /etc/mirrorbits  && \
  mkdir /usr/share/mirrorbits/ && \
  mkdir /srv/repo && \
  mkdir /run/mirrorbits && \
  mkdir /var/log/mirrorbits && \
  chown mirrorbits -R /usr/share/mirrorbits/ && \
  chown mirrorbits /run/mirrorbits && \
  chown mirrorbits /var/log/mirrorbits && \
  chown mirrorbits /srv/repo

USER mirrorbits

COPY --from=geoip /var/lib/GeoIP/ /usr/share/GeoIP/

COPY config/mirrorbits.conf /etc/mirrorbits/mirrorbits.conf

COPY --from=mirrorbits  /mirrorbits/mirrorbits /usr/bin/mirrorbits
COPY --from=mirrorbits  /mirrorbits/templates /usr/share/mirrorbits/templates

ENTRYPOINT /usr/bin/mirrorbits daemon --config /etc/mirrorbits/mirrorbits.conf 
