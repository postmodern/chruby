CHRUBY_VERSION="0.3.9"
RUBIES=()

for dir in "$PREFIX/opt/rubies" "$HOME/.rubies"; do
	[[ -d "$dir" && -n "$(ls -A "$dir")" ]] && RUBIES+=("$dir"/*)
done
unset dir

function chruby_reset()
{
	[[ -z "$RUBY_ROOT" ]] && return

	PATH=":$PATH:"; PATH="${PATH//:$RUBY_ROOT\/bin:/:}"

	if (( $UID != 0 )); then
		[[ -n "$GEM_HOME" ]] && PATH="${PATH//:$GEM_HOME\/bin:/:}"
		[[ -n "$GEM_ROOT" ]] && PATH="${PATH//:$GEM_ROOT\/bin:/:}"

		GEM_PATH=":$GEM_PATH:"
		[[ -n "$GEM_HOME" ]] && GEM_PATH="${GEM_PATH//:$GEM_HOME:/:}"
		[[ -n "$GEM_ROOT" ]] && GEM_PATH="${GEM_PATH//:$GEM_ROOT:/:}"
		GEM_PATH="${GEM_PATH#:}"; GEM_PATH="${GEM_PATH%:}"
		unset GEM_ROOT GEM_HOME
		[[ -z "$GEM_PATH" ]] && unset GEM_PATH
	fi

	PATH="${PATH#:}"; PATH="${PATH%:}"
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

	typeset unset RUBYGEMS_GEMDEPS

	eval "$("$RUBY_ROOT/bin/ruby" - <<EOF
puts "export RUBY_ENGINE=#{defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'};"
puts "export RUBY_VERSION=#{RUBY_VERSION};"
begin; require 'rubygems'; puts "export GEM_ROOT=#{Gem.default_dir.inspect};"; rescue LoadError; end
EOF
)"

	if (( $UID != 0 )); then
		export GEM_HOME="$HOME/.gem/$RUBY_ENGINE/$RUBY_VERSION"
		export GEM_PATH="$GEM_HOME${GEM_ROOT:+:$GEM_ROOT}${GEM_PATH:+:$GEM_PATH}"
		export PATH="$GEM_HOME/bin${GEM_ROOT:+:$GEM_ROOT/bin}:$PATH"
	fi
}

function chruby_ruby_select()
{
	local dir
	for dir in "${RUBIES[@]}"; do
		dir="${dir%%/}"
		case "${dir##*/}" in
			"$1") matched_ruby="$dir" && break;;
			ruby-"$1"*) matched_ruby="$dir";;
			"$1"*) matched_ruby="$dir";;
		esac
	done
}


function chruby()
{
	case "$1" in
		-h|--help)
			echo "usage: chruby [RUBY|VERSION|system] [RUBYOPT...]"
			;;
		-V|--version)
			echo "chruby: $CHRUBY_VERSION"
			;;
		"")
			local dir star
			for dir in "${RUBIES[@]}"; do
				dir="${dir%%/}"
				if [[ "$dir" == "$RUBY_ROOT" ]]; then star="*"
				else                                  star=" "
				fi

				echo " $star ${dir##*/}"
			done
			;;
		system) chruby_reset ;;
		*)
			local matched_ruby
			chruby_ruby_select "$1"

			if [[ -z "$matched_ruby" ]]; then
				echo "chruby: unknown Ruby: $1" >&2
				return 1
			fi

			shift
			chruby_use "$matched_ruby" "$*"
			;;
	esac
}
