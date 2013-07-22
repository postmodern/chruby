. ./share/chruby/install.sh
. ./test/helper.sh

test_chruby_reload()
{
	local new_ruby="$HOME/.rubies/newly_installed_ruby"
	mkdir -p "$new_ruby"

	chruby_reload

	assertTrue "did not add the new ruby dir to RUBIES" \
	           '[[ "${RUBIES[*]}" == *$new_ruby* ]]'

	rmdir "$new_ruby"
}

SHUNIT_PARENT=$0 . $SHUNIT2
