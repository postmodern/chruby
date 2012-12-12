#!/bin/sh

[[ -z "$SHUNIT2"     ]] && SHUNIT2=/usr/share/shunit2/shunit2
[[ -n "$ZSH_VERSION" ]] && setopt shwordsplit

. ./share/chruby/chruby.sh
chruby_reset

TEST_PATH="$PATH"
TEST_RUBY_ENGINE="ruby"
TEST_RUBY_VERSION="1.9.3"
TEST_RUBY_PATCHLEVEL="327"
TEST_RUBY_API="1.9.1"
TEST_RUBY="/opt/rubies/ruby-$TEST_RUBY_VERSION-p$TEST_RUBY_PATCHLEVEL"

RUBIES=($TEST_RUBY)

setUp() { return; }
tearDown() { return; }
oneTimeTearDown() { return; }
