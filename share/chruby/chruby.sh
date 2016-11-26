CHRUBY_VERSION="0.3.9"

RUBIES=()

declare -A CHRUBY_CACHE
CHRUBY_CACHE=()

for dir in "$PREFIX/opt/rubies" "$HOME/.rubies"; do
	[[ -d "$dir" && -n "$(ls -A "$dir")" ]] && RUBIES+=("$dir"/*)
done
unset dir

function chruby_reset()
{
	[[ -z "$RUBY_ROOT" ]] && return

	if [[ -x "$RUBY_ROOT/bin/ruby" ]]; then
		function _chruby_reset()
		{
			function chruby_warn_changed_var()
			{
				local var="${1:?variable name is required}"
				local cleanup_message="${2:-doing best-effort cleanup}"

				printf >&2 -- 'chruby: %s has changed since switching to %s; %s\n' \
					"$var" "${RUBY_ROOT##*/}" "$cleanup_message"
			}

			[[ "$PATH" == "$_PATH"* ]] || chruby_warn_changed_var PATH

			PATH=":$PATH:"
			PATH="${PATH/:$_PATH:}"

			[[ "$GEM_PATH" == "$_GEM_PATH"* ]] || chruby_warn_changed_var GEM_PATH

			GEM_PATH=":$GEM_PATH:"
			GEM_PATH="${GEM_PATH/:$_GEM_PATH:}"

			if [[ "$GEM_HOME" == "$_GEM_HOME" ]]; then
				unset GEM_HOME
			else
				chruby_warn_changed_var GEM_HOME 'leaving as-is'
			fi

			GEM_PATH="${GEM_PATH#:}"; GEM_PATH="${GEM_PATH%:}"
			PATH="${PATH#:}"; PATH="${PATH%:}"

			export GEM_PATH PATH

			[[ -z "$GEM_PATH" ]] && unset GEM_PATH

			unset -f _chruby_reset chruby_warn_changed_var
		}
	else
		function _chruby_reset()
		{
			PATH=":$PATH:"; PATH="${PATH/:$RUBY_ROOT\/bin:/:}"
			[[ -n "$GEM_ROOT" ]] && PATH="${PATH/:$GEM_ROOT\/bin:/:}"

			if (( UID != 0 )); then
				[[ -n "$GEM_HOME" ]] && PATH="${PATH/:$GEM_HOME\/bin:/:}"

				GEM_PATH=":$GEM_PATH:"
				[[ -n "$GEM_HOME" ]] && GEM_PATH="${GEM_PATH/:$GEM_HOME:/:}"
				[[ -n "$GEM_ROOT" ]] && GEM_PATH="${GEM_PATH/:$GEM_ROOT:/:}"
				GEM_PATH="${GEM_PATH#:}"; GEM_PATH="${GEM_PATH%:}"

				unset GEM_HOME
				[[ -z "$GEM_PATH" ]] && unset GEM_PATH
			fi

			PATH="${PATH#:}"; PATH="${PATH%:}"
			unset -f _chruby_reset
		}
	fi

	chruby_setup _chruby_reset "$RUBY_ROOT"
	unset RUBY_ROOT RUBY_ENGINE RUBY_VERSION RUBYOPT GEM_ROOT
	hash -r
}

function chruby_use()
{
	[[ -n "$RUBY_ROOT" ]] && chruby_reset

	if [[ ! -x "$1/bin/ruby" ]]; then
		echo "chruby: $1/bin/ruby not executable" >&2
		return 1
	fi

	function _chruby_use()
	{
		export GEM_HOME="$_GEM_HOME"
		export GEM_PATH="$_GEM_PATH"
		export GEM_ROOT="$_GEM_ROOT"
		# Special case - _PATH augments rather than replaces PATH
		export PATH="$_PATH${PATH:+:$PATH}"
		export RUBYOPT="$_RUBYOPT"
		export RUBY_ENGINE="$_RUBY_ENGINE"
		export RUBY_ROOT="$_RUBY_ROOT"
		export RUBY_VERSION="$_RUBY_VERSION"

		hash -r

		unset -f _chruby_use
	}

	chruby_setup _chruby_use "$@"
}

function chruby_setup()
{
	if (( $# < 2 )) || (( $# > 3 )); then
		echo "chruby: usage: chruby_setup CALLBACK RUBY_ROOT [RUBYOPT]" 1>&2
		echo "	arguments were: $*"
		return 1
	fi

	local callback="$1"
	local _RUBY_ROOT="$2"
	local _RUBYOPT="$3"

	# Short-circuit if the requested ruby doesn't exist
	if [[ ! -x "$_RUBY_ROOT/bin/ruby" ]]; then
		"$callback"
		return $?
	fi

	local _PATH="$_RUBY_ROOT/bin"

	eval "$(RUBYGEMS_GEMDEPS="" RUBYOPT="$_RUBYOPT" PATH="$_PATH:$PATH" "$_RUBY_ROOT/bin/ruby" - <<EOF
puts "local _RUBY_ENGINE=#{Object.const_defined?(:RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'};"
puts "local _RUBY_VERSION=#{RUBY_VERSION};"
begin; require 'rubygems'; puts "local _GEM_ROOT=#{Gem.default_dir.inspect};"; rescue LoadError; end
EOF
)"

	if [[ -n "$_GEM_ROOT" ]]; then
		_PATH="$_GEM_ROOT/bin:$_PATH"
	fi

	local _GEM_HOME='' _GEM_PATH=''
	if (( UID != 0 )); then
		_GEM_HOME="$HOME/.gem/$_RUBY_ENGINE/$_RUBY_VERSION"

		for gem_path_to_add in "$_GEM_ROOT" "$_GEM_HOME"; do
			if [[ -n "$gem_path_to_add" ]]; then
				_GEM_PATH="${gem_path_to_add}${_GEM_PATH:+:$_GEM_PATH}"
			fi
		done

		_PATH="$_GEM_HOME/bin:$_PATH"
	fi

	"$callback"
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
			local dir ruby
			for dir in "${RUBIES[@]}"; do
				dir="${dir%%/}"; ruby="${dir##*/}"
				if [[ "$dir" == "$RUBY_ROOT" ]]; then
					echo " * ${ruby} ${RUBYOPT}"
				else
					echo "  ${ruby}"
				fi

			done
			;;
		system) chruby_reset ;;
		*)
			local dir ruby match
			for dir in "${RUBIES[@]}"; do
				dir="${dir%%/}"; ruby="${dir##*/}"
				case "$ruby" in
					"$1")	match="$dir" && break ;;
					*"$1"*)	match="$dir" ;;
				esac
			done

			if [[ -z "$match" ]]; then
				echo "chruby: unknown Ruby: $1" >&2
				return 1
			fi

			shift
			chruby_use "$match" "$*"
			;;
	esac
}
