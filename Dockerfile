FROM debian:stable-slim AS mirrorbits

## (DL3008)Ignore lint error about apt pinned packages, as we always want the latest version of these tools
## and the risk of a breaking behavior is evaluated as low
# hadolint ignore=DL3008
RUN apt-get update && \
  apt-get install --no-install-recommends -y tar curl ca-certificates git && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG go_version=1.21.3
RUN mkdir -p /tmp/tools/ && \
  curl -L "https://go.dev/dl/go${go_version}.linux-$(dpkg --print-architecture).tar.gz" --output /tmp/tools/go.tar.gz && \
  tar -C /tmp/tools/ -xzf /tmp/tools/go.tar.gz

ARG mirrorbits_version=v0.5.1
ARG mirrorbits_current_commit=9189dc7
# hadolint ignore=DL3003
RUN git clone https://github.com/etix/mirrorbits /tmp/tools/mirrorbits && \
  cd /tmp/tools/mirrorbits && \
  git checkout "${mirrorbits_current_commit}" && \
  /tmp/tools/go/bin/go build

ARG tini_version=v0.19.0
RUN curl --silent --show-error --output /tmp/tools/tini --location \
  "https://github.com/krallin/tini/releases/download/${tini_version}/tini-$(dpkg --print-architecture)" && \
  chmod +x /tmp/tools/tini

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
  ln -s /dev/stdout /var/log/mirrorbits/downloads.log && \
  chown mirrorbits -R /usr/share/mirrorbits/ && \
  chown mirrorbits /run/mirrorbits && \
  chown mirrorbits /var/log/mirrorbits && \
  chown mirrorbits /srv/repo

USER mirrorbits

COPY config/mirrorbits.conf /etc/mirrorbits/mirrorbits.conf

COPY --from=mirrorbits /tmp/tools/tini /bin/tini

COPY --from=mirrorbits /tmp/tools/mirrorbits/mirrorbits /usr/bin/mirrorbits

COPY --from=mirrorbits /tmp/tools/mirrorbits/templates /usr/share/mirrorbits/templates

LABEL io.jenkins-infra.tools="mirrorbits,tini"
LABEL io.jenkins-infra.tools.mirrorbits.version="${mirrorbits_version}"
LABEL io.jenkins-infra.tools.tini.version="${tini_version}"

ENTRYPOINT [ "/bin/tini","--" ]

CMD [ "/usr/bin/mirrorbits","daemon","--config","/etc/mirrorbits/mirrorbits.conf" ]
