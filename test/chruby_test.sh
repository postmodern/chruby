#!/usr/share/shunit2/shunit2

. ./test/helper.sh

function tearDown()
{
	chruby_reset
}

function test_chruby_1_9()
{
	chruby "1.9"

	assertEquals "did not match $TEST_RUBY with 1.9" "$TEST_RUBY" "$RUBY"
}

function test_chruby_system()
{
	chruby "$TEST_RUBY_VERSION"
	chruby system

	assertNull "did not reset the Ruby" "$RUBY"
}
