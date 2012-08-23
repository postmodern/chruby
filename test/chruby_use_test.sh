#!/bin/sh

. test/helper.sh

function test_chruby_use()
{
	chruby_use $TEST_RUBY

	assertEquals "invalid RUBY" "$TEST_RUBY" "$RUBY"
	assertEquals "invalid RUBY_ENGINE"  "ruby" "$RUBY_ENGINE"
	assertEquals "invalid RUBY_VERSION" "1.9.3" "$RUBY_VERSION"
	assertEquals "invalid GEM_ROOT" "$RUBY/lib/ruby/gems/$TEST_RUBY_API" "$GEM_ROOT"
	assertEquals "invalid GEM_HOME" "$HOME/.gem/$RUBY_ENGINE/$RUBY_VERSION" "$GEM_HOME"
	assertEquals "invalid GEM_PATH" "$GEM_HOME:$GEM_ROOT" "$GEM_PATH"

	assertEquals "could not find ruby in $PATH" "$TEST_RUBY/bin/ruby" `which ruby`
}
