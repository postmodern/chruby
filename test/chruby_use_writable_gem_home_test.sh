. ./test/helper.sh

function setUp()
{
	chruby_use $test_ruby_root >/dev/null
}

function tearDown()
{
	chruby_reset
}

function test_chruby_clears_hash_table()
{
	assertClearPathTable
}

function test_chruby_use_env_variables()
{
	assertEquals "invalid RUBY_ROOT"    "$test_ruby_root" "$RUBY_ROOT"
	assertEquals "invalid RUBY_ENGINE"  "$test_ruby_engine" "$RUBY_ENGINE"
	assertEquals "invalid RUBY_VERSION" "$test_ruby_version" "$RUBY_VERSION"
	assertEquals "invalid GEM_ROOT"     "$test_ruby_root/lib/ruby/gems/$test_ruby_api" "$GEM_ROOT"
	assertNull "GEM_HOME should not be set" "$GEM_HOME"
	assertNull "GEM_PATH should not be set" "$GEM_PATH"
	assertEquals "invalid PATH"         "$test_gem_root/bin:$test_ruby_root/bin:$__shunit_tmpDir:$test_path" "$PATH"

	assertEquals "could not find ruby in $PATH" \
		     "$test_ruby_root/bin/ruby" \
		     "$(command -v ruby)"
}

SHUNIT_PARENT=$0 . $SHUNIT2
