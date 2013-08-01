[[ -z "$SHUNIT2"     ]] && SHUNIT2=/usr/share/shunit2/shunit2
[[ -n "$ZSH_VERSION" ]] && setopt shwordsplit

export PATH="$PWD/bin:$PATH"
export HOME="$PWD/test/home"

. ./share/chruby/chruby.sh
chruby_reset

export TEST_RUBY_ENGINE="ruby"
export TEST_RUBY_VERSION="1.9.3"
export TEST_RUBY_PATCHLEVEL="429"
export TEST_RUBY_API="1.9.1"
export TEST_RUBY_ROOT="$PWD/test/rubies/$TEST_RUBY_ENGINE-$TEST_RUBY_VERSION-p$TEST_RUBY_PATCHLEVEL"

export TEST_PATH="$PATH"
export TEST_GEM_HOME="$HOME/.gem/$TEST_RUBY_ENGINE/$TEST_RUBY_VERSION"
export TEST_GEM_ROOT="$TEST_RUBY_ROOT/lib/ruby/gems/$TEST_RUBY_API"

export TEST_PROJECT_DIR="$PWD/test/project"

RUBIES=($TEST_RUBY_ROOT)

setUp() { return; }
tearDown() { return; }
oneTimeTearDown() { return; }
