. ./test/helper.sh

tearDown()
{
	chruby_reset
}

test_chruby_1_9()
{
	chruby "1.9"

	assertEquals "did not match 1.9" "$TEST_RUBY_ROOT" "$RUBY_ROOT"
}

test_chruby_system()
{
	chruby "$TEST_RUBY_VERSION"
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
	RUBIES="/does/not/exist/jruby"

	chruby "jruby" 2>/dev/null

	assertEquals "did not return 1" 1 $?
}

test_chruby_does_not_output_globs()
{
	RUBIES="/unsuccessful/glob/*"

	local output=$(chruby)

	assertEquals "did not filter the glob pattern out" "" "$output"
}

test_chruby_expands_globs_at_runtime()
{
	local rubies_dir="$HOME/.rubies"
	local fake_ruby="ruby-0.0.0-p0"

	RUBIES="$rubies_dir/*"

	local output=$(chruby)

	assertFalse "should not already have the fake ruby" "[[ \"$output\" =~ \"   $fake_ruby\" ]]"

	mkdir -p "$rubies_dir/$fake_ruby"

	local output=$(chruby)

	assertTrue "should expand globs at runtime" "[[ \"$output\" =~ \"   $fake_ruby\" ]]"

	rmdir "$rubies_dir/$fake_ruby"
}

SHUNIT_PARENT=$0 . $SHUNIT2
