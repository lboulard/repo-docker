# Makefile for fast createrion/delation of Docker images and containers

all: help

images: image image-2.7
image: .image
image-2.7: .image-2.7

.image: Dockerfile
	docker build --build-arg user=$${USER} --build-arg uid=$$(id -u) -t android-repo:latest .
	touch "$@"

.image-2.7: Dockerfile-20.04
	docker build --build-arg user=$${USER} --build-arg uid=$$(id -u) --build-arg repo=repo-1 -f Dockerfile-20.04 -t android-repo:2.7 .
	touch "$@"

clean:
	@$(RM) -f .image .image-2.7

.PHONY: clobber
clobber: clean
	docker rmi -f android-repo:latest
	docker rmi -f android-repo:2.7

.PHONY: run
run:
	docker run --rm -it -v "$$HOME:/data" android-repo:latest

.PHONY: run-2.7
run-2.7:
	docker run --rm -it -v "$$HOME:/data" android-repo:2.7

.PHONY: help
help:
	@echo "$(MAKE) targets:"
	@echo "         help:  Display this message"
	@echo "        image:  Build Docker image android-repo:latest for latest repo on Ubuntu 18.04"
	@echo "    image-2.7:  Build Docker image android-repo:2.7 for latest repo supported by Python 2.7 on Ubuntu 20.04"
	@echo "          run:  Run bash from image android-repo:latest"
	@echo "      run-2.7:  Run bash from image android-repo:2.7"
	@echo "       images:  Build targets image and image-2.7"
	@echo "        clean:  Remove sentinel for images build"
	@echo "      clobber:  Target clean and destroy docker images"
