#!/bin/sh

. test/helper.sh

function before_chruby_reset()
{
	export RUBY_VERSION="$TEST_RUBY_VERSION"
	export RUBY_ENGINE="$TEST_RUBY_ENGINE"
	export RUBY="/usr/local/$TEST_RUBY_ENGINE-$TEST_RUBY_VERSION-p$TEST_RUBY_PATCHLEVEL"
	export GEM_ROOT="$TEST_RUBY/lib/ruby/gems/$TEST_RUBY_API"
	export GEM_HOME="$HOME/.gem/$TEST_RUBY_ENGINE/$TEST_RUBY_VERSION"

	export PATH="$GEM_HOME/bin:$GEM_ROOT/bin:$RUBY/bin:$TEST_PATH"
}

test_chruby_reset()
{
	before_chruby_reset

	chruby_reset

	assertNull "RUBY was not unset"          $RUBY
	assertNull "RUBY_ENGINE was not unset"   $RUBY_ENGINE
	assertNull "RUBY_VERSION was not unset"  $RUBY_VERSION
	assertNull "RUBYOPT was not unset"       $RUBYOPT
	assertNull "GEM_HOME was not unset"      $GEM_HOME
	assertNull "GEM_PATH was not unset"      $GEM_PATH
}
