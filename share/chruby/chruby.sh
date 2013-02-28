CHRUBY_VERSION="0.3.3"

RUBIES=()
[[ -d /opt/rubies/    ]] && RUBIES+=(/opt/rubies/*)
[[ -d "$HOME/.rubies" ]] && RUBIES+=("$HOME"/.rubies/*)

function chruby_reset()
{
	[[ -z "$RUBY_ROOT" ]] && return

	export PATH=":$PATH:"; export PATH=${PATH//:$RUBY_ROOT\/bin:/:}

	if [[ ! $UID -eq 0 ]]; then
		export PATH=${PATH//:$GEM_HOME\/bin:/:}
		export PATH=${PATH//:$GEM_ROOT\/bin:/:}

		export GEM_PATH=":$GEM_PATH:"
		export GEM_PATH=${GEM_PATH//:$GEM_HOME:/:}
		export GEM_PATH=${GEM_PATH//:$GEM_ROOT:/:}
		export GEM_PATH=${GEM_PATH#:}; export GEM_PATH=${GEM_PATH%:}
		unset GEM_ROOT GEM_HOME
	fi

	export PATH=${PATH#:}; export PATH=${PATH%:}
	unset RUBY_ROOT RUBY_ENGINE RUBY_VERSION RUBYOPT
	hash -r
}

function chruby_use()
{
	if [[ ! -x "$1/bin/ruby" ]]; then
		echo "chruby: $1/bin/ruby not executable" >&2
		return 1
	fi

	[[ -n "$RUBY_ROOT" ]] && chruby_reset

	export RUBY_ROOT="$1"
	export RUBYOPT="$2"
	export PATH="$RUBY_ROOT/bin:$PATH"

	eval `$RUBY_ROOT/bin/ruby - <<EOF
require 'rubygems'
puts "export RUBY_ENGINE=#{defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'};"
puts "export RUBY_VERSION=#{RUBY_VERSION};"
puts "export GEM_ROOT=#{Gem.default_dir.inspect};"
EOF`

	if [[ ! $UID -eq 0 ]]; then
		export GEM_HOME="$HOME/.gem/$RUBY_ENGINE/$RUBY_VERSION"
		export GEM_PATH="$GEM_HOME:$GEM_ROOT${GEM_PATH:+:}${GEM_PATH:-}"
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
		-v|--version)
			echo "chruby version $CHRUBY_VERSION"
			;;
		"")
			local star

			for dir in ${RUBIES[@]}; do
				if [[ "$dir" == "$RUBY_ROOT" ]]; then star="*"
				else                                  star=" "
				fi

				echo " $star $(basename "$dir")"
			done
			;;
		system) chruby_reset ;;
		*)
			for dir in ${RUBIES[@]}; do
				if [[ `basename "$dir"` == *$1* ]]; then
					shift
					chruby_use "$dir" "$*"
					return $?
				fi
			done

			echo "chruby: unknown Ruby: $1" >&2
			return 1
			;;
	esac
}
