#!/usr/bin/env bash
#
# chruby script that installs ruby-install which then installs the lastest
# stable versions of Ruby, JRuby and Rubinius into /opt/rubies or ~/.rubies.
#

set -e

#
# Constants
#
export PREFIX="${PREFIX:-/usr/local}"

if ((! UID )); then SRC_DIR="${SRC_DIR:-/usr/local/src}"
else                SRC_DIR="${SRC_DIR:-$HOME/src}"
fi

#
# Functions
#
function log {
	if [[ -t 1 ]]; then
		printf '%b\n' "\x1b[1m\x1b[32m>>>\x1b[0m \x1b[1m\x1b[37m$1\x1b[0m"
	else
		printf '%s\n' ">>> $1"
	fi
}

function error {
	if [[ -t 1 ]]; then
		printf '%b\n' "\x1b[1m\x1b[31m!!!\x1b[0m \x1b[1m\x1b[37m$1\x1b[0m" >&2
	else
		printf '%s\n' "!!! $1" >&2
	fi
}

function warning {
	if [[ -t 1 ]]; then
		printf '%b\n' "\x1b[1m\x1b[33m***\x1b[0m \x1b[1m\x1b[37m$1\x1b[0m" >&2
	else
		printf '%s\n' "*** $1" >&2
	fi
}

#
# Install chruby
#
log "Installing chruby ..."
make install

#
# Pre Install
#
install -d "$SRC_DIR"
cd "$SRC_DIR"

#
# Install ruby-install (https://github.com/postmodern/ruby-install#readme)
#
RUBY_INSTALL_VERSION="0.2.1"

log "Downloading ruby-install ..."
wget -O ruby-install-$RUBY_INSTALL_VERSION.tar.gz https://github.com/postmodern/ruby-install/archive/v$RUBY_INSTALL_VERSION.tar.gz

log "Extracting ruby-install $RUBY_INSTALL_VERSION ..."
tar -xzvf ruby-install-$RUBY_INSTALL_VERSION.tar.gz
cd ruby-install-$RUBY_INSTALL_VERSION/

log "Installing ruby-install and Rubies ..."
./setup.sh

#
# Configuration
#
log "Configuring chruby ..."

CHRUBY_CONFIG=$(cat <<EOS
[ -n "\\\$BASH_VERSION" ] || [ -n "\\\$ZSH_VERSION" ] || return

source $PREFIX/share/chruby/chruby.sh
EOS)

if [[ -d /etc/profile.d/ ]]; then
	# Bash/Zsh
	echo "$CHRUBY_CONFIG" > /etc/profile.d/chruby.sh
	log "Setup complete! Please restart the shell"
else
	warning "Could not determine where to add chruby configuration."
	warning "Please add the following configuration where appropriate:"
	echo
	echo "$CHRUBY_CONFIG"
	echo
fi
