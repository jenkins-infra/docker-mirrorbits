.PHONY: build push run shell
include config.env

build:
	docker build \
		-t $(DOCKER_IMAGE):$(VERSION)-cron \
		--build-arg VERSION=$(VERSION) \
		--no-cache \
		-f Dockerfile.cron \
		.
	docker build \
		-t $(DOCKER_IMAGE):$(VERSION) \
		--no-cache \
		--build-arg GEOIP_ID="$(GEOIP_ID)" \
		--build-arg GEOIP_KEY="$(GEOIP_KEY)" \
		--build-arg VERSION=$(VERSION) \
		.

push:
	docker push $(DOCKER_IMAGE):$(VERSION)
	docker push $(DOCKER_IMAGE):$(VERSION)-cron

cron:
	docker run -i -t --name mirror --rm $(DOCKER_IMAGE):$(VERSION)-cron

run:
	docker run -i -t --name mirror --rm $(DOCKER_IMAGE):$(VERSION)

shell:
	docker run -i -t --rm --entrypoint /bin/sh  $(DOCKER_IMAGE):$(VERSION)
