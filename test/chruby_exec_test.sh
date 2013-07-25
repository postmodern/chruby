. ./test/helper.sh

setUp()
{
	HOME="$PWD/test/home"
}

test_chruby_exec_no_arguments()
{
	chruby-exec 2>/dev/null

	assertEquals "did not exit with 1" 1 $?
}

test_chruby_exec_no_command()
{
	chruby-exec "$test_ruby_version" 2>/dev/null

	assertEquals "did not exit with 1" 1 $?
}

test_chruby_exec()
{
	local -a command=(ruby -e 'print RUBY_VERSION')
	local ruby_version="$(chruby-exec "$test_ruby_version" -- "${command[@]}")"

	assertEquals "did change the ruby" "$test_ruby_version" "$ruby_version"
}

shunit_parent="$0" . "$shunit2"
