. ./test/helper.sh

function setUp()
{
	test_ruby_path1="/path/to/ruby1"
	test_ruby_path2="/path/to/ruby2"

	RUBIES=("$test_ruby_path1" "$test_ruby_path2")
}

function test_chruby_find_with_exact_name()
{
	local exact_match="${test_ruby_path2##*/}"
	local result="$(chruby_find "$exact_match")"

	assertEquals "did not return the correct ruby dir" \
		     "$test_ruby_path2" "$result"
}

function test_chruby_find_with_exact_name_but_there_are_multiple_matches()
{
	RUBIES=(
		"$test_ruby_path1"
		"${test_ruby_path1}-foo"
		"$test_ruby_path2"
		"${test_ruby_path2}-bar"
	)

	local result="$(chruby_find "${test_ruby_path2##*/}")"

	assertEquals "did not use the exact match first" \
		     "$test_ruby_path2" "$result"
}

function test_chruby_find_with_a_substring()
{
	local result="$(chruby_find "2")"

	assertEquals "did not return the correct ruby dir" \
		     "$test_ruby_path2" "$result"
}

function test_chruby_find_when_there_are_multiple_matches()
{
	local result="$(chruby_find "ruby")"

	assertEquals "did not use the last match" "$test_ruby_path2" "$result"
}

function test_chruby_find_when_cannot_find_match()
{
	local result="$(chruby_find "foo")"

	assertTrue "did not return an empty string" '[[ -z "$result" ]]'
}

SHUNIT_PARENT=$0 . $SHUNIT2
