[[ -z "$SHUNIT2"     ]] && SHUNIT2=/usr/share/shunit2/shunit2
[[ -n "$ZSH_VERSION" ]] && setopt shwordsplit

export PREFIX="$PWD/test/fixtures"
export HOME="$PREFIX/home"
export PATH="$PWD/bin:$PATH"

. ./test/fixtures.sh

test_ruby_engine="${TEST_RUBY_ENGINE:-ruby}"
test_ruby_version="${TEST_RUBY_VERSION:-2.2.5}"
test_ruby_version_x_y="${test_ruby_version%.*}"
test_ruby_api="${TEST_RUBY_API:-${test_ruby_version%.*}.0}"
test_ruby_root="$PWD/test/fixtures/opt/rubies/$test_ruby_engine-$test_ruby_version"

if [[ "$(basename "$0")" != "setup" && ! -d "$test_ruby_root" ]]; then
	echo "$test_ruby_root needs to exist, use test/setup or build a Ruby there"
	exit 2
fi

test_path="$PATH"
test_gem_home="$HOME/.gem/$test_ruby_engine/$test_ruby_version"
test_gem_root="$test_ruby_root/lib/ruby/gems/$test_ruby_api"

. ./share/chruby/chruby.sh
chruby_reset

setUp() { return; }
tearDown() { return; }
oneTimeTearDown() { return; }
