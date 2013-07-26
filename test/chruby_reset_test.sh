. ./test/helper.sh

setUp()
{
	chruby_use "$test_ruby_root" >/dev/null

	PATH="$GEM_HOME/bin:$GEM_ROOT/bin:$RUBY_ROOT/bin:$test_path"
	export PATH
}

test_chruby_reset()
{
	chruby_reset

	assertNull "RUBY_ROOT was not unset"     "$RUBY_ROOT"
	assertNull "RUBY_ENGINE was not unset"   "$RUBY_ENGINE"
	assertNull "RUBY_VERSION was not unset"  "$RUBY_VERSION"
	assertNull "RUBYOPT was not unset"       "$RUBYOPT"
	assertNull "GEM_HOME was not unset"      "$GEM_HOME"
	assertNull "GEM_PATH was not unset"      "$GEM_PATH"

	assertEquals "PATH was not sanitized"    "$test_path" "$PATH"
}

test_chruby_reset_duplicate_path()
{
	PATH="$PATH:$GEM_HOME/bin:$GEM_ROOT/bin:$RUBY_ROOT/bin"
	export PATH

	chruby_reset

	assertEquals "PATH was not sanitized"    "$test_path" "$PATH"
}

test_chruby_reset_modified_gem_path()
{
	local gem_dir="$HOME/gems"

	GEM_PATH="$GEM_PATH:$gem_dir"
	export GEM_PATH

	chruby_reset

	assertEquals "GEM_PATH was unset" "$gem_dir" "$GEM_PATH"
}

test_chruby_reset_no_gem_root_or_gem_home()
{
	GEM_HOME="" GEM_ROOT="" PATH="$test_path:/bin"
	export GEM_HOME GEM_ROOT PATH

	chruby_reset

	assertEquals "PATH was messed up" "$test_path:/bin" "$PATH"
}

SHUNIT_PARENT="$0" . "$shunit2"
