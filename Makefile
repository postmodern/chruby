NAME=chruby
VERSION=0.3.6
AUTHOR=postmodern
URL=https://github.com/$(AUTHOR)/$(NAME)

DIRS=etc lib bin sbin share
INSTALL_DIRS=`find $(DIRS) -type d 2>/dev/null`
INSTALL_FILES=`find $(DIRS) -type f 2>/dev/null`
DOC_FILES=*.md *.txt

PKG_DIR=pkg
PKG_NAME=$(NAME)-$(VERSION)
PKG=$(PKG_DIR)/$(PKG_NAME).tar.gz
SIG=$(PKG).asc

DESTDIR?=/
PREFIX?=/usr/local
INSTALL_PATH=$(DESTDIR)/$(PREFIX)
DOC_DIR?=$(INSTALL_PATH)/share/doc/$(NAME)

pkg:
	mkdir $(PKG_DIR)

download: pkg
	wget -O $(PKG) $(URL)/archive/v$(VERSION).tar.gz

build: pkg
	git archive --output=$(PKG) --prefix=$(PKG_NAME)/ HEAD

sign: $(PKG)
	gpg --sign --detach-sign --armor $(PKG)
	git add $(PKG).asc
	git commit $(PKG).asc -m "Added PGP signature for v$(VERSION)"
	git push

verify: $(PKG) $(SIG)
	gpg --verify $(SIG) $(PKG)

clean:
	rm -f $(PKG) $(SIG)

all: $(PKG) $(SIG)

test/rubies:
	./test/setup

test: test/rubies
	SHELL=`which bash` ./test/runner
	SHELL=`which zsh`  ./test/runner

tag:
	git push
	git tag -s -m "Releasing $(VERSION)" v$(VERSION)
	git push --tags

release: tag download sign

install:
	for dir in $(INSTALL_DIRS); do mkdir -p $(INSTALL_PATH)/$$dir; done
	for file in $(INSTALL_FILES); do cp $$file $(INSTALL_PATH)/$$file; done
	mkdir -p $(DOC_DIR)
	cp -r $(DOC_FILES) $(DOC_DIR)/

uninstall:
	for file in $(INSTALL_FILES); do rm -f $(INSTALL_PATH)/$$file; done
	rm -rf $(DOC_DIR)

.PHONY: build download sign verify clean test tag release \
	install_files install uninstall all
