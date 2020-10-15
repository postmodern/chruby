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

function test_chruby_X_Y()
{
	chruby "$test_ruby_version_x_y" >/dev/null

	assertEquals "did not match $test_ruby_version_x_y" "$test_ruby_root" "$RUBY_ROOT"
}

function test_chruby_multiple_matches()
{
	local fake_ruby="/path/to/ruby-${test_ruby_version_x_y}"

	RUBIES=("$fake_ruby" "$test_ruby_root")

	chruby "${test_ruby_version_x_y}" >/dev/null

	assertEquals "did not use the last match" "$test_ruby_root" "$RUBY_ROOT"
}

function test_chruby_exact_match_first()
{
	RUBIES=("$test_ruby_root" "${test_ruby_root}-rc1")

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

# "chruby ruby" should match "ruby" over "truffleruby"/"jruby"
function test_chruby_match_ruby_first()
{
	local fake_jruby="/path/to/jruby-9.2.13.0"
	local fake_truffle="/path/to/truffleruby-20.2.0"

	# Put the fake ones both at the beginning and the end
	RUBIES=("$fake_jruby" "$fake_truffle" "$test_ruby_root" "$fake_jruby" "$fake_truffle")

	chruby "ruby" >/dev/null

	assertEquals "did not match the standard Ruby first" "$test_ruby_root" "$RUBY_ROOT"
}

# "chruby ruby" should still match "truffleruby" (or "jruby") if it's the only ruby
function test_chruby_match_truffleruby()
{
	local fake_truffle="/path/to/truffleruby-20.2.0"

	RUBIES=("$fake_truffle")

	local expected="chruby: $fake_truffle/bin/ruby not executable"
	local result=$(chruby "ruby" 2>&1) # Captures stdout and stderr

	assertEquals "did not match TruffleRuby" "$expected" "$result"
}

SHUNIT_PARENT=$0 . $SHUNIT2
