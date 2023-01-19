. ./test/unit/helper.sh

function test_chruby_list_rubies()
{
	local expected="   ${test_ruby_engine}-${test_ruby_version}"
	local output="$(chruby)"

	assertEquals "did not correctly list the rubies in CHRUBY_DIRS" \
		     "$expected" "$output"
}

function test_chruby_list_rubies_when_a_ruby_is_active()
{
	chruby "${test_ruby_engine}-${test_ruby_version}"

	local expected=" * ${test_ruby_engine}-${test_ruby_version}"
	local output="$(chruby)"

	assertEquals "did not correctly list the rubies in CHRUBY_DIRS" \
		     "$expected" "$output"
}

function test_chruby_list_rubies_when_one_contains_a_space()
{
	local ruby_name="ruby with spaces"
	local ruby_dir="$test_home_dir/.rubies/$ruby_name"
	mkdir -p "$ruby_dir"

	local output="$(chruby)"
	local expected="$(cat <<EOS
   ${test_ruby_engine}-${test_ruby_version}
   ${ruby_name}
EOS
)"

	assertEquals "did not correctly handle paths containing spaces" \
		     "$expected" "$output"

	rmdir "$ruby_dir"
}

function test_chruby_with_X_Y()
{
	chruby "$test_ruby_version_x_y" >/dev/null

	assertEquals "did not match $test_ruby_version_x_y" "$test_ruby_root" "$RUBY_ROOT"
}

function test_chruby_with_system()
{
	chruby "$test_ruby_version" >/dev/null
	chruby system

	assertNull "did not reset the Ruby" "$RUBY_ROOT"
}

function test_chruby_with_unknown_ruby()
{
	chruby "does_not_exist" 2>/dev/null

	assertEquals "did not return 1" 1 $?
}

function test_chruby_with_invalid_ruby()
{
	CHRUBY_RUBIES=(/does/not/exist/jruby)

	chruby "jruby" 2>/dev/null

	assertEquals "did not return 1" 1 $?
}

function test_chruby_help()
{
	local usage="usage: chruby [RUBY|VERSION [RUBYOPT...] | system]"
	local output="$(chruby --help)"

	assertEquals "did not output the chruby usage string" \
		     "$usage" "$output"
}

function test_chruby_version()
{
	local output="$(chruby --version)"

	assertEquals "did not output the chruby version" \
		     "chruby: $CHRUBY_VERSION" "$output"
}

function tearDown()
{
	chruby_reset
}

SHUNIT_PARENT=$0 . $SHUNIT2
