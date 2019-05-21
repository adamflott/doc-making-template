NAME=doc-name
VERSION=0

ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
PUBLISHED=$(ROOT_DIR)/published
BUILD=$(ROOT_DIR)/draft
DIAGRAMS=$(ROOT_DIR)/diagrams
TEMPLATES=$(ROOT_DIR)/templates

PANDOC_BIN=pandoc
PANDOC_MARKDOWN_EXTENSIONS=yaml_metadata_block+implicit_figures+multiline_tables+fenced_code_attributes+inline_notes+smart
PANDOC_OPTS= \
		--data-dir=$(ROOT_DIR)/ \
		--from=markdown+$(PANDOC_MARKDOWN_EXTENSIONS) \
		--number-sections \
		--table-of-contents \
		--variable=colorlinks \
		--variable=documentclass:article \
		--variable=fontsize:10pt \
		--variable=geometry:margin=0.75in \
		--variable=graphics \
		--variable=longtable \
		--variable=papersize:letterpaper \
		--variable=version=2.0


FINAL ?= --variable=draft

INPUTS=$(sort $(wildcard *.md))
FILENAME_DESIGN_PDF=$(NAME)-$(VERSION).pdf
FILENAME_DESIGN_DOCX=$(NAME)-$(VERSION).docx

draft: $(BUILD)/$(FILENAME_DESIGN_PDF) $(BUILD)/$(FILENAME_DESIGN_DOCX)

final:
	-mkdir $(PUBLISHED)
	$(MAKE) FINAL="" clean draft $(PUBLISHED)/$(FILENAME_DESIGN_PDF) $(PUBLISHED)/$(FILENAME_DESIGN_DOCX)

clean:
	-rm $(BUILD)/*
	-rm $(PUBLISHED)/*

$(PUBLISHED)/$(FILENAME_DESIGN_PDF): $(BUILD)/$(FILENAME_DESIGN_PDF)
	cp $(BUILD)/$(FILENAME_DESIGN_PDF) $(PUBLISHED)

$(PUBLISHED)/$(FILENAME_DESIGN_DOCX): $(BUILD)/$(FILENAME_DESIGN_DOCX)
	cp $(BUILD)/$(FILENAME_DESIGN_DOCX) $(PUBLISHED)

$(BUILD)/$(FILENAME_DESIGN_PDF): $(INPUTS)
	-mkdir $(BUILD)
	$(PANDOC_BIN) $(PANDOC_OPTS) $(FINAL) --to=latex --pdf-engine=xelatex -o $@ $^

$(BUILD)/$(FILENAME_DESIGN_DOCX): $(INPUTS)
	-mkdir $(BUILD)
	$(PANDOC_BIN) $(PANDOC_OPTS) $(FINAL) --to docx -o $@ $^

.PHONY: all clean draft final
