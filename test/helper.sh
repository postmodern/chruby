[[ -z "$SHUNIT2"     ]] && SHUNIT2=/usr/share/shunit2/shunit2
[[ -n "$ZSH_VERSION" ]] && setopt shwordsplit

. ./share/chruby/chruby.sh
export PATH="$PWD/bin:$PATH"

chruby_reset

TEST_HOME="$PWD/test/home"
TEST_PATH="$PATH"
TEST_RUBY_ENGINE="ruby"
TEST_RUBY_VERSION="1.9.3"
TEST_RUBY_PATCHLEVEL="429"
TEST_RUBY_API="1.9.1"
TEST_RUBY_ROOT="$PWD/test/rubies/$TEST_RUBY_ENGINE-$TEST_RUBY_VERSION-p$TEST_RUBY_PATCHLEVEL"

TEST_GEM_HOME="$TEST_HOME/.gem/$TEST_RUBY_ENGINE/$TEST_RUBY_VERSION"
TEST_GEM_ROOT="$TEST_RUBY_ROOT/lib/ruby/gems/$TEST_RUBY_API"

HOME="$TEST_HOME"
RUBIES=($TEST_RUBY_ROOT)

setUp() { return; }
tearDown() { return; }
oneTimeTearDown() { return; }
