. ./test/helper.sh

test_chruby_exec_no_arguments()
{
	chruby-exec 2>/dev/null

	assertEquals "did not exit with 1" 1 $?
}

test_chruby_exec_no_command()
{
	chruby-exec "$TEST_RUBY_VERSION" 2>/dev/null

	assertEquals "did not exit with 1" 1 $?
}

test_chruby_exec()
{
	local command="echo \$RUBY_ROOT"
	local ruby_root=$(chruby-exec "$TEST_RUBY_VERSION-p$TEST_RUBY_PATCHLEVEL" -- $command)

	assertEquals "did not change the ruby" "$TEST_RUBY_ROOT" "$ruby_root"
}

SHUNIT_PARENT=$0 . $SHUNIT2
