CHRUBY_VERSION="0.3.7"

function chruby_reload()
{
	RUBIES=(
	  `find "$PREFIX"/opt/rubies -mindepth 1 -maxdepth 1 -type d 2>/dev/null`
	  `find "$HOME"/.rubies -mindepth 1 -maxdepth 1 -type d 2>/dev/null`
	)
}

function chruby-install()
{
	case "$1" in
		-h|--help)
			echo "usage: chruby-install [OPTIONS] [RUBY [VERSION]] [-- CONFIGURE_OPTS ...]"
			;;
		-V|--version)
			echo "chruby version $CHRUBY_VERSION"
			;;
		*)
			if [[ ! -x $(which ruby-install) ]]; then
				echo "Aborting, ruby-install not found ..."
				return 1
			fi

			ruby-install $@

			chruby_reload
			;;
	esac
}
