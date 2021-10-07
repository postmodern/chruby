test_ruby_engine="${TEST_RUBY_ENGINE:-ruby}"
test_ruby_version="${TEST_RUBY_VERSION:-2.2.5}"
test_ruby_version_x_y="${test_ruby_version%.*}"
test_ruby_root="$test_fixtures_dir/root/opt/rubies/$test_ruby_engine-$test_ruby_version"
test_ruby_api="${TEST_RUBY_API:-${test_ruby_version%.*}.0}"
test_gem_root="$test_ruby_root/lib/ruby/gems/$test_ruby_api"
test_gem_home="$HOME/.gem/$test_ruby_engine/$test_ruby_version"

test_auto_ruby_engine="${TEST_AUTO_RUBY_ENGINE:-ruby}"
test_auto_ruby_version="${TEST_AUTO_RUBY_VERSION:-3.0.0}"
test_auto_ruby_version_x_y="${test_auto_ruby_version%.*}"
test_auto_ruby_root="$test_fixtures_dir/root/opt/rubies/$test_auto_ruby_engine-$test_auto_ruby_version"
test_auto_ruby_api="${TEST_AUTO_RUBY_API:-${test_auto_ruby_version%.*}.0}"
test_auto_gem_root="$test_auto_ruby_root/lib/ruby/gems/$test_auto_ruby_api"
test_auto_gem_home="$HOME/.gem/$test_auto_ruby_engine/$test_auto_ruby_version"

test_rubies=("$test_ruby_root" "$test_auto_ruby_root")
