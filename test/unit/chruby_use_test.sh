. ./test/unit/helper.sh

function test_chruby_clears_hash_table()
{
	if [[ -n "$ZSH_VERSION" ]]; then
		chruby_use "$test_ruby_root" >/dev/null

		assertEquals "did not clear the path table" \
			     "" "$(hash)"
	elif [[ -n "$BASH_VERSION" ]]; then
		export LANG=en_US.UTF-8
		chruby_use "$test_ruby_root" >/dev/null

		assertEquals "did not clear the path table" \
			     "hash: hash table empty" "$(hash)"

		unset LANG
	fi
}

function test_chruby_use_env_variables()
{
	chruby_use "$test_ruby_root" >/dev/null

	assertEquals "invalid RUBY_ROOT"    "$test_ruby_root" "$RUBY_ROOT"
	assertEquals "invalid RUBY_ENGINE"  "$test_ruby_engine" "$RUBY_ENGINE"
	assertEquals "invalid RUBY_VERSION" "$test_ruby_version" "$RUBY_VERSION"
	assertEquals "invalid GEM_ROOT"     "$test_ruby_root/lib/ruby/gems/$test_ruby_api" "$GEM_ROOT"
	assertEquals "invalid GEM_HOME"     "$test_gem_home" "$GEM_HOME"
	assertEquals "invalid GEM_PATH"     "$GEM_HOME:$GEM_ROOT" "$GEM_PATH"
	assertEquals "invalid PATH"         "$test_gem_home/bin:$test_gem_root/bin:$test_ruby_root/bin:$__shunit_tmpDir:$original_path" "$PATH"

	assertEquals "could not find ruby in $PATH" \
		     "$test_ruby_root/bin/ruby" \
		     "$(command -v ruby)"
}

function tearDown()
{
	chruby_reset
}

SHUNIT_PARENT=$0 . $SHUNIT2
