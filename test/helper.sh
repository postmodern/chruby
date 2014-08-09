[[ -z "$SHUNIT2"     ]] && SHUNIT2=/usr/share/shunit2/shunit2
[[ -n "$ZSH_VERSION" ]] && setopt shwordsplit

export PREFIX="$PWD/test"
export HOME="$PREFIX/home"
export PATH="$PWD/bin:$PATH"

. ./share/chruby/chruby.sh
chruby_reset

test_ruby_engine="ruby"
test_ruby_version="2.0.0"
test_ruby_patchlevel="353"
test_ruby_api="2.0.0"
test_ruby_dir="$PWD/test/opt/rubies"
test_ruby_root="$test_ruby_dir/$test_ruby_engine-$test_ruby_version-p$test_ruby_patchlevel"
test_rubies_order="jruby-1.7.9 jruby-1.7.14 rbx-2.2.9 rbx-2.2.10 rbx-10.0.0 ruby-1.9.3-p547 ruby-1.9.3-preview1 ruby-1.9.3-rc1 ruby-2.0.0-p0 ruby-2.0.0-p195 ruby-2.0.0-p247 ruby-2.0.0-p353"

test_path="$PATH"
test_gem_home="$HOME/.gem/$test_ruby_engine/$test_ruby_version"
test_gem_root="$test_ruby_root/lib/ruby/gems/$test_ruby_api"

test_project_dir="$PWD/test/project"

setUp() { return; }
tearDown() { return; }
oneTimeTearDown() { return; }
