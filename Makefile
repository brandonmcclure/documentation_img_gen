TESTTOOL=sh -c '\
  function replace_slashes() { \
 while read line; do			\
 echo "$${line/ /./}"			\
 done							\
}								\
git branch --show-current | replace_slashes' TESTTOOL

ifneq (,$(filter n,$(MAKEFLAGS)))
TESTTOOL=: TESTTOOL
endif

getcommitid: 
	$(eval COMMITID = $(shell git log -1 --pretty=format:"%H"))
getbranchname:
	$(eval BRANCH_NAME = $(TESTTOOL))


.PHONY: all clean test lint
all: test

REGISTRY_NAME := 
REPOSITORY_NAME := bmcclure89/
IMAGE_NAME := documentation_img_gen
TAG := :latest

# Run Options

docker_build: 
	docker build -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME)$(TAG) -f ./src/Dockerfile ./src/.
docker_run: docker_build
	docker run -d -p 7860:7860 $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME)$(TAG)

run: 
	sh documentation_img_gen.venv/bin/activate && python src/main.py

run_it:
	docker run -it $(RUN_PORTS) $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME)$(TAG)

package:
	$$PackageFileName = "$$("$(IMAGE_NAME)" -replace "/","_").tar"; docker save $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME)$(TAG) -o $$PackageFileName

size:
	docker inspect -f "{{ .Size }}" $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME)$(TAG)
	docker history $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME)$(TAG)

publish:
	docker login; docker push $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME)$(TAG); docker logout
lint: lint_makefile
lint_makefile:
	docker run -v $${PWD}:/tmp/lint -e ENABLE_LINTERS=MAKEFILE_CHECKMAKE oxsecurity/megalinter-ci_light:v6.10.0

venv_create:
	python -m venv "documentation_img_gen.venv"

venv_activate:
	source "./documentation_img_gen.venv/bin/activate"

venv_deactivate:
	. "./documentation_img_gen.venv/bin/deactivate"

install_reqs: 
	pip install -r 'src/requirements.txt'