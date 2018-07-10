export GOPATH := $(shell pwd)
PROD=./production
AISERVICE=./src/aiservice
FAKESERVER=./src/fakeserver
all: deps build
build:
		+$(MAKE) -C $(AISERVICE)
		cp $(AISERVICE)/bin/* $(PROD) -f
		+$(MAKE) -C $(FAKESERVER)
		cp $(FAKESERVER)/bin/* $(PROD) -f
deps:
		./deps_install.sh