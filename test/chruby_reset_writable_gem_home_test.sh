. ./test/helper.sh

function setUp()
{
	chruby_use "$test_ruby_root" >/dev/null

	export PATH="$RUBY_ROOT/bin:$test_path"
}

function test_chruby_reset_hash_table()
{
	chruby_reset
	assertClearPathTable
}

function test_chruby_reset_env_variables()
{
	chruby_reset
	assertAllUnset
	assertEquals "PATH was not sanitized"    "$test_path" "$PATH"
}

function test_chruby_reset_duplicate_path()
{
	export PATH="$PATH:$GEM_ROOT/bin:$RUBY_ROOT/bin"
	chruby_reset
	assertEquals "PATH was not sanitized"    "$test_path" "$PATH"
}

SHUNIT_PARENT=$0 . $SHUNIT2
