SITE=./dist/build/site/site

watch:
	$(SITE) watch

build:
	$(SITE) build

clean:
	rm -rf _cache _site dist
