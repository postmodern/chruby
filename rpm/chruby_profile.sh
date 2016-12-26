#!/bin/sh

if [ -n "$BASH_VERSION" ] || [ -n "$ZSH_VERSION" ]; then
	source /usr/share/chruby/chruby.sh
	source /usr/share/chruby/auto.sh
fi
