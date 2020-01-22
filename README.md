# Mirrorbits
This repository hold everything need to build a docker image with mirrorbits based on https://github.com/etix/mirrorbits/

__Why GeoIP requires an account?__
https://blog.maxmind.com/2019/12/18/significant-changes-to-accessing-and-using-geolite2-databases/
https://dev.maxmind.com/geoip/geoip2/geolite2/#License

In order to build this image, you need a file named 'config.env' containing following env variables

DOCKER_IMAGE=<your docker image name without the tag>
GEOIP_ID=<your geolite account ID>
GEOIP_KEY=<your gelite account key>
VERSION=<the version that you want to build>

then run `make build`

## Links

* https://github.com/etix/mirrorbits/
