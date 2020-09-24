. ./test/helper.sh

function test_chruby_init_with_clean_env()
{
	unset RUBIES
	chruby_init

	assertEquals "did not reset RUBIES" 1 ${#RUBIES[@]}
	assertEquals "did not detect rubies in \$PREFIX/opt/rubies" \
		     "$test_ruby_root" "${RUBIES[0]}"
}

function test_chruby_init_with_modified_env()
{
	local new_path="/path/to/new/ruby"

	chruby_init
	RUBIES+=("$new_path")

	chruby_init

	assertEquals "did not reset RUBIES" "" "${RUBIES[1]}"
}

SHUNIT_PARENT=$0 . $SHUNIT2
