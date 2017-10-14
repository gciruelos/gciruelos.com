SITE=./dist/build/site/site

$(SITE):
	cabal configure
	cabal build

watch: build
	$(SITE) watch

build: $(SITE)
	$(SITE) build

clean: $(SITE)
	$(SITE) clean

clean-all: clean
	rm -rf dist/
