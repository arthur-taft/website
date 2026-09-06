# Manage website
#
# Copyright (c) 2025 Arthur Taft. All Rights Reserved.

SHELL := bash

SITE      := site
CONTENT   := content
STATIC    := static
TEMPLATES := templates

DEPLOY_DIR := /var/www/arthurtaft.net/

ASCIIDOCTOR := asciidoctor
ADOC_FLAGS  := -T $(TEMPLATES) -E slim --failure-level=WARN \
               -a site-name=arthurtaft.net \
               -a site-url=https://arthurtaft.net \
               -a source-url=https://github.com/arthur-taft/website \
               -a author='arthur taft' \
               -a showtitle@

# extra attributes applied only to blog posts
POST_FLAGS := -a content-id=article-content -a paragraph-role= \
              -a heading-offset=1 -a h2-role=article-header -a h3-role=article-subheading

# ---- sources -------------------------------------------------------------
PAGE_SRC  := $(filter-out $(CONTENT)/index.adoc,$(wildcard $(CONTENT)/*.adoc))
POST_SRC  := $(wildcard $(CONTENT)/posts/*.adoc)
RAW_SRC   := $(wildcard $(CONTENT)/*.html)
RESUME_SRC := vendor/resume/arthur-taft-resume-public.adoc
ASSETS    := $(shell find $(STATIC) -type f -not -name '.gitkeep')
TPL       := $(shell find $(TEMPLATES) -type f)

# ---- targets -------------------------------------------------------------
PAGES  := $(patsubst $(CONTENT)/%.adoc,$(SITE)/%/index.html,$(PAGE_SRC))
POSTS  := $(patsubst $(CONTENT)/posts/%.adoc,$(SITE)/blog/post/%/index.html,$(POST_SRC))
RAW    := $(patsubst $(CONTENT)/%.html,$(SITE)/%/index.html,$(RAW_SRC))
COPIED := $(patsubst $(STATIC)/%,$(SITE)/%,$(ASSETS))
INDEX  := $(SITE)/index.html
JSON   := $(SITE)/blog/posts/posts.json

.PHONY: help
help:
	@echo 'make build		default target, builds site into ./site'
	@echo 'make serve		serve site locally using simple python webserver'
	@echo 'make deploy		deploy site'
	@echo 'make test		build and serve site'
	@echo 'make all 		build and deploy site'
	@echo 'make rebuild		clean + build, after deleting or renaming a post'
	@echo 'make clean		cleans'

.PHONY: build
build: $(INDEX) $(PAGES) $(POSTS) $(RAW) $(COPIED) $(JSON) $(SITE)/resume/index.html

# resume lives in its own repo, checked out at vendor/resume
$(RESUME_SRC):
	git submodule update --init vendor/resume

$(SITE)/resume/index.html: $(RESUME_SRC) $(TPL)
	@mkdir -p $(@D)
	$(ASCIIDOCTOR) $(ADOC_FLAGS) -a browser-title=resume -a page-path=/resume/ \
		-a heading-offset=1 -a content-id=resume-body \
		-a extra-styles=/styles/resume-styles.css -o $@ $<

# homepage lives at the root, not /index/
$(INDEX): $(CONTENT)/index.adoc $(TPL)
	@mkdir -p $(@D)
	$(ASCIIDOCTOR) $(ADOC_FLAGS) -a page-path=/ -o $@ $<

# blog posts -> /blog/post/<slug>/index.html
$(SITE)/blog/post/%/index.html: $(CONTENT)/posts/%.adoc $(TPL)
	@mkdir -p $(@D)
	$(ASCIIDOCTOR) $(ADOC_FLAGS) $(POST_FLAGS) -a page-path=/blog/post/$*/ -o $@ $<

# top-level pages -> /<name>/index.html
$(SITE)/%/index.html: $(CONTENT)/%.adoc $(TPL)
	@mkdir -p $(@D)
	$(ASCIIDOCTOR) $(ADOC_FLAGS) -o $@ $<

# hand-written HTML pages pass straight through
$(SITE)/%/index.html: $(CONTENT)/%.html
	@mkdir -p $(@D)
	cp $< $@

# static assets mirror their path under static/
$(SITE)/%: $(STATIC)/%
	@mkdir -p $(@D)
	cp $< $@

# post index consumed by /scripts/blog.js
$(JSON): $(POST_SRC) tools/gen-posts-json.py
	@mkdir -p $(@D)
	python3 tools/gen-posts-json.py $(CONTENT)/posts > $@

.PHONY: all
all:
	$(MAKE) rebuild
	$(MAKE) deploy

# full rebuild -- use this after deleting or renaming a post, since an
# incremental build leaves the old output directory behind
.PHONY: rebuild
rebuild:
	$(MAKE) clean
	$(MAKE) build

.PHONY: test
test: build serve

.PHONY: serve
serve:
	python -m http.server -d $(SITE)

.PHONY: clean
clean:
	rm -rf $(SITE)

.PHONY: deploy
deploy: build
	rsync -avh --delete ./$(SITE)/ $(DEPLOY_DIR)
