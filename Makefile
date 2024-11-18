# Thank you @Earthly https://www.youtube.com/watch?v=w2UeLF7EEwk
# Can be adapted to pipenv, and poetry
# Other languages coming soon especially R and Julia

# .ONESHELL tells make to run each recipe line in a single shell
.ONESHELL:

# .DEFAULT_GOAL tells make which target to run when no target is specified
.DEFAULT_GOAL := all

# Specify python location in virtual environment
# Specify pip location in virtual environment
PYTHON := .venv/bin/python3
PIP := .venv/bin/pip3
DOCKER_CONTAINER_NAME := chronic-kidney-disease-kaggle

venv/bin/activate: requirements.txt
	# create virtual environment
	python3 -m venv .venv
	# make command executable
	chmod +x .venv/bin/activate
	# activate virtual environment
	. .venv/bin/activate
  
activate:
	# activate virtual environment
	. .venv/bin/activate

install: venv/bin/activate requirements.txt # prerequisite
	# install commands
	$(PIP) --no-cache-dir install --upgrade pip &&\
		$(PIP) --no-cache-dir install -r requirements.txt
    
docstring: activate
	# format docstring
	pyment -w -o numpydoc *.py
  
format: activate 
	# format code
	black *.py utils/*.py testing/*.py
  
clean:
	# clean directory of cache
	rm -rf __pycache__ &&\
	rm -rf utils/__pycache__ &&\
	rm -rf testing/__pycache__ &&\
	rm -rf .pytest_cache &&\
	rm -rf .venv
	rm -rf data/
  
lint: activate install format
	# flake8 or #pylint
	pylint --disable=R,C --errors-only *.py utils/*.py testing/*.py

setup_readme:  ## Create a README.md
	@if [ ! -f README.md ]; then \
		echo "# Project Name\n\
Description of the project.\n\n\
## Installation\n\
- Step 1\n\
- Step 2\n\n\
## Usage\n\
Explain how to use the project here.\n\n\
## Contributing\n\
Explain how to contribute to the project.\n\n\
## License\n\
License information." > README.md; \
		echo "README.md created."; \
	else \
		
  
test: activate install format
	# test
	$(PYTHON) -m pytest testing/*.py
  
run: activate install format lint
	# run application
  	# example $(PYTHON) app.py
  
docker_build: Dockerfile
	# build container
	#docker build --platform linux/amd64 -t plot-timeseries-app:v0 .
	# you might need to use sudo or set the platform to linux/amd64, linux/arm64 or linux/arm/v7
	sudo docker build --platform linux/amd64 -t $(DOCKER_CONTAINER_NAME) .
  
docker_run_test: Dockerfile
	# linting Dockerfile
	docker run --rm -i hadolint/hadolint < Dockerfile
	
docker_clean: Dockerfile
	# remove dangling images, containers, volumes and networks
	sudo docker system prune -a
  
docker_run: Dockerfile docker_build
	# run docker
	# docker run -e ENDPOINT_URL -e SECRET_KEY -e SPACES_ID -e SPACES_NAME plot-timeseries-app:v0
	# -d for detached mode (background), -p for port mapping, -v for volume mapping and --name for container name
	# --security-opt=no-new-privileges:true for security 
	sudo docker run \
	  -d \
	  --platform linux/amd64 \
	  --security-opt=no-new-privileges:true \
	  -p 9999:9999 \
	  -v $(pwd)/data:/app/data \
	  --name $(DOCKER_CONTAINER_NAME) $(DOCKER_CONTAINER_NAME)

docker_push: docker_build
  # push to registry
  # docker tag <my-image> registry.digitalocean.com/<my-registry>/<my-image>
  # docker push registry.digitalocean.com/<my-registry>/<my-image>  
  
 
# .PHONY tells make that these targets do not represent actual files
.PHONY: activate format clean lint test build run docker_build docker_run docker_push docker_clean docker_run_test
  
all: install format lint test run docker_build docker_run docker_push
