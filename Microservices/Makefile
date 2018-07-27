export GOPATH := $(shell pwd)
PROD=./dist
AISERVICE=./src/aiservice
# FAKESERVER=./src/fakeserver
all: deps build
build:
		rm "$(PROD)"/* -f -r
		+$(MAKE) -C $(AISERVICE)
		cp $(AISERVICE)/bin/* $(PROD) -f
		# +$(MAKE) -C $(FAKESERVER)
		# cp $(FAKESERVER)/bin/* $(PROD) -f
deps:
		./deps_install.sh