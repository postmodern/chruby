. ./test/helper.sh

function setUp()
{
	chruby_use "$test_ruby_root" >/dev/null
}

function test_chruby_clears_hash_table()
{
	if [[ -n "$BASH_VERSION" ]]; then
		assertEquals "did not clear the path table" \
			     "hash: hash table empty" "$(hash)"
	elif [[ -n "$ZSH_VERSION" ]]; then
		assertEquals "did not clear the path table" \
			     "" "$(hash)"
	fi
}

function test_chruby_use_with_invalid_ruby_path()
{
	chruby_use "/path/to/fake/ruby" 2>/dev/null

	assertEquals "did not return an error code" 1 $?
}

function test_chruby_use_env_variables()
{
	assertEquals "invalid RUBY_ROOT"    "$test_ruby_root" "$RUBY_ROOT"
	assertEquals "invalid RUBY_ENGINE"  "$test_ruby_engine" "$RUBY_ENGINE"
	assertEquals "invalid RUBY_VERSION" "$test_ruby_version" "$RUBY_VERSION"
	assertEquals "invalid GEM_ROOT"     "$test_ruby_root/lib/ruby/gems/$test_ruby_api" "$GEM_ROOT"
	assertEquals "invalid GEM_HOME"     "$test_gem_home" "$GEM_HOME"
	assertEquals "invalid GEM_PATH"     "$GEM_HOME:$GEM_ROOT" "$GEM_PATH"
	assertEquals "invalid PATH"         "$test_gem_home/bin:$test_gem_root/bin:$test_ruby_root/bin:$__shunit_tmpDir:$test_path" "$PATH"

	assertEquals "could not find ruby in $PATH" \
		     "$test_ruby_root/bin/ruby" \
		     "$(command -v ruby)"
}

function tearDown()
{
	chruby_reset
}

SHUNIT_PARENT=$0 . $SHUNIT2
