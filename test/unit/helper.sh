[[ -z "$SHUNIT2"     ]] && SHUNIT2=/usr/share/shunit2/shunit2
[[ -n "$ZSH_VERSION" ]] && setopt shwordsplit

test_dir="$PWD/test/unit"
test_fixtures_dir="$test_dir/fixtures"
test_root_dir="$test_fixtures_dir/root"

export PREFIX="$test_root_dir"
export HOME="$test_root_dir/home"
export PATH="$PWD/bin:$PATH"
hash -r

unset GEM_HOME GEM_PATH

. ./test/unit/config.sh
. ./share/chruby/chruby.sh
chruby_reset

# Capture certain env variables so we can restore them
original_path="$PATH"
original_pwd="$PWD"

setUp() { return; }
tearDown() { return; }
oneTimeTearDown() { return; }
