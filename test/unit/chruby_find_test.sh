. ./test/unit/helper.sh

function setUp()
{
	test_ruby1="ruby1"
	test_ruby2="ruby2"

	test_ruby_path1="${test_root_dir}/opt/rubies/${test_ruby1}"
	test_ruby_path2="${test_home_dir}/.rubies/${test_ruby2}"

	mkdir -p "$test_ruby_path1"
	mkdir -p "$test_ruby_path2"
}

function test_chruby_find_with_exact_name()
{
	local exact_match="${test_ruby2}"
	local result="$(chruby_find "$exact_match")"

	assertEquals "did not return the correct ruby dir" \
		     "$test_ruby_path2" "$result"
}

function test_chruby_find_with_exact_name_but_there_are_multiple_matches()
{
	mkdir -p "${test_root_dir}${test_ruby_path1}-foo"
	mkdir -p "${test_home_dir}${test_ruby_path2}-bar"

	local result="$(chruby_find "$test_ruby2")"

	assertEquals "did not use the exact match first" \
		     "$test_ruby_path2" "$result"

	rmdir "${test_root_dir}${test_ruby_path1}-foo"
	rmdir  "${test_home_dir}${test_ruby_path2}-bar"
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

	assertEquals "did not return an empty string" "" "$result"
}

function tearDown()
{
	rmdir "${test_ruby_path1}"
	rmdir "${test_ruby_path2}"
}

SHUNIT_PARENT=$0 . $SHUNIT2
