. ./share/chruby/auto.sh
. ./test/helper.sh

test_dir="$PWD"
project_dir="$PWD/test/project"

function setUp()
{
	chruby_reset
	unset ruby_auto_version
}

function test_chruby_auto_loaded_in_zsh()
{
	[[ -n "$ZSH_VERSION" ]] || return

	assertEquals "did not add chruby_auto to preexec_functions" \
		     "chruby_auto" \
		     "$preexec_functions"
}

function test_chruby_auto_loaded_in_bash()
{
	[[ -n "$BASH_VERSION" ]] || return

	local output="$("$SHELL" -c ". ./share/chruby/auto.sh && trap -p DEBUG")"

	assertTrue "did not add a trap hook for chruby_auto" \
		   '[[ "$output" == *chruby_auto* ]]'
}

function test_chruby_auto_loaded_twice_in_zsh()
{
	[[ -n "$ZSH_VERSION" ]] || return

	. ./share/chruby/auto.sh

	assertNotEquals "should not add chruby_auto twice" \
		        "$preexec_functions" \
			"chruby_auto chruby_auto"
}

function test_chruby_auto_loaded_twice()
{
	ruby_version_file="dirty"
	PROMPT_COMMAND="chruby_auto"

	. ./share/chruby/auto.sh

	assertNull "ruby_auto_version was not unset" "$ruby_auto_version"
}

function test_chruby_auto_enter_project_dir()
{
	cd "$project_dir" && chruby_auto

	assertEquals "did not switch Ruby when entering a versioned directory" \
		     "$test_ruby_root" "$ruby_root"
}

function test_chruby_auto_enter_subdir_directly()
{
	cd "$project_dir/sub_dir" && chruby_auto

	assertEquals "did not switch Ruby when directly entering a sub-directory of a versioned directory" \
		     "$test_ruby_root" "$ruby_root"
}

function test_chruby_auto_enter_subdir()
{
	cd "$project_dir" && chruby_auto
	cd sub_dir        && chruby_auto

	assertEquals "did not keep the current Ruby when entering a sub-dir" \
		     "$test_ruby_root" "$ruby_root"
}

function test_chruby_auto_enter_subdir_with_ruby_version()
{
	cd "$project_dir" && chruby_auto
	cd sub_versioned/ && chruby_auto

	assertNull "did not switch the Ruby when leaving a sub-versioned directory" \
		   "$ruby_root"
}

function test_chruby_auto_modified_ruby_version()
{
	cd "$project_dir/modified_version" && chruby_auto
	echo "1.9.3" > .ruby-version       && chruby_auto

	assertEquals "did not detect the modified .ruby-version file" \
		     "$test_ruby_root" "$ruby_root"
}

function test_chruby_auto_overriding_ruby_version()
{
	cd "$project_dir" && chruby_auto
	chruby system     && chruby_auto

	assertNull "did not override the Ruby set in .ruby-version" "$ruby_root"
}

function test_chruby_auto_leave_project_dir()
{
	cd "$project_dir"    && chruby_auto
	cd "$project_dir/.." && chruby_auto

	assertNull "did not reset the Ruby when leaving a versioned directory" \
		   "$ruby_root"
}

function test_chruby_auto_invalid_ruby_version()
{
	local expected_auto_version
	read -r expected_auto_version < "$project_dir/bad/.ruby-version"

	cd "$project_dir" && chruby_auto
	cd bad/           && chruby_auto 2>/dev/null

	assertEquals "did not keep the current Ruby when loading an unknown version" \
		     "$test_ruby_root" "$ruby_root"
	assertEquals "did not set RUBY_AUTO_VERSION" \
		     "$expected_auto_version" "$ruby_auto_version"
}

function tearDown()
{
	cd "$test_dir"
}

SHUNIT_PARENT="$0" . "$shunit2"
