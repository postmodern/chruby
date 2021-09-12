. ./test/helper.sh

function test_chruby_exec_no_arguments()
{
	chruby-exec 2>/dev/null

	assertEquals "did not exit with 1" 1 $?
}

function test_chruby_exec_no_command()
{
	chruby-exec "$test_ruby_version" 2>/dev/null

	assertEquals "did not exit with 1" 1 $?
}

function test_chruby_exec()
{
	local ruby_version=$(chruby-exec "$test_ruby_version" -- ruby -e "print RUBY_VERSION")

	assertEquals "did change the ruby" "$test_ruby_version" "$ruby_version"
}

function test_chruby_exec()
{
	# Check to ensure that chruby-exec execs, not forks
	if [ -n "$ZSH_VERSION" ] ; then
		local checks=$(
			echo $$
			chruby-exec ${test_ruby_version} -- ruby -e "puts Process.ppid"
		)
	else
		# We need to check this way because $$ does not return the pid of the subprocess in bash
		local checks=$(
			echo $BASHPID
			bin/chruby-exec ${test_ruby_version} -- ruby -e "puts Process.ppid"
		)
	fi

	assertEquals "did not exec the ruby shell command in-pace" ${checks[@]}
}

function test_chruby_exec_with_version()
{
	local output=$(chruby-exec --version)

	assertEquals "did not output the correct version" \
		     "chruby version $CHRUBY_VERSION" \
		     "$output"
}

SHUNIT_PARENT=$0 . $SHUNIT2
