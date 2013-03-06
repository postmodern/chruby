NAME=chruby
VERSION?=0.3.4
AUTHOR=postmodern
URL=https://github.com/$(AUTHOR)/$(NAME)

INSTALL_FILES= share/**/* bin/*
DOC_FILES=*.md *.txt

PKG_DIR=pkg
PKG_NAME=$(NAME)-$(VERSION)
PKG=$(PKG_DIR)/$(PKG_NAME).tar.gz
SIG=$(PKG_DIR)/$(PKG_NAME).asc

PREFIX?=/usr/local
DOC_DIR=$(PREFIX)/share/doc/$(PKG_NAME)

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

test:
	SHELL=`which bash` ./test/runner
	SHELL=`which zsh`  ./test/runner

tag:
	git push
	git tag -s -m "Tagging $(VERSION)" v$(VERSION)
	git push --tags

release: tag download sign

install:
	for file in $(INSTALL_FILES); do \
                mkdir -p $(PREFIX)/`dirname $$file` ;\
		install -m 644 -c $$file $(PREFIX)/$$file ;\
	done
	for doc in $(DOC_FILES); do \
                mkdir -p $(DOC_DIR); \
		install -m 644 -c $$doc $(DOC_DIR)/$$doc; \
	done

uninstall:
	for file in $(INSTALL_FILES); do rm -f $(PREFIX)/$$file; done
	rm -rf $(DOC_DIR)

.PHONY: build download sign verify clean test tag release install uninstall all
