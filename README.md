# Mirrorbits

This repository hold everything needed to build a mirrorbits docker image based on [etix/mirroribts](https://github.com/etix/mirrorbits/). To build this image, you can run `make build`.


! This image doesn't contain a Geoip database. It has to be provided in a different way. Feel free to look at this [helm-chart](https://github.com/jenkins-infra/charts/tree/master/charts/mirrorbits) for suggestion.

## Various

__Why GeoIP requires an account?__

* https://blog.maxmind.com/2019/12/18/significant-changes-to-accessing-and-using-geolite2-databases/
* https://dev.maxmind.com/geoip/geoip2/geolite2/#License

## Links

* [Project](https://github.com/etix/mirrorbits/)
* [Helm-chart](https://github.com/jenkins-infra/charts/tree/master/charts/mirrorbits)
* [Jenkinsfile_Shared-Library](https://github.com/jenkins-infra/pipeline-library)
* [DockerHub](https://hub.docker.com/repository/docker/jenkinsciinfra/mirrorbits)

## Contribute

If you want to contribute, or build/test the Docker Image, please refer to the following documentation about Docker images for the Jenkins Infra project:
<https://github.com/jenkins-infra/pipeline-library/blob/split_docker_build_and_publish/resources/io/jenkins/infra/docker/README.adoc>.
