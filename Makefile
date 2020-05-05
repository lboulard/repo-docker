# Makefile for fast creation/deletion of Docker images and containers

all: help

images: image image-2.7 image-testing image-trusty
image: .image
image-2.7: .image-2.7
image-testing: .image-testing
image-trusty: .image-trusty

.image: Dockerfile
	docker build --build-arg user=$${USER} --build-arg uid=$$(id -u) -t android-repo:latest .
	touch "$@"

.image-2.7: Dockerfile-20.04
	docker build --build-arg user=$${USER} --build-arg uid=$$(id -u) --build-arg repo=repo-1 -f Dockerfile-20.04 -t android-repo:2.7 .
	touch "$@"

.image-testing: Dockerfile-testing
	docker build --build-arg user=$${USER} --build-arg uid=$$(id -u) -f Dockerfile-testing -t android-repo:testing .
	touch "$@"

.image-trusty: Dockerfile-trusty
	docker build --build-arg username=$$(id -un) \
		--build-arg userid=$$(id -u) --build-arg groupid=$$(id -g) \
		-f Dockerfile-trusty -t android-build:trusty .
	touch "$@"

clean:
	@docker image prune -f
	@$(RM) -f .image .image-2.7 .image-testing .image-trusty

.PHONY: clobber
clobber: clean
	docker rmi -f android-repo:latest
	docker rmi -f android-repo:2.7
	docker rmi -f android-repo:testing
	docker rmi -f android-build:trusty

.PHONY: run
run:
	docker run --rm -it -v "$$HOME:/data" android-repo:latest

.PHONY: run-2.7
run-2.7:
	docker run --rm -it -v "$$HOME:/data" android-repo:2.7

.PHONY: run-testing
run-testing:
	docker run --rm -it -v "$$HOME:/data" android-repo:testing

.PHONY: run-trusty
run-trusty: image-trusty
	docker run --privileged --rm -it -v "$${HOME}:/home/$$(id -un)" android-build:trusty

.PHONY: help
help:
	@echo "Makefile targets:"
	@{ \
		echo " help^  Display this message"; \
		echo " image^  Build Docker image android-repo:latest for latest repo on Ubuntu 18.04"; \
		echo " image-2.7^  Build Docker image android-repo:2.7 for latest repo supported by Python 2.7 on Ubuntu 20.04"; \
		echo " image-testing^  Build Docker image android-repo:testing for latest repo with Python 3.6 on Debian testing"; \
		echo " image-trusty^  Build Docker image android-build:trusty for latest repo on Ubuntu 14.04"; \
		echo " run^  Run bash from image android-repo:latest"; \
		echo " run-2.7^  Run bash from image android-repo:2.7"; \
		echo " run-testing^  Run bash from image android-repo:testing"; \
		echo " run-trusty^  Run bash from image android-build:trusty"; \
		echo " images^  Build targets image, image-2.7, image-testing and image-trusty"; \
		echo " clean^  Prune docker image"; \
		echo " clobber^  Run clean target and destroy docker images"; \
	} | column -s ^ -t -e
