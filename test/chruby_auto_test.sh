#!/bin/sh

. ./share/chruby/auto.sh
. ./test/helper.sh

PROJECT_DIR="$PWD/test/project"

setUp()
{
	chruby_reset
	unset RUBY_VERSIONED_DIR
}

test_chruby_auto_enter_project_dir()
{
	cd "$PROJECT_DIR" && chruby_auto

	assertEquals "did not switch Ruby when entering a versioned directory" \
		     "$TEST_RUBY" "$RUBY"
}

test_chruby_auto_enter_subdir_directly()
{
	cd "$PROJECT_DIR/dir1/dir2" && chruby_auto

	assertEquals "did not switch Ruby when directly entering a sub-directory of a versioned directory" \
		     "$TEST_RUBY" "$RUBY"
}

test_chruby_auto_enter_subdir()
{
	cd "$PROJECT_DIR" && chruby_auto
	cd dir1/dir2      && chruby_auto

	assertEquals "did not keep the current Ruby when entering a sub-dir" \
		     "$TEST_RUBY" "$RUBY"
}

test_chruby_auto_leave_project_dir()
{
	cd "$PROJECT_DIR" && chruby_auto
	cd dir1/dir2
	cd ../../..       && chruby_auto

	assertNull "did not reset the Ruby when leaving a versioned directory" \
		   "$RUBY"
}

SHUNIT_PARENT=$0 . $SHUNIT2
