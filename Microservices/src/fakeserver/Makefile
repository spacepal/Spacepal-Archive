export GOPATH := $(abspath $(shell pwd)/../..)
DEP=$(GOPATH)/bin/dep

GOCMD=go
GOBUILD=$(GOCMD) build
GOINSTALL=$(GOCMD) install
GORUN=$(GOCMD) run
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get

BINPATH=./bin
BINNAME=fakeserver
GOMAIN=main.go

all: deps test build clean
build:
		$(GOBUILD) -v -o $(BINPATH)/$(BINNAME)
install:
		$(GOINSTALL) -v -installsuffix TEST
test:
		$(GOTEST) -v ./...
clean:
		$(GOCLEAN)
run:
		$(GORUN) $(GOMAIN)
deps:
	$(DEP) ensure