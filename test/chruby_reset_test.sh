#!/bin/sh

. test/helper.sh

function before_chruby_reset()
{
	export RUBY_VERSION="1.9.3"
	export RUBY_PATCHLEVEL="194"
	export RUBY_ENGINE="ruby"
	export RUBY="/usr/local/$RUBY_ENGINE-$RUBY_VERSION-p$RUBY_PATCHLEVEL"
	export GEM_ROOT="$RUBY/lib/ruby/gems/1.9.1/bin"
	export GEM_HOME="$HOME/.gem/$RUBY_ENGINE/$RUBY_VERSION"

	export PATH="$GEM_HOME/bin:$GEM_ROOT/bin:$RUBY/bin:$ORIGINAL_PATH"
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
