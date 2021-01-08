.PHONY: build push run shell
include config.env

build:
	docker build \
		-t $(DOCKER_IMAGE):$(VERSION) \
		--no-cache \
		--build-arg VERSION=$(VERSION) \
		.

push:
	docker push $(DOCKER_IMAGE):$(VERSION)

run:
	docker run -i -t --name mirror --rm $(DOCKER_IMAGE):$(VERSION)

shell:
	docker run -i -t --rm --entrypoint /bin/sh  $(DOCKER_IMAGE):$(VERSION)
