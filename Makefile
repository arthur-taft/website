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
	mkdir -p site site/about site/blog/posts/media site/contact site/resume site/static
	echo -n > site/static/index.html
	cat static/LiberationMono-Regular.woff2 > site/static/LiberationMono-Regular.woff2
	cat static/about.html > site/about/index.html
	cat static/blog.html > site/blog/index.html
	cat static/contact.html > site/contact/index.html
	cat static/in-progress.gif > site/static/in-progress.gif
	cat static/index.html > site/index.html
	cat static/posts/posts.json > site/blog/posts/posts.json
	cat static/resume-styles.css > site/static/resume-styles.css
	cat static/resume.html > site/resume/index.html
	cat static/shell-icon.ico > site/favicon.ico
	cat static/styles.css > site/static/styles.css
	cat static/posts/article.html > site/blog/posts/article.html
	cat static/posts/first-post.md > site/blog/posts/first-post.md
	cat static/posts/brutus-sherlock-writeup.md > site/blog/posts/brutus-sherlock-writeup.md
	mkdir -p site/blog/posts/media/brutus-sherlock-writeup
	cat static/posts/media/brutus-sherlock-writeup/task-3.png > site/blog/posts/media/brutus-sherlock-writeup/task-3.png
	cat static/posts/media/brutus-sherlock-writeup/login-time.png > site/blog/posts/media/brutus-sherlock-writeup/login-time.png
	cat static/posts/media/brutus-sherlock-writeup/wtmp-dump.png > site/blog/posts/media/brutus-sherlock-writeup/wtmp-dump.png
	cat static/posts/media/brutus-sherlock-writeup/wtmp-type.png > site/blog/posts/media/brutus-sherlock-writeup/wtmp-type.png
	cat static/posts/media/brutus-sherlock-writeup/task-2.png > site/blog/posts/media/brutus-sherlock-writeup/task-2.png
	cat static/posts/media/brutus-sherlock-writeup/task-1.png > site/blog/posts/media/brutus-sherlock-writeup/task-1.png
	cat static/posts/media/brutus-sherlock-writeup/root-success.png > site/blog/posts/media/brutus-sherlock-writeup/root-success.png
	cat static/posts/media/brutus-sherlock-writeup/overview.png > site/blog/posts/media/brutus-sherlock-writeup/overview.png
	cat static/posts/media/brutus-sherlock-writeup/good-extract.png > site/blog/posts/media/brutus-sherlock-writeup/good-extract.png
	cat static/posts/media/brutus-sherlock-writeup/brute-force-attempts.png > site/blog/posts/media/brutus-sherlock-writeup/brute-force-attempts.png
	cat static/posts/media/brutus-sherlock-writeup/bad-extract.png > site/blog/posts/media/brutus-sherlock-writeup/bad-extract.png
	cat static/posts/media/brutus-sherlock-writeup/linper.png > site/blog/posts/media/brutus-sherlock-writeup/linper.png
	cat static/posts/media/brutus-sherlock-writeup/disconnect.png > site/blog/posts/media/brutus-sherlock-writeup/disconnect.png
	cat static/posts/media/brutus-sherlock-writeup/new-user-added.png > site/blog/posts/media/brutus-sherlock-writeup/new-user-added.png
	cat static/posts/media/brutus-sherlock-writeup/task-8.png > site/blog/posts/media/brutus-sherlock-writeup/task-8.png
	cat static/posts/media/brutus-sherlock-writeup/task-7.png > site/blog/posts/media/brutus-sherlock-writeup/task-7.png
	cat static/posts/media/brutus-sherlock-writeup/task-6.png > site/blog/posts/media/brutus-sherlock-writeup/task-6.png
	cat static/posts/media/brutus-sherlock-writeup/task-5.png > site/blog/posts/media/brutus-sherlock-writeup/task-5.png
	cat static/posts/media/brutus-sherlock-writeup/task-4.png > site/blog/posts/media/brutus-sherlock-writeup/task-4.png
	cat static/posts/media/brutus-sherlock-writeup/task-3.png > site/blog/posts/media/brutus-sherlock-writeup/task-3.png
	cat static/posts/media/brutus-sherlock-writeup/login-time.png > site/blog/posts/media/brutus-sherlock-writeup/login-time.png
	cat static/posts/media/brutus-sherlock-writeup/wtmp-dump.png > site/blog/posts/media/brutus-sherlock-writeup/wtmp-dump.png
	cat static/posts/media/brutus-sherlock-writeup/wtmp-type.png > site/blog/posts/media/brutus-sherlock-writeup/wtmp-type.png
	cat static/posts/media/brutus-sherlock-writeup/task-2.png > site/blog/posts/media/brutus-sherlock-writeup/task-2.png
	cat static/posts/media/brutus-sherlock-writeup/task-1.png > site/blog/posts/media/brutus-sherlock-writeup/task-1.png
	cat static/posts/media/brutus-sherlock-writeup/root-success.png > site/blog/posts/media/brutus-sherlock-writeup/root-success.png
	cat static/posts/media/brutus-sherlock-writeup/overview.png > site/blog/posts/media/brutus-sherlock-writeup/overview.png
	cat static/posts/media/brutus-sherlock-writeup/good-extract.png > site/blog/posts/media/brutus-sherlock-writeup/good-extract.png
	cat static/posts/media/brutus-sherlock-writeup/brute-force-attempts.png > site/blog/posts/media/brutus-sherlock-writeup/brute-force-attempts.png
	cat static/posts/media/brutus-sherlock-writeup/bad-extract.png > site/blog/posts/media/brutus-sherlock-writeup/bad-extract.png

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
