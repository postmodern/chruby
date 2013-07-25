. ./test/helper.sh

setUp()
{
	test_path="$PATH"

	chruby_use "$test_ruby_root" >/dev/null
}

test_chruby_use()
{
	assertEquals "invalid RUBY_ROOT"    "$test_ruby_root" "$RUBY_ROOT"
	assertEquals "invalid RUBY_ENGINE"  "$test_ruby_engine" "$RUBY_ENGINE"
	assertEquals "invalid RUBY_VERSION" "$test_ruby_version" "$RUBY_VERSION"
	assertEquals "invalid GEM_ROOT"     "$test_ruby_root/lib/ruby/gems/$test_ruby_api" "$GEM_ROOT"
	assertEquals "invalid GEM_HOME"     "$test_gem_home" "$GEM_HOME"
	assertEquals "invalid GEM_PATH"     "$GEM_HOME:$GEM_ROOT" "$GEM_PATH"
	assertEquals "invalid PATH"         "$test_gem_home/bin:$test_gem_root/bin:$test_ruby_root/bin:$test_path" "$PATH"

	which_ruby="$(type -p ruby)"
	which_ruby="${which##* }"
	assertEquals "could not find ruby in $PATH" "$test_ruby_root/bin/ruby" "$which_ruby"
}

tearDown()
{
	chruby_reset
}

shunit_parent="$0" . "$shunit2"
