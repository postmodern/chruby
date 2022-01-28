. ./test/unit/helper.sh

function setUp()
{
	chruby_use "$test_ruby_root" >/dev/null

	export PATH="$GEM_HOME/bin:$GEM_ROOT/bin:$RUBY_ROOT/bin:$original_path"
}

function test_chruby_reset_hash_table()
{
	if [[ -n "$ZSH_VERSION" ]]; then
		chruby_reset

		assertEquals "did not clear the path table" \
			     "" "$(hash)"
	elif [[ -n "$BASH_VERSION" ]]; then
		local old_lang="$LANG"
		export LANG=en_US.UTF-8
		chruby_reset

		assertEquals "did not clear the path table" \
			     "hash: hash table empty" "$(hash)"

		LANG="$old_lang"
	fi
}

function test_chruby_reset_env_variables()
{
	chruby_reset

	assertNull "RUBY_ROOT was not unset"     "$RUBY_ROOT"
	assertNull "RUBY_ENGINE was not unset"   "$RUBY_ENGINE"
	assertNull "RUBY_VERSION was not unset"  "$RUBY_VERSION"
	assertNull "RUBYOPT was not unset"       "$RUBYOPT"
	assertNull "GEM_HOME was not unset"      "$GEM_HOME"
	assertNull "GEM_PATH was not unset"      "$GEM_PATH"

	assertEquals "PATH was not sanitized"    "$original_path" "$PATH"
}

function test_chruby_reset_duplicate_path()
{
	export PATH="$PATH:$GEM_HOME/bin:$GEM_ROOT/bin:$RUBY_ROOT/bin"

	chruby_reset

	assertEquals "PATH was not sanitized"    "$original_path" "$PATH"
}

function test_chruby_reset_modified_gem_path()
{
	local gem_dir="$HOME/gems"

	export GEM_PATH="$GEM_PATH:$gem_dir"

	chruby_reset

	assertEquals "GEM_PATH was unset" "$gem_dir" "$GEM_PATH"
}

function test_chruby_reset_no_gem_root_or_gem_home()
{
	export GEM_HOME=""
	export GEM_ROOT=""
	export PATH="$original_path:/bin"

	chruby_reset

	assertEquals "PATH was messed up" "$original_path:/bin" "$PATH"
}

SHUNIT_PARENT=$0 . $SHUNIT2
