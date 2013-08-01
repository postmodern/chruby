. ./test/helper.sh

function tearDown()
{
	chruby_reset
}

function test_chruby_1_9()
{
	chruby "1.9" >/dev/null

	assertEquals "did not match 1.9" "$TEST_RUBY_ROOT" "$RUBY_ROOT"
}

function test_chruby_multiple_matches()
{
	RUBIES=(/path/to/ruby-1.9.0 "$TEST_RUBY_ROOT")

	chruby "1.9" >/dev/null

	assertEquals "did not use the last match" "$TEST_RUBY_ROOT" "$RUBY_ROOT"
}

function test_chruby_system()
{
	chruby "$TEST_RUBY_VERSION" >/dev/null
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

SHUNIT_PARENT=$0 . $SHUNIT2
