[[ -z "$RUBIES" ]] && RUBIES=()

function chruby_reset()
{
	[[ -z "$RUBY" ]] && return

	export PATH=`sed -e "s|$RUBY/bin:||g" <<< $PATH`
	unset RUBY RUBYOPT

	if [[ -n "$GEM_HOME" ]] && [[ -n "$GEM_ROOT" ]]; then
		export PATH=`sed -e "s|$GEM_HOME/bin:||g; s|$GEM_ROOT/bin:||g" <<< $PATH`
		unset GEM_ROOT GEM_HOME GEM_PATH
	fi

	hash -r
}

function chruby_use()
{
	[[ "$RUBY" == "$1" ]] && return
	[[ -n "$RUBY" ]] && chruby_reset

	export RUBY="$1"
	export RUBYOPT="$2"
	export PATH="$RUBY/bin:$PATH"

	eval `ruby - <<EOF
require 'rubygems'
puts "RUBY_ENGINE=#{defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'}"
puts "RUBY_VERSION=#{RUBY_VERSION}"
puts "GEM_ROOT=\"#{Gem.default_dir}\""
EOF`

	if [[ ! $UID -eq 0 ]]; then
		export GEM_HOME="$HOME/.gem/$RUBY_ENGINE/$RUBY_VERSION"
		export GEM_PATH="$GEM_HOME:$GEM_ROOT"
		export PATH="$GEM_HOME/bin:$GEM_ROOT/bin:$PATH"
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
				if [[ "$ruby_path" == "$RUBY" ]]; then
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
