BUILDIR := bin
SHELL := /bin/bash

ifneq (,$(findstring Darwin,$(shell uname)))
	NAME = $(shell xpath src/info.plist "//dict/key[text()='name']/following-sibling::string[1]/text()" | tail -n 1 | perl -pe 'y/[A-Z] /[a-z]-/')
else
	NAME = $(shell xpath -e "//dict/key[text()='name']/following-sibling::string[1]/text()" src/info.plist | tail -n 1 | perl -pe 'y/[A-Z] /[a-z]-/')
endif

all: build open

open:
	open bin/$(NAME).alfredworkflow

build:
	mkdir -p $(BUILDIR)
	pushd src; zip -r -X ../bin/$(NAME).alfredworkflow .; popd
