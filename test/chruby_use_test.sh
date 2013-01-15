#!/bin/sh

. ./test/helper.sh

setUp()
{
	chruby_use $TEST_RUBY_ROOT
}

test_chruby_use()
{
	assertEquals "invalid RUBY_ROOT"       "$TEST_RUBY_ROOT" "$RUBY_ROOT"
	assertEquals "invalid RUBY_ENGINE"     "$TEST_RUBY_ENGINE" "$RUBY_ENGINE"
	assertEquals "invalid RUBY_VERSION"    "$TEST_RUBY_VERSION" "$RUBY_VERSION"
	assertEquals "invalid RUBY_PATCHLEVEL" "$TEST_RUBY_PATCHLEVEL" "$RUBY_PATCHLEVEL"
	assertEquals "invalid GEM_ROOT"        "$TEST_RUBY_ROOT/lib/ruby/gems/$TEST_RUBY_API" "$GEM_ROOT"
	assertEquals "invalid GEM_HOME"        "$HOME/.gem/$TEST_RUBY_ENGINE/$TEST_RUBY_VERSION" "$GEM_HOME"
	assertEquals "invalid GEM_PATH"        "$GEM_HOME:$GEM_ROOT" "$GEM_PATH"

	assertEquals "could not find ruby in $PATH" "$TEST_RUBY_ROOT/bin/ruby" `which ruby`
}

tearDown() {
	chruby_reset
}

SHUNIT_PARENT=$0 . $SHUNIT2
