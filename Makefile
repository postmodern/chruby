NAME=chruby
VERSION=0.2.4

DIRS=etc lib bin sbin share
INSTALL_DIRS=`find $(DIRS) -type d 2>/dev/null`
INSTALL_FILES=`find $(DIRS) -type f 2>/dev/null`
DOC_FILES=*.md *.txt

PKG_DIR=pkg
PKG_NAME=$(NAME)-$(VERSION)
PKG=$(PKG_DIR)/$(PKG_NAME).tar.gz
SIG=$(PKG_DIR)/$(PKG_NAME).asc

PREFIX?=/usr/local
DOC_DIR=$(PREFIX)/share/doc/$(PKG_NAME)
SHUNIT_BIN?=/usr/share/shunit2/shunit2

pkg:
	mkdir -p $(PKG_DIR)

$(PKG): pkg
	git archive --output=$(PKG) --prefix=$(PKG_NAME)/ HEAD

build: $(PKG)

$(SIG): $(PKG)
	gpg --sign --detach-sign --armor $(PKG)

sign: $(SIG)

clean:
	rm -f $(PKG) $(SIG)

all: $(PKG) $(SIG)

test:
	SHELL=`which bash` SHUNIT_BIN=$(SHUNIT_BIN) ./test/runner
	SHELL=`which zsh`  SHUNIT_BIN=$(SHUNIT_BIN) ./test/runner

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

.PHONY: build sign clean test tag release install uninstall all
