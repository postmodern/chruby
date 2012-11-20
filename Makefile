NAME=chruby
VERSION=0.2.2

FILES=$(shell git ls-files 2>/dev/null)
INSTALL_DIRS=$(shell find etc lib bin sbin share -type d 2>/dev/null)
INSTALL_FILES=$(shell find etc lib bin sbin share -type f 2>/dev/null)
DOC_FILES=$(shell find *.md *.tt *.txt 2>/dev/null)

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
	for dir in $(INSTALL_DIRS); do install -d $(PREFIX)/$$dir; done
	for file in $(INSTALL_FILES); do install $$file $(PREFIX)/$$file; done
	install -d $(DOC_DIR)
	cp -r $(DOC_FILES) $(DOC_DIR)/

uninstall:
	for file in $(INSTALL_FILES); do rm -f $(PREFIX)/$$file; done
	rm -rf $(DOC_DIR)
