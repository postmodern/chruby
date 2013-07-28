#!/usr/bin/env bash
#
# chruby script that installs ruby-install which then installs the lastest
# stable versions of Ruby, JRuby and Rubinius into /opt/rubies or ~/.rubies.
#

set -e

#
# Constants
#
PREFIX="${PREFIX:-/usr/local}"
export PREFIX

if (( UID == 0 )); then src_dir="${src_dir:-/usr/local/src}"
else                    src_dir="${src_dir:-$HOME/src}"
fi

#
# Functions
#
function log() {
	if [[ -t 1 ]]; then
		printf '%b\n' "\x1b[1m\x1b[32m>>>\x1b[0m \x1b[1m\x1b[37m$1\x1b[0m"
	else
		printf '%s\n' ">>> $1"
	fi
}

function error() {
	if [[ -t 1 ]]; then
		printf '%b\n' "\x1b[1m\x1b[31m!!!\x1b[0m \x1b[1m\x1b[37m$1\x1b[0m" >&2
	else
		printf '%s\n' "!!! $1" >&2
	fi
}

function warning() {
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
install -d "$src_dir"
cd "$src_dir"

#
# Install ruby-install (https://github.com/postmodern/ruby-install#readme)
#
ruby_install_version="0.2.1"

log "Downloading ruby-install ..."
wget -O ruby-install-$ruby_install_version.tar.gz https://github.com/postmodern/ruby-install/archive/v$ruby_install_version.tar.gz

log "Extracting ruby-install $ruby_install_version ..."
tar -xzvf ruby-install-$ruby_install_version.tar.gz
cd ruby-install-$ruby_install_version/

log "Installing ruby-install and Rubies ..."
./setup.sh

#
# Configuration
#
log "Configuring chruby ..."

chruby_config=(
	      '[[ -n "$BASH_VERSION" || -n "$ZSH_VERSION" ]] || return'
	      "source \"$PREFIX/share/chruby/chruby.sh\""
	      )

if [[ -d /etc/profile.d/ ]]; then
	# Bash/Zsh
	printf '%s\n' "${chruby_config[@]}" > /etc/profile.d/chruby.sh
	log "Setup complete! Please restart the shell"
else
	warning "Could not determine where to add chruby configuration."
	warning "Please add the following configuration where appropriate:"
	printf '\n%s\n' "${chruby_config[@]}"
fi
