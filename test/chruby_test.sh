. ./test/helper.sh

function setUp()
{
	original_rubies=(${RUBIES[@]})
}

function tearDown()
{
	chruby_reset

	RUBIES=(${original_rubies[@]})
}

function test_chruby_default_RUBIES()
{
	assertEquals "did not correctly populate RUBIES" \
		     "$test_ruby_root" \
		     "${RUBIES[*]}"
}

function test_chruby_major_minor()
{
	chruby "$test_ruby_major_minor" >/dev/null

	assertEquals "did not match $test_ruby_major_minor" "$test_ruby_root" "$RUBY_ROOT"
}

function test_chruby_multiple_matches()
{
	RUBIES=(/path/to/ruby-$test_ruby_major_minor "$test_ruby_root")

	chruby "$test_ruby_major_minor" >/dev/null

	assertEquals "did not use the last match" "$test_ruby_root" "$RUBY_ROOT"
}

function test_chruby_exact_match_first()
{
	RUBIES=("$test_ruby_root" "$test_ruby_root-rc1")

	chruby "${test_ruby_root##*/}"

	assertEquals "did not use the exact match" "$test_ruby_root" "$RUBY_ROOT"
}

function test_chruby_system()
{
	chruby "$test_ruby_version" >/dev/null
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
