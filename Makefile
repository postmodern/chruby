NAME=chruby
VERSION=0.2.1

FILES=$(shell git ls-files)
INSTALL_DIRS={etc,lib,bin,sbin,share}
DOC_FILES=doc/*
EXTRA_DOC_FILES=*.{md,tt,txt}

PKG_DIR=pkg
PKG_NAME=$(NAME)-$(VERSION)
PKG=$(PKG_DIR)/$(PKG_NAME).tar.gz
SIG=$(PKG_DIR)/$(PKG_NAME).asc

PREFIX=/usr/local
DOC_DIR=$(PREFIX)/share/doc/$(PKG_NAME)

pkg:
	mkdir -p $(PKG_DIR)

$(PKG): pkg $(FILES)
	git archive --output=$(PKG) --prefix=$(PKG_NAME)/ master

build: $(PKG)

$(SIG): $(PKG)
	gpg --sign --detach-sign --armor $(PKG)

sign: $(SIG)

clean:
	rm -f $(PKG) $(SIG)

all: $(PKG) $(SIG)

tag:
	git push
	git tag -s -m "Tagging $(VERSION)" v$(VERSION)
	git push --tags

release: $(PKG) $(SIG) tag

install:
	for dir in `find $(INSTALL_DIRS) -type d 2>/dev/null`; do install -d $(PREFIX)/$$dir; done
	for file in `find $(INSTALL_DIRS) -type f 2>/dev/null`; do install $$file $(PREFIX)/$$file; done
	install -d $(DOC_DIR)
	cp -r $(DOC_FILES) $(EXTRA_DOC_FILES) $(DOC_DIR)/ 2>/dev/null || true

uninstall:
	for file in `find $(INSTALL_DIRS) -type f 2>/dev/null`; do rm -f $(PREFIX)/$$file; done
	rm -rf $(DOC_DIR)
