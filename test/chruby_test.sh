. ./test/helper.sh

tearDown()
{
	chruby_reset
}

test_chruby_1_9()
{
	chruby "1.9" >/dev/null

	assertEquals "did not match 1.9" "$TEST_RUBY_ROOT" "$RUBY_ROOT"
}

test_chruby_multiple_matches()
{
	RUBIES=(/path/to/ruby-1.9.0 "$TEST_RUBY_ROOT")

	chruby "1.9" >/dev/null

	assertEquals "did not use the last match" "$TEST_RUBY_ROOT" "$RUBY_ROOT"
}

test_chruby_system()
{
	chruby "$TEST_RUBY_VERSION" >/dev/null
	chruby system

	assertNull "did not reset the Ruby" "$RUBY_ROOT"
}

test_chruby_previous()
{
	chruby "$test_ruby_version" >/dev/null
	chruby system >/dev/null
	chruby -

	assertEquals "did not switch to previous" "$test_ruby_root" "$RUBY_ROOT"

	chruby - >/dev/null

	assertNull "did not reset the Ruby" "$RUBY_ROOT"
}

test_chruby_previous_without_prior_switch()
{
	unset OLD_RUBY_ROOT
	chruby - 2>/dev/null

	assertEquals "did not return 0" 0 $?
}

test_chruby_unknown()
{
	chruby "foo" 2>/dev/null

	assertEquals "did not return 1" 1 $?
}

test_chruby_invalid_ruby()
{
	RUBIES=(/does/not/exist/jruby)

	chruby "jruby" 2>/dev/null

	assertEquals "did not return 1" 1 $?
}

SHUNIT_PARENT=$0 . $SHUNIT2
