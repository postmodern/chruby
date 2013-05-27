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
	RUBIES=(/does/not/exist/jruby)

	chruby "jruby" 2>/dev/null

	assertEquals "did not return 1" 1 $?
}

test_chruby_echo_selected()
{
	local command="source ./test/helper.sh && chruby $TEST_RUBY_VERSION"

	if [[ $SHELL == *bash ]]; then
		local interactive_output=$("$SHELL" -norc -i -c "$command")
		local non_interactive_output=$("$SHELL" -norc -c "$command")
	elif [[ $SHELL == *zsh ]]; then
		local interactive_output=$("$SHELL" -d -i -c "$command")
		local non_interactive_output=$("$SHELL" -d -c "$command")
	else
		fail "Unknown shell '$SHELL'"; startSkipping
	fi

	assertEquals "should have echoed selected ruby" \
		"Using $TEST_RUBY_ENGINE-$TEST_RUBY_VERSION" \
		"$interactive_output"

	assertNull "should not have echoed selected ruby" "$non_interactive_output"
}

SHUNIT_PARENT=$0 . $SHUNIT2
