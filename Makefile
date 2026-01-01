# Manage website
#
# Copyright (c) 2025 Arthur Taft. All Rights Reserved.

SHELL := bash

.PHONY: help 
help:
	@echo 'make build		default target, builds site into ./site'
	@echo 'make serve		serve site locally using simple python webserver'
	@echo 'make deploy		deploy site'
	@echo 'make test		build and serve site'
	@echo 'make all 		build and deploy site'
	@echo 'make clean		cleans'

.PHONY: build
build:
	mkdir -p site site/about site/blog/posts site/contact site/resume site/static
	echo -n > site/static/index.html
	cat static/LiberationMono-Regular.woff2 > site/static/LiberationMono-Regular.woff2
	cat static/about.html > site/about/index.html
	cat static/blog.html > site/blog/index.html
	cat static/contact.html > site/contact/index.html
	cat static/in-progress.gif > site/static/in-progress.gif
	cat static/index.html > site/index.html
	cat static/posts.json > site/blog/posts.json
	cat static/resume-styles.css > site/static/resume-styles.css
	cat static/resume.html > site/resume/index.html
	cat static/shell-icon.ico > site/favicon.ico
	cat static/styles.css > site/static/styles.css
	cat static/posts/example.txt > site/blog/posts/example.txt
	cat static/posts/first.txt > site/blog/posts/first.txt
	cat static/posts/article.html > site/blog/posts/article.html

.PHONY: all
all: build deploy

.PHONY: test
test: build serve

.PHONY: serve
serve:
	python -m http.server -d site

.PHONY: clean 
clean:
	rm -rf site

.PHONY: deploy
deploy:
	rsync -avh --delete ./site/ /var/www/arthurtaft.net/
