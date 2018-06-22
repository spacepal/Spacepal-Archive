export GOPATH := $(shell pwd)
PROD=./production
AISERVICE=./src/aiservice
all: deps build
build:
		+$(MAKE) -C $(AISERVICE)
		cp $(AISERVICE)/bin/* $(PROD) -f
deps:
		./deps_install.sh