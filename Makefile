NAME=chruby
VERSION=0.0.1

FILES=$(shell git ls-files)
PKG=$(NAME)-$(VERSION).tar.bz2
SIG=$(PKG).asc

PREFIX=/usr/local

$(PKG): $(FILES)
	tar -cjvf $(PKG) $(FILES)

pkg: $(PKG)

$(SIG): $(PKG)
	gpg --sign --detach-sign --armor $(PKG)

sign: $(SIG)

all: pkg sign

clean:
	rm -f $(PKG) $(SIG)

install:
	for file in `find {etc,lib,bin,sbin,share} -type f`; do install -D $$file $(PREFIX)/$$file; done
	install -d $(PREFIX)/share/doc/$(NAME)-$(VERSION)/
	cp -r doc/* *.{md,tt,txt} $(PREFIX)/share/doc/$(NAME)-$(VERSION)/

uninstall:
	for file in `find {etc,lib,bin,sbin,share} -type f`; do rm -f $(PREFIX)/$$file; done
	rm -rf $(PREFIX)/share/doc/$(NAME)-$(VERSION)/
