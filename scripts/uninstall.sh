#!/usr/bin/env bash
#
# Installs and configures chruby.
#

set -e

#
# Functions
#
function log() {
	if [[ -t 1 ]]; then
		printf "%b>>>%b %b%s%b\n" "\x1b[1m\x1b[32m" "\x1b[0m" \
		                          "\x1b[1m\x1b[37m" "$1" "\x1b[0m"
	else
		printf ">>> %s\n" "$1"
	fi
}

function error() {
	if [[ -t 1 ]]; then
		printf "%b!!!%b %b%s%b\n" "\x1b[1m\x1b[31m" "\x1b[0m" \
		                          "\x1b[1m\x1b[37m" "$1" "\x1b[0m" >&2
	else
		printf "!!! %s\n" "$1" >&2
	fi
}

function warning() {
	if [[ -t 1 ]]; then
		printf "%b***%b %b%s%b\n" "\x1b[1m\x1b[33m" "\x1b[0m" \
			                  "\x1b[1m\x1b[37m" "$1" "\x1b[0m" >&2
	else
		printf "*** %s\n" "$1" >&2
	fi
}

#
# Un-nstall chruby
#
log "Uninstalling chruby ..."
make uninstall

#
# Removing /etc/profile.d/chruby.sh
#
if [[ -f /etc/profile.d/chruby.sh ]]; then
	log "Removing /etc/profile.d/chruby.sh ..."
	rm /etc/profile.d/chruby.sh
fi

warning "Please restart any running shells."
