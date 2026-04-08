build:
	bash build.sh build

watch:
	bash build.sh watch

diff:
	bash diff.sh

clean:
	rm -rf dist .stack-work _site _cache __site __site_tmp
