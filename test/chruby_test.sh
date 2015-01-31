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

function test_chruby_2_0()
{
	chruby "2.0" >/dev/null

	assertEquals "did not match 2.0" "$test_ruby_root" "$RUBY_ROOT"
}

function test_chruby_multiple_matches()
{
	RUBIES=(/path/to/ruby-2.0.0 "$test_ruby_root")

	chruby "2.0" >/dev/null

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

function test_chruby_ruby_select_by_major_minor()
{
	RUBIES=(
		/opt/rubies/ruby-2.0.0-p100
		/opt/rubies/ruby-2.1.0
		/opt/rubies/ruby-2.2.0
		/opt/rubies/ruby-2.2.1
	)

	chruby_ruby_select "2.0"
	assertEquals "did not match major.minor" "/opt/rubies/ruby-2.0.0-p100" "$matched_ruby"

	chruby_ruby_select "2.1"
	assertEquals "did not match major.minor" "/opt/rubies/ruby-2.1.0" "$matched_ruby"
}

function test_chruby_ruby_select_by_implementation()
{
	RUBIES=(
		/opt/rubies/ruby-2.2.10
		/opt/rubies/rbx-2.2.10
	)

	chruby_ruby_select "rbx"
	assertEquals "did not match by implementation" "/opt/rubies/rbx-2.2.10" "$matched_ruby"
}

function test_chruby_ruby_select_exact()
{
	RUBIES=(
		/opt/rubies/2.1.0
		/opt/rubies/ruby-2.1.0
		/opt/rubies/ruby-2.1.1
	)

	chruby_ruby_select "ruby-2.1.0"
	assertEquals "did not match exact" "/opt/rubies/ruby-2.1.0" "$matched_ruby"
}

function test_chruby_ruby_select_last()
{
	RUBIES=(
		/opt/rubies/ruby-1.9.3-p100
		/opt/rubies/ruby-1.9.3-p200
	)

	chruby_ruby_select "1.9.3"
	assertEquals "did not match last version listed" "/opt/rubies/ruby-1.9.3-p200" "$matched_ruby"
}

SHUNIT_PARENT=$0 . $SHUNIT2
