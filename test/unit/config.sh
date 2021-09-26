if [[ -n "$TEST_RUBY_ROOT" ]]; then
	test_ruby_root="${TEST_RUBY_ROOT}"

	# query the ruby for it's engine, version, etc.
	eval "$(RUBYGEMS_GEMDEPS="" "$test_ruby_root/bin/ruby" - <<EOF
puts "test_ruby_engine=#{Object.const_defined?(:RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'};"
puts "test_ruby_version=#{RUBY_VERSION};"
puts "test_ruby_api=#{RbConfig::CONFIG["ruby_version"]};"
begin; require 'rubygems'; puts "test_gem_root=#{Gem.default_dir.inspect};"; rescue LoadError; end
EOF
)"
else
	test_ruby_engine="${TEST_RUBY_ENGINE:-ruby}"
	test_ruby_version="${TEST_RUBY_VERSION:-2.2.5}"
	test_ruby_root="$test_fixtures_dir/root/opt/rubies/$test_ruby_engine-$test_ruby_version"
	test_ruby_api="${TEST_RUBY_API:-${test_ruby_version%.*}.0}"
	test_gem_root="$test_ruby_root/lib/ruby/gems/$test_ruby_api"
fi

test_ruby_version_x_y="${test_ruby_version%.*}"

test_gem_home="$HOME/.gem/rubies/$test_ruby_engine-$test_ruby_version"
