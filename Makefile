SITE=$(shell find .stack-work/dist/x86_64-linux-tinfo6 -name "site" -type f)

$(SITE):
	stack build

watch: build
	$(SITE) watch

build: $(SITE)
	$(SITE) build

clean: $(SITE)
	$(SITE) clean

clean-all: clean
	rm -rf dist .stack-work _site _cache
