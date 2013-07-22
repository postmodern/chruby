. ./share/chruby/install.sh
. ./test/helper.sh

test_chruby_install_version()
{
	assertTrue "did not print the chruby version" \
		   '[[ `chruby-install --version` == *$CHRUBY_VERSION* ]]'
}

SHUNIT_PARENT=$0 . $SHUNIT2
