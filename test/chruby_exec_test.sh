. ./test/helper.sh

function setUp()
{
	export HOME="$PWD/test/home"
}

function test_chruby_exec_no_arguments()
{
	chruby-exec 2>/dev/null

	assertEquals "did not exit with 1" 1 $?
}

function test_chruby_exec_no_command()
{
	chruby-exec "$TEST_RUBY_VERSION" 2>/dev/null

	assertEquals "did not exit with 1" 1 $?
}

function test_chruby_exec()
{
	local command="ruby -e 'print RUBY_VERSION'"
	local ruby_version=$(chruby-exec "$TEST_RUBY_VERSION" -- $command)

	assertEquals "did change the ruby" "$TEST_RUBY_VERSION" "$ruby_version"
}

SHUNIT_PARENT=$0 . $SHUNIT2
