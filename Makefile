NAME = $(shell /usr/libexec/PlistBuddy -c Print:name src/info.plist | perl -pe 'y/[A-Z] /[a-z]-/')

all: build open

open:
	open bin/$(NAME).alfredworkflow

build:
	pushd src; zip -r -X ../bin/$(NAME).alfredworkflow .; popd
