#!/bin/sh

. ./test/helper.sh

tearDown()
{
	__chruby_reset
}

test___chruby_1_9()
{
	chruby "1.9"

	assertEquals "did not match $TEST_RUBY with 1.9" "$TEST_RUBY" "$RUBY"
}

test___chruby_system()
{
	chruby "$TEST_RUBY_VERSION"
	chruby system

	assertNull "did not reset the Ruby" "$RUBY"
}

test___chruby_unknown()
{
	chruby "foo" 2>/dev/null

	assertEquals "did not return 1" $? 1
}

SHUNIT_PARENT=$0 . /usr/share/shunit2/shunit2
