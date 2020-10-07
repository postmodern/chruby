. ./test/unit/helper.sh

function test_chruby_init_with_clean_env()
{
	unset CHRUBY_RUBIES
	chruby_init

	assertEquals "did not reset CHRUBY_RUBIES" 1 ${#CHRUBY_RUBIES[@]}
	assertEquals "did not detect rubies in \$PREFIX/opt/rubies" \
		     "$test_ruby_root" "${CHRUBY_RUBIES[0]}"
}

function test_chruby_init_with_modified_env()
{
	local new_path="/path/to/new/ruby"

	chruby_init
	CHRUBY_RUBIES+=("$new_path")

	chruby_init

	assertEquals "did not reset CHRUBY_RUBIES" "" "${CHRUBY_RUBIES[1]}"
}

SHUNIT_PARENT=$0 . $SHUNIT2
