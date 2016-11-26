. ./test/helper.sh

function test_chruby_setup_callback_execution()
{
	local should_be_1=''
	function _test_chruby_setup_callback_execution()
	{
		should_be_1=1
		unset -f _test_chruby_setup_callback_execution
	}

	chruby_setup _test_chruby_setup_callback_execution "$test_ruby_root"

	assertEquals "variable definition incorrect" "$should_be_1" 1
}

function test_chruby_setup_callback_env()
{
	function _test_chruby_setup_callback_env()
	{
		assertNotNull "_GEM_HOME was not defined" "$_GEM_HOME"
		assertNotNull "_GEM_PATH was not defined" "$_GEM_PATH"
		assertNotNull "_GEM_ROOT was not defined" "$_GEM_ROOT"
		assertNotNull "_PATH was not defined" "$_PATH"
		assertNotNull "_RUBYOPT was not defined" "$_RUBYOPT"
		assertNotNull "_RUBY_ENGINE was not defined" "$_RUBY_ENGINE"
		assertNotNull "_RUBY_ROOT was not defined" "$_RUBY_ROOT"
		assertNotNull "_RUBY_VERSION was not defined" "$_RUBY_VERSION"

		unset -f _test_chruby_setup_callback_env
	}

	chruby_setup _test_chruby_setup_callback_env "$test_ruby_root" \
		                                     "-I/dummy/lib"
}

function test_chruby_setup_callback_env_persist()
{
	function _test_chruby_setup_callback_env_persist()
	{
		: ; # Nothing to see here, folks.
	}

	chruby_setup _test_chruby_setup_callback_env_persist "$test_ruby_root" \
		                                             "-I/dummy/lib"

	assertNull "_GEM_HOME remains defined" "$_GEM_HOME"
	assertNull "_GEM_PATH remains defined" "$_GEM_PATH"
	assertNull "_GEM_ROOT remains defined" "$_GEM_ROOT"
	assertNull "_PATH remains defined" "$_PATH"
	assertNull "_RUBYOPT remains defined" "$_RUBYOPT"
	assertNull "_RUBY_ENGINE remains defined" "$_RUBY_ENGINE"
	assertNull "_RUBY_ROOT remains defined" "$_RUBY_ROOT"
	assertNull "_RUBY_VERSION remains defined" "$_RUBY_VERSION"
}

function test_chruby_setup_required_parameters()
{
	local expected_msg_preamble='chruby: usage: chruby_setup'
	local actual_msg=''
	local -a arglists=(
		''
		'dummy_callback'
		'dummy_callback dummy_ruby_root dummy_rubyopt extraneous_arg'
	)

	# chruby_setup should carp if it receives fewer than 2 arguments or more
	# than 3.  Note that `$arglist' is unquoted so that the shell expands each
	# string into multiple parameters.
	for arglist in "${arglists[@]}"; do
		actual_msg="$(chruby_setup $arglist 2>&1)"
		assertTrue "did not receive usage error message" \
			   '[[ "$actual_msg" == "$expected_msg_preamble"* ]]'
	done
}

SHUNIT_PARENT=$0 . $SHUNIT2
