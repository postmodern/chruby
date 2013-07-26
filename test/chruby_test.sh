. ./test/helper.sh

tearDown()
{
	chruby_reset
}

test_chruby_1_9()
{
	chruby "1.9" >/dev/null

	assertEquals "did not match 1.9" "$test_ruby_root" "$RUBY_ROOT"
}

test_chruby_multiple_matches()
{
	rubies=(/path/to/ruby-1.9.0 "$test_ruby_root")

	chruby "1.9" >/dev/null

	assertEquals "did not use the last match" "$test_ruby_root" "$RUBY_ROOT"
}

test_chruby_system()
{
	chruby "$test_ruby_version" >/dev/null
	chruby system

	assertNull "did not reset the Ruby" "$RUBY_ROOT"
}

test_chruby_unknown()
{
	chruby "foo" 2>/dev/null

	assertEquals "did not return 1" 1 $?
}

test_chruby_invalid_ruby()
{
	rubies=(/does/not/exist/jruby)

	chruby "jruby" 2>/dev/null

	assertEquals "did not return 1" 1 $?
}

SHUNIT_PARENT="$0" . "$shunit2"
