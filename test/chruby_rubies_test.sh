. ./test/helper.sh

function setUp()
{
	original_rubies=("${RUBIES[@]}")
}

function test_chruby_rubies()
{
	local path1="/path/to/ruby1"
	local path2="/path/to/ruby2"
	local expected="$(echo "$path1"; echo "$path2")"

	RUBIES=("$path1" "$path2")

	local output="$(chruby_rubies)"

	assertEquals "did not output the expected ruby paths" \
		     "$expected" "$output"
}

function tearDown()
{
	RUBIES=("${original_rubies[@]}")
}

SHUNIT_PARENT=$0 . $SHUNIT2
