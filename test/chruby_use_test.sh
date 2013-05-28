. ./test/helper.sh

setUp()
{
	TEST_PATH="$PATH"

	chruby_use $TEST_RUBY_ROOT
}

test_chruby_use()
{
	assertEquals "invalid RUBY_ROOT"    "$TEST_RUBY_ROOT" "$RUBY_ROOT"
	assertEquals "invalid RUBY_ENGINE"  "$TEST_RUBY_ENGINE" "$RUBY_ENGINE"
	assertEquals "invalid RUBY_VERSION" "$TEST_RUBY_VERSION" "$RUBY_VERSION"
	assertEquals "invalid GEM_ROOT"     "$TEST_RUBY_ROOT/lib/ruby/gems/$TEST_RUBY_API" "$GEM_ROOT"
	assertEquals "invalid GEM_HOME"     "$TEST_GEM_HOME" "$GEM_HOME"
	assertEquals "invalid GEM_PATH"     "$GEM_HOME:$GEM_ROOT" "$GEM_PATH"
	assertEquals "invalid PATH"         "$TEST_GEM_HOME/bin:$TEST_GEM_ROOT/bin:$TEST_RUBY_ROOT/bin:$TEST_PATH" "$PATH"

	assertEquals "could not find ruby in $PATH" "$TEST_RUBY_ROOT/bin/ruby" `which ruby`
}

test_chruby_use_echo_selected_in_non_interactive_mode()
{
	local command=". ./test/helper.sh && chruby_use $TEST_RUBY_ROOT"

	if [[ $(basename "$SHELL") == bash ]]; then
		local output=$("$SHELL" -norc -c "$command")
	elif [[ $(basename "$SHELL") == zsh ]]; then
		local output=$("$SHELL" -d -f -c "$command")
	else
		fail "Unknown shell '$SHELL'"; startSkipping
	fi

	assertNull "should not have echoed selected ruby" "$output"
}

tearDown()
{
	chruby_reset
}

SHUNIT_PARENT=$0 . $SHUNIT2
