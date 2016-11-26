. ./test/helper.sh

function setUp()
{
	chruby_use $test_ruby_root >/dev/null
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

function test_chruby_use_cache_population()
{
	chruby_reset

	local dummy_gem_home="/tmp/dummy/.gem/2.3.0"
	local dummy_gem_path="/tmp/dummy/.gem/2.3.0:/opt/dummy/gems/2.3.0"

	export GEM_HOME="$dummy_gem_home"
	export GEM_PATH="$dummy_gem_path"

	chruby_use $test_ruby_root >/dev/null

	assertEquals "did not cache correct ADDED_PATH" \
		     "${CHRUBY_CACHE[ADDED_PATH]}" \
		     "$test_gem_home/bin:$test_gem_root/bin:$test_ruby_root/bin"

	assertEquals "did not cache correct CHRUBY_GEM_HOME" \
		     "${CHRUBY_CACHE[CHRUBY_GEM_HOME]}" "$test_gem_home"

	assertEquals "did not cache correct CHRUBY_GEM_PATH" \
		     "${CHRUBY_CACHE[CHRUBY_GEM_PATH]}" \
		     "$test_gem_home:$test_gem_root:$dummy_gem_path"

	assertEquals "did not cache correct GEM_HOME" "${CHRUBY_CACHE[GEM_HOME]}" \
		     "$dummy_gem_home"

	assertEquals "did not cache correct GEM_PATH" "${CHRUBY_CACHE[GEM_PATH]}" \
		     "$dummy_gem_path"

	assertEquals "did not cache correct PATH" "${CHRUBY_CACHE[PATH]}" \
		     "$__shunit_tmpDir:$test_path"

	unset -v GEM_HOME GEM_PATH
}

function tearDown()
{
	chruby_reset
}

SHUNIT_PARENT=$0 . $SHUNIT2
