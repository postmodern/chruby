#!/bin/sh

source ./etc/profile.d/chruby.sh
RUBIES=(/usr/local/ruby-1.9.3-p194)

chruby_reset
ORIGINAL_PATH=$PATH
