[[ -z "$RUBIES" ]] && RUBIES=()

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
	unset RUBY_API_VERSION
}

function chruby_use()
{
	[[ -n "$RUBY_PATH" ]] && chruby_reset

	export PATH="$1/bin:$PATH" && hash -r
	export RUBYOPT="$2"

	eval $(ruby -e "require 'rbconfig'; puts \"RUBY_ENGINE=#{defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'}\"; puts \"RUBY_VERSION=#{RUBY_VERSION}\"; puts \"RUBY_API_VERSION=#{RbConfig::CONFIG['ruby_version']}\"")

	export RUBY_PATH="$1"

	if [[ ! $UID -eq 0 ]]; then
		export GEM_HOME="$HOME/.gem/$RUBY_ENGINE/$RUBY_VERSION"
		export GEM_PATH="$RUBY_PATH/lib/ruby/gems/$RUBY_API_VERSION"

		export PATH="$GEM_HOME/bin:$GEM_PATH/bin:$PATH"
		export GEM_PATH="$GEM_HOME:$GEM_PATH"
	fi
}

function chruby()
{
	local ruby_path

	case "$1" in
		-h|--help)
			echo "usage: chruby [RUBY|VERSION|system] [RUBY_OPTS]"
			;;
		"")
			for ruby_path in ${RUBIES[@]}; do
				if [[ "$ruby_path" == "$RUBY_PATH" ]]; then
					echo -n " * "
				else
					echo -n "   "
				fi

				echo `basename "$ruby_path"`
			done
			;;
		system) chruby_reset ;;
		*)
			for ruby_path in ${RUBIES[@]}; do
				if [[ `basename "$ruby_path"` == *$1* ]]; then
					shift
					chruby_use "$ruby_path" "$*"
					return
				fi
			done

			echo "Unknown Ruby: $1"
			return 1
			;;
	esac
}
