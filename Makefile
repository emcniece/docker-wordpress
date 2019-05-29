# Creates a base image for emcniece/wordpress

NAMESPACE := emcniece
PROJECT := wordpress
PLATFORM := linux
ARCH := amd64
DOCKER_IMAGE := $(NAMESPACE)/$(PROJECT)

VERSION 		:= $(shell cat VERSION)
WP_VERSION 	:= $(shell cat WP_VERSION)

all: help

help:
	@echo "---"
	@echo "IMAGE: $(DOCKER_IMAGE)"
	@echo "VERSION: $(VERSION)"
	@echo "---"
	@echo "make image - compile Docker image"
	@echo "make run-debug - run container with tail"
	@echo "make docker - push to Docker repository"
	@echo "make release - push to latest tag Docker repository"

image:
	docker build -t $(DOCKER_IMAGE):$(VERSION) \
		-f Dockerfile .

run-debug:
	docker run -d $(DOCKER_IMAGE):$(VERSION) tail -f /dev/null

run:
	docker run -d $(DOCKER_IMAGE):$(VERSION)

docker:
	@echo "Pushing $(DOCKER_IMAGE):$(VERSION)"
	docker push $(DOCKER_IMAGE):$(VERSION)

release: docker
	@echo "Pushing $(DOCKER_IMAGE):latest"
	docker tag $(DOCKER_IMAGE):$(VERSION) $(DOCKER_IMAGE):latest
	docker tag $(DOCKER_IMAGE):$(VERSION) $(DOCKER_IMAGE):$(WP_VERSION)
	docker push $(DOCKER_IMAGE):latest
	docker push $(DOCKER_IMAGE):$(VERSION)
	docker push $(DOCKER_IMAGE):$(WP_VERSION)

clean:
	docker rmi $(DOCKER_IMAGE):$(WP_VERSION)
	docker rmi $(DOCKER_IMAGE):$(VERSION)
	docker rmi $(DOCKER_IMAGE):latest
