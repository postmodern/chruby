. ./test/helper.sh

function setUpPATH()
{
	export PATH="$GEM_HOME/bin:$GEM_ROOT/bin:$RUBY_ROOT/bin:$test_path"
}

function setUp()
{
	chruby_use "$test_ruby_root" >/dev/null
	setUpPATH
}

function with_bad_ruby() {
	export RUBY_ROOT="/tmp/tmp.${RANDOM}"
	setUpPATH
	"$@"
}

function test_chruby_reset_hash_table()
{
	if [[ -n "$BASH_VERSION" ]]; then
		assertEquals "did not clear the path table" \
			     "hash: hash table empty" "$(hash)"
	elif [[ -n "$ZSH_VERSION" ]]; then
		assertEquals "did not clear the path table" \
			     "" "$(hash)"
	fi
}

function test_chruby_reset_hash_table_with_bad_ruby()
{
	with_bad_ruby test_chruby_reset_hash_table
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

	assertEquals "PATH was not sanitized"    "$test_path" "$PATH"
}

function test_chruby_reset_env_variables_with_bad_ruby()
{
	with_bad_ruby test_chruby_reset_env_variables
}

function test_chruby_reset_duplicate_path()
{
	duplicated_path="$GEM_HOME/bin:$GEM_ROOT/bin:$RUBY_ROOT/bin"
	expected_path="$test_path:$duplicated_path"
	export PATH="$PATH:$duplicated_path"

	chruby_reset

	assertEquals "PATH was not sanitized"    "$expected_path" "$PATH"
}

function test_chruby_reset_duplicate_path_with_bad_ruby()
{
	with_bad_ruby test_chruby_reset_duplicate_path
}

function test_chruby_reset_modified_gem_path()
{
	local gem_dir="$HOME/gems"

	export GEM_PATH="$GEM_PATH:$gem_dir"

	chruby_reset

	assertEquals "GEM_PATH was unset" "$gem_dir" "$GEM_PATH"
}

function test_chruby_reset_modified_gem_path_with_bad_ruby()
{
	with_bad_ruby test_chruby_reset_modified_gem_path
}

function test_chruby_reset_no_gem_root_or_gem_home()
{
	export GEM_HOME=""
	export GEM_ROOT=""
	export PATH="$test_path:/bin"

	chruby_reset

	assertEquals "PATH was messed up" "$test_path:/bin" "$PATH"
}

function test_chruby_reset_no_gem_root_or_gem_home_with_bad_ruby()
{
	with_bad_ruby test_chruby_reset_no_gem_root_or_gem_home
}

function test_chruby_reset_no_remove_existing_path_element()
{
	chruby_reset

	for path_elt in "$GEM_HOME/bin" "$GEM_ROOT/bin" "$RUBY_ROOT/bin"; do
		assertTrue "Existing PATH member \`$path_elt' was removed" \
			   '[[ ":$PATH:" == *":$path_elt:"* ]]'
	done
}

function test_chruby_reset_no_remove_existing_path_element_with_bad_ruby()
{
	with_bad_ruby test_chruby_reset_no_remove_existing_path_element
}

SHUNIT_PARENT=$0 . $SHUNIT2
