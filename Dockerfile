FROM debian:stable-slim AS mirrorbits

## (DL3008)Ignore lint error about apt pinned packages, as we always want the latest version of these tools
## and the risk of a breaking behavior is evaluated as low
# hadolint ignore=DL3008
RUN apt-get update && \
  apt-get install --no-install-recommends -y tar curl ca-certificates && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG mirrorbits_version=v0.5.1
RUN mkdir /mirrorbits && \
  curl -L https://github.com/etix/mirrorbits/releases/download/${mirrorbits_version}/mirrorbits-${mirrorbits_version}.tar.gz -O && \
  tar xvzf /mirrorbits-${mirrorbits_version}.tar.gz -C /

ARG tini_version=v0.19.0
RUN curl --silent --show-error --output /mirrorbits/tini --location \
  "https://github.com/krallin/tini/releases/download/${tini_version}/tini-$(dpkg --print-architecture)" && \
  chmod +x /mirrorbits/tini

FROM debian:stable-slim

EXPOSE 8080

ARG tini_version=v0.19.0
ARG mirrorbits_version=v0.5.1

LABEL repository="https://github.com/olblak/mirrorbits"

## (DL3008)Ignore lint error about apt pinned packages, as we always want the latest version of these tools
## and the risk of a breaking behavior is evaluated as low
# hadolint ignore=DL3008
RUN apt-get update && \
  apt-get install --no-install-recommends -y ftp rsync ca-certificates vim-tiny && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN useradd -M mirrorbits && \
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

COPY config/mirrorbits.conf /etc/mirrorbits/mirrorbits.conf

COPY --from=mirrorbits /mirrorbits/tini /bin/tini

COPY --from=mirrorbits /mirrorbits/mirrorbits /usr/bin/mirrorbits

COPY --from=mirrorbits /mirrorbits/templates /usr/share/mirrorbits/templates

LABEL io.jenkins-infra.tools="mirrorbits,tini"
LABEL io.jenkins-infra.tools.mirrorbits.version="${mirrorbits_version}"
LABEL io.jenkins-infra.tools.tini.version="${tini_version}"

ENTRYPOINT [ "/bin/tini","--" ]

CMD [ "/usr/bin/mirrorbits","daemon","--config","/etc/mirrorbits/mirrorbits.conf" ]
