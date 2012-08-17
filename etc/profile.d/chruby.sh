RUBIES=()

function chruby_reset()
{
	[[ -z "$RUBY_PATH" ]] && return

	export PATH=`sed -e "s|$RUBY_PATH\/[^:]*:||g; s|$HOME\/.gem\/[^:]*:||g" <<< $PATH` && hash -r
	unset RUBYOPT
	unset GEM_HOME
	unset GEM_PATH
	unset RUBY_PATH
	unset RUBY_ENGINE
	unset RUBY_VERSION
}

function chruby_use()
{
	[[ -n "$RUBY_PATH" ]] && chruby_reset

	export PATH="$1/bin:$PATH" && hash -r
	export RUBYOPT="$2"

	local ruby_version=( `ruby -e "require 'rbconfig'; puts defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'; puts RUBY_VERSION; puts RbConfig::CONFIG['ruby_version']"` )

	export RUBY_PATH="$1"
	export RUBY_ENGINE=${ruby_version[0]}
	export RUBY_VERSION=${ruby_version[1]}

	if [[ ! $UID -eq 0 ]]; then
		export GEM_HOME="$HOME/.gem/$RUBY_ENGINE/$RUBY_VERSION"
		export GEM_PATH="$RUBY_PATH/lib/ruby/gems/${ruby_version[2]}"

		export PATH="$GEM_HOME/bin:$GEM_PATH/bin:$PATH"
		export GEM_PATH="$GEM_HOME:$GEM_PATH"
	fi
}

function chruby()
{
	local ruby_dir

	case "$1" in
		-h|--help)
			echo "usage: chruby [RUBY|VERSION|system] [RUBY_OPTS]"
			;;
		"")
			for ruby_dir in ${RUBIES[@]}; do
				if [[ "$ruby_dir" == "$RUBY_PATH" ]]; then
					echo -n " * "
				else
					echo -n "   "
				fi

				echo `basename "$ruby_dir"`
			done
			;;
		system) chruby_reset ;;
		*)
			for ruby_dir in ${RUBIES[@]}; do
				if [[ `basename "$ruby_dir"` == *$1* ]]; then
					chruby_use "$ruby_dir" "${*:2}"
					return
				fi
			done

			echo "Unknown Ruby: $1"
			return 1
			;;
	esac
}
