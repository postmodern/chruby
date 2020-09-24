. ./test/helper.sh

function setUp()
{
	original_rubies=("${RUBIES[@]}")
}

function tearDown()
{
	chruby_reset

	RUBIES=("${original_rubies[@]}")
}

function test_chruby_list_rubies()
{
	local expected="   ${test_ruby_engine}-${test_ruby_version}"
	local output="$(chruby)"

	assertEquals "did not correctly list RUBIES" \
		     "$expected" "$output"
}

function test_chruby_list_rubies_when_a_ruby_is_active()
{
	chruby "${test_ruby_engine}-${test_ruby_version}"

	local expected=" * ${test_ruby_engine}-${test_ruby_version}"
	local output="$(chruby)"

	assertEquals "did not correctly list RUBIES" \
		     "$expected" "$output"
}

function test_chruby_list_RUBIES_when_one_contains_a_space()
{
	local ruby_name="ruby"
	local path_with_spaces="/path/with spaces/$ruby_name"

	RUBIES=("$path_with_spaces")
	local output="$(chruby)"

	assertEquals "did not correctly handle paths containing spaces" \
		     "   $ruby_name" "$output"
}

function test_chruby_X_Y()
{
	chruby "$test_ruby_version_x_y" >/dev/null

	assertEquals "did not match $test_ruby_version_x_y" "$test_ruby_root" "$RUBY_ROOT"
}

function test_chruby_multiple_matches()
{
	local fake_ruby="/path/to/ruby-${test_ruby_version_x_y}"

	RUBIES=("$fake_ruby" "$test_ruby_root")

	chruby "${test_ruby_version_x_y}" >/dev/null

	assertEquals "did not use the last match" "$test_ruby_root" "$RUBY_ROOT"
}

function test_chruby_exact_match_first()
{
	RUBIES=("$test_ruby_root" "${test_ruby_root}-rc1")

	chruby "${test_ruby_root##*/}"

	assertEquals "did not use the exact match" "$test_ruby_root" "$RUBY_ROOT"
}

function test_chruby_system()
{
	chruby "$test_ruby_version" >/dev/null
	chruby system

	assertNull "did not reset the Ruby" "$RUBY_ROOT"
}

function test_chruby_unknown()
{
	chruby "does_not_exist" 2>/dev/null

	assertEquals "did not return 1" 1 $?
}

function test_chruby_invalid_ruby()
{
	RUBIES=(/does/not/exist/jruby)

	chruby "jruby" 2>/dev/null

	assertEquals "did not return 1" 1 $?
}

function test_chruby_reload()
{
	RUBIES=()

	chruby --reload

	assertEquals "did not return 1" 1 $?
	assertEquals "did not re-populate RUBIES" 1 ${#RUBIES[@]}
	assertEquals "did not detect rubies in \$PREFIX/opt/rubies" \
		     "$test_ruby_root" "${RUBIES[0]}"
}

SHUNIT_PARENT=$0 . $SHUNIT2
