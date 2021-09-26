[[ -z "$SHUNIT2"     ]] && SHUNIT2=/usr/share/shunit2/shunit2
[[ -n "$ZSH_VERSION" ]] && setopt shwordsplit

test_dir="$PWD"
test_fixtures_dir="$test_dir/test/fixtures"
test_root_dir="$test_fixtures_dir/root"

export PREFIX="$test_root_dir"
export HOME="$test_root_dir/home"
export PATH="$PWD/bin:$PATH"

unset GEM_HOME GEM_PATH

. ./test/config.sh
. ./share/chruby/chruby.sh
chruby_reset

# Capture the PATH after chruby_reset
test_path="$PATH"

setUp() { return; }
tearDown() { return; }
oneTimeTearDown() { return; }
