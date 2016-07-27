SITE=./dist/build/site/site

watch:
	$(SITE) watch

build:
	$(SITE) build

clean:
	$(SITE) clean

clean-all: clean
	rm -rf dist/
