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
			chruby --version
			;;
		*)
			if [[ ! $(type -t ruby-install) ]]; then
				echo "Aborting, ruby-install not found ..."
				return 1
			fi

			ruby-install $@

			chruby_reload
			;;
	esac
}
