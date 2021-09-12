[[ -z "$SHUNIT2"     ]] && SHUNIT2=/usr/share/shunit2/shunit2
[[ -n "$ZSH_VERSION" ]] && setopt shwordsplit

test_fixtures_dir="$PWD/test/fixtures"

export PREFIX="$test_fixtures_dir/root"
export HOME="$PREFIX/home"
export PATH="$PWD/bin:$PATH"

unset GEM_HOME GEM_PATH

. ./test/helpers/ruby.sh
. ./share/chruby/chruby.sh
chruby_reset

# Capture the PATH after chruby_reset
test_path="$PATH"

setUp() { return; }
tearDown() { return; }
oneTimeTearDown() { return; }
