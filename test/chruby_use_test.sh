#!/bin/sh

. test/helper.sh

function test_chruby_use()
{
	local ruby_root="/usr/local/ruby-1.9.3-p194"

	chruby_use $ruby_root

	assertEquals "invalid RUBY" "$ruby_root" "$RUBY"
	assertEquals "invalid RUBY_ENGINE"  "ruby" "$RUBY_ENGINE"
	assertEquals "invalid RUBY_VERSION" "1.9.3" "$RUBY_VERSION"
	assertEquals "invalid GEM_ROOT" "$RUBY/lib/ruby/gems/1.9.1" "$GEM_ROOT"
	assertEquals "invalid GEM_HOME" "$HOME/.gem/$RUBY_ENGINE/$RUBY_VERSION" "$GEM_HOME"
	assertEquals "invalid GEM_PATH" "$GEM_HOME:$GEM_ROOT" "$GEM_PATH"

	assertEquals "could not find ruby in $PATH" "$ruby_root/bin/ruby" `which ruby`
}
