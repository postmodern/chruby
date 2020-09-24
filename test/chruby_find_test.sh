. ./test/helper.sh

function test_chruby_find_with_exact_name()
{
	local exact_match="${test_ruby_root##*/}"
	local result="$(chruby_find "$exact_match")"

	assertEquals "did not return the correct ruby dir" \
		     "$test_ruby_root" "$result"
}

function test_chruby_find_with_a_substring()
{
	local substring="$test_ruby_version"
	local result="$(chruby_find "$substring")"

	assertEquals "did not return the correct ruby dir" \
		     "$test_ruby_root" "$result"
}

function test_chruby_find_when_cannot_find_match()
{
	local result="$(chruby_find "foo")"

	assertTrue "did not return an empty string" '[[ -z "$result" ]]'
}

SHUNIT_PARENT=$0 . $SHUNIT2
