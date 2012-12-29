#!/bin/sh

. ./test/helper.sh

setUp()
{
	chruby_use "$TEST_RUBY_ROOT"

	export PATH="$GEM_HOME/bin:$GEM_ROOT/bin:$RUBY_ROOT/bin:$TEST_PATH"
}

test_chruby_reset()
{
	chruby_reset

	assertNull "RUBY_ROOT was not unset"     "$RUBY_ROOT"
	assertNull "RUBY_ENGINE was not unset"   "$RUBY_ENGINE"
	assertNull "RUBY_VERSION was not unset"  "$RUBY_VERSION"
	assertNull "RUBYOPT was not unset"       "$RUBYOPT"
	assertNull "GEM_HOME was not unset"      "$GEM_HOME"
	assertNull "GEM_PATH was not unset"      "$GEM_PATH"

	assertEquals "PATH was not sanitized"    "$TEST_PATH" "$PATH"
}

test_chruby_reset_duplicate_path()
{
	export PATH="$PATH:$GEM_HOME/bin:$GEM_ROOT/bin:$RUBY_ROOT/bin"

	chruby_reset

	assertEquals "PATH was not sanitized"    "$TEST_PATH" "$PATH"
}

SHUNIT_PARENT=$0 . $SHUNIT2
