. ./share/chruby/auto.sh
. ./test/helper.sh

PROJECT_DIR="$PWD/test/project"

setUp()
{
	chruby_reset
	unset RUBY_VERSION_FILE
}

test_chruby_auto_setting_blank_PROMPT_COMMAND()
{
	if [[ -n "$BASH_VERSION" ]]; then
		PROMPT_COMMAND=""
		. ./share/chruby/auto.sh

		assertEquals "has syntax error" \
			     "chruby_auto" \
			     "$PROMPT_COMMAND"
	fi
}

test_chruby_auto_setting_PROMPT_COMMAND_with_semicolon()
{
	if [[ -n "$BASH_VERSION" ]]; then
		PROMPT_COMMAND="update_terminal_cwd;"
		. ./share/chruby/auto.sh

		assertEquals "did not remove tailing ';'" \
			     "update_terminal_cwd; chruby_auto" \
			     "$PROMPT_COMMAND"
	fi
}

test_chruby_auto_setting_PROMPT_COMMAND_with_semicolon_and_whitespace()
{
	if [[ -n "$BASH_VERSION" ]]; then
		PROMPT_COMMAND="update_terminal_cwd;  "
		. ./share/chruby/auto.sh
	
		assertEquals "did not remove tailing ';' and whitespace" \
			     "update_terminal_cwd; chruby_auto" \
			     "$PROMPT_COMMAND"
	fi
}

test_chruby_auto_loaded_twice()
{
	RUBY_VERSION_FILE="dirty"
	PROMPT_COMMAND="chruby_auto"

	. ./share/chruby/auto.sh

	if [[ -n "$ZSH_VERSION" ]]; then
		assertNotEquals "should not add chruby_auto twice" \
			        "$precmd_functions" \
				"chruby_auto chruby_auto"
	elif [[ -n "$BASH_VERSION" ]]; then
		assertNotEquals "should not add chruby_auto twice" \
			        "$PROMPT_COMMAND" \
		                "chruby_auto; chruby_auto"
	fi

	assertNull "RUBY_VERSION_FILE was not unset" "$RUBY_VERSION_FILE"
}

test_chruby_auto_enter_project_dir()
{
	cd "$PROJECT_DIR" && chruby_auto

	assertEquals "did not switch Ruby when entering a versioned directory" \
		     "$TEST_RUBY_ROOT" "$RUBY_ROOT"
}

test_chruby_auto_enter_subdir_directly()
{
	cd "$PROJECT_DIR/sub_dir" && chruby_auto

	assertEquals "did not switch Ruby when directly entering a sub-directory of a versioned directory" \
		     "$TEST_RUBY_ROOT" "$RUBY_ROOT"
}

test_chruby_auto_enter_subdir()
{
	cd "$PROJECT_DIR" && chruby_auto
	cd sub_dir        && chruby_auto

	assertEquals "did not keep the current Ruby when entering a sub-dir" \
		     "$TEST_RUBY_ROOT" "$RUBY_ROOT"
}

test_chruby_auto_enter_subdir_with_ruby_version()
{
	cd "$PROJECT_DIR" && chruby_auto
	cd sub_versioned/ && chruby_auto

	assertNull "did not switch the Ruby when leaving a sub-versioned directory" \
		   "$RUBY_ROOT"
}

test_chruby_auto_overriding_ruby_version()
{
	cd "$PROJECT_DIR" && chruby_auto
	chruby system     && chruby_auto

	assertNull "did not override the Ruby set in .ruby-version" "$RUBY_ROOT"
}

test_chruby_auto_leave_project_dir()
{
	cd "$PROJECT_DIR"    && chruby_auto
	cd "$PROJECT_DIR/.." && chruby_auto

	assertNull "did not reset the Ruby when leaving a versioned directory" \
		   "$RUBY_ROOT"
}

test_chruby_auto_invalid_ruby_version()
{
	cd "$PROJECT_DIR" && chruby_auto
	cd bad/           && chruby_auto 2>/dev/null

	assertEquals "did not keep the current Ruby when loading an unknown version" \
		     "$TEST_RUBY_ROOT" "$RUBY_ROOT"
}

tearDown()
{
	chruby_reset
	unset RUBY_VERSION_FILE
}

SHUNIT_PARENT=$0 . $SHUNIT2
