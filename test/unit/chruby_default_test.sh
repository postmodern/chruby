. ./test/unit/helper.sh

function test_chruby_set_default_ruby()
{
	chruby --default "$test_auto_ruby_version"

	assertEquals "did not set CHRUBY_DEFAULT" "${test_auto_ruby_engine}-${test_auto_ruby_version}" "$CHRUBY_DEFAULT"
}

function test_chruby_set_default_with_unknown_ruby()
{
	chruby --default foo 2>/dev/null

	assertNull "accidentally set CHRUBY_DEFAULT" "$CHRUBY_DEFAULT"
}

function test_chruby_default_when_no_default_ruby_is_set()
{
	chruby "$test_ruby_version"
	chruby default

	assertNull "did not reset the current ruby" "$RUBY_ROOT"
}

function test_chruby_default_when_a_default_ruby_is_set()
{
	chruby --default "$test_auto_ruby_version"
	chruby "$test_ruby_version"
	chruby default

	assertEquals "did not revert back to the default ruby" \
		     "$test_auto_ruby_root" "$RUBY_ROOT"
}

function tearDown()
{
	chruby_reset
	unset CHRUBY_DEFAULT
}

SHUNIT_PARENT=$0 . $SHUNIT2
