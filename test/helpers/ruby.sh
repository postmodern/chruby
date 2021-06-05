test_ruby_engine="${TEST_RUBY_ENGINE:-ruby}"
test_ruby_version="${TEST_RUBY_VERSION:-2.2.5}"
test_ruby_version_x_y="${test_ruby_version%.*}"
test_ruby_api="${TEST_RUBY_API:-${test_ruby_version%.*}.0}"
test_ruby_root="$PWD/test/fixtures/opt/rubies/$test_ruby_engine-$test_ruby_version"

test_gem_home="$HOME/.gem/$test_ruby_engine/$test_ruby_version"
test_gem_root="$test_ruby_root/lib/ruby/gems/$test_ruby_api"
