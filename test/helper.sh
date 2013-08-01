[[ -z "$SHUNIT2"     ]] && SHUNIT2=/usr/share/shunit2/shunit2
[[ -n "$ZSH_VERSION" ]] && setopt shwordsplit

export PATH="$PWD/bin:$PATH"
export HOME="$PWD/test/home"

. ./share/chruby/chruby.sh
chruby_reset

test_ruby_engine="ruby"
test_ruby_version="1.9.3"
test_ruby_patchlevel="429"
test_ruby_api="1.9.1"
test_ruby_root="$PWD/test/rubies/$test_ruby_engine-$test_ruby_version-p$test_ruby_patchlevel"

test_path="$PATH"
test_gem_home="$HOME/.gem/$test_ruby_engine/$test_ruby_version"
test_gem_root="$test_ruby_root/lib/ruby/gems/$test_ruby_api"

test_project_dir="$PWD/test/project"

RUBIES=($test_ruby_root)

setUp() { return; }
tearDown() { return; }
oneTimeTearDown() { return; }
