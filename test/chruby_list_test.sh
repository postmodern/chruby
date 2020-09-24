. ./test/helper.sh

function setUp()
{
	test_rubies=("${RUBIES[@]}")
}

function test_chruby_list()
{
	local path1="/path/to/ruby1"
	local path2="/path/to/ruby2"
	local expected="$(echo "$path1"; echo "$path2")"

	RUBIES=("$path1" "$path2")

	local output="$(chruby_list)"

	assertEquals "did not output the expected ruby paths" \
		     "$expected" "$output"
}

function tearDown()
{
	RUBIES=("${test_rubies[@]}")
}

SHUNIT_PARENT=$0 . $SHUNIT2
