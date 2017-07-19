CHRUBY_VERSION="0.3.9"

RUBIES=()

unset -v CHRUBY_CACHE
declare -A CHRUBY_CACHE
CHRUBY_CACHE=()

for dir in "$PREFIX/opt/rubies" "$HOME/.rubies"; do
	[[ -d "$dir" && -n "$(ls -A "$dir")" ]] && RUBIES+=("$dir"/*)
done
unset dir

function chruby_reset()
{
	[[ -z "$RUBY_ROOT" ]] && return

	function chruby_cache_exists()
	{
		[[ -n "${CHRUBY_CACHE[$1]+x}" ]]
	}

	function chruby_cache_matches()
	{
		[[ "${CHRUBY_CACHE[$1]}" == "$2" ]]
	}

	function chruby_warn_changed_var()
	{
		local var="${1:?variable name is required}"
		shift
		local cleanup_message="${1:-doing best-effort cleanup}"

		printf >&2 -- 'chruby: %s has changed since switching to %s; %s\n' \
			"$var" "${RUBY_ROOT##*/}" "$cleanup_message"
	}

	if chruby_cache_exists CHRUBY_PATH; then
		if chruby_cache_matches CHRUBY_PATH "$PATH"; then
			PATH="${CHRUBY_CACHE[PATH]}"
		else
			chruby_warn_changed_var PATH
			PATH=":$PATH:"
			PATH="${PATH/:${CHRUBY_CACHE[ADDED_PATH]}:}"
		fi
	fi

	if chruby_cache_exists CHRUBY_GEM_PATH; then
		if chruby_cache_matches CHRUBY_GEM_PATH "$GEM_PATH"; then
			GEM_PATH="${CHRUBY_CACHE[GEM_PATH]}"
		else
			chruby_warn_changed_var GEM_PATH
			GEM_PATH=":$GEM_PATH:"
			GEM_PATH="${GEM_PATH/:${CHRUBY_CACHE[ADDED_GEM_PATH]}:}"
		fi
	fi

	if chruby_cache_exists CHRUBY_GEM_HOME; then
		if chruby_cache_matches CHRUBY_GEM_HOME "$GEM_HOME"; then
			GEM_HOME="${CHRUBY_CACHE[GEM_HOME]}"
		else
			chruby_warn_changed_var GEM_HOME 'leaving as-is'
		fi
	fi

	GEM_PATH="${GEM_PATH#:}"; GEM_PATH="${GEM_PATH%:}"
	PATH="${PATH#:}"; PATH="${PATH%:}"

	export GEM_HOME GEM_PATH PATH

	[[ -z "$GEM_HOME" ]] && unset GEM_HOME
	[[ -z "$GEM_PATH" ]] && unset GEM_PATH

	unset RUBY_ROOT RUBY_ENGINE RUBY_VERSION RUBYOPT GEM_ROOT

	unset -f chruby_cache_exists chruby_cache_matches chruby_warn_changed_var

	CHRUBY_CACHE=()

	hash -r
}

function chruby_use()
{
	if [[ ! -x "$1/bin/ruby" ]]; then
		echo "chruby: $1/bin/ruby not executable" >&2
		return 1
	fi

	[[ -n "$RUBY_ROOT" ]] && chruby_reset

	function chruby_unshift_cache()
	{
		local key="$1"
		local value="$2"

		if [[ -z "$key" ]]; then
			echo "chruby: cache key required" >&2
			return 1
		elif [[ -z "$value" ]]; then
			return
		fi

		if (( $# > 2 )); then
			local stored="${CHRUBY_CACHE[$key]}"
			CHRUBY_CACHE[$key]="${value}${stored:+${3}$stored}"
		else
			CHRUBY_CACHE[$key]="$value"
		fi
	}

	export RUBY_ROOT="$1"
	export RUBYOPT="$2"

	# If the modified GEM_HOME, GEM_PATH, and PATH values we create in this
	# function haven't changed by the time chruby_reset is called, we'll
	# restore these cached values.
	chruby_unshift_cache GEM_HOME "$GEM_HOME"
	chruby_unshift_cache GEM_PATH "$GEM_PATH"
	chruby_unshift_cache PATH "$PATH"

	chruby_unshift_cache ADDED_PATH "$RUBY_ROOT/bin" ':'
	export PATH="$RUBY_ROOT/bin:$PATH"

	eval "$(RUBYGEMS_GEMDEPS="" "$RUBY_ROOT/bin/ruby" - <<EOF
puts "export RUBY_ENGINE=#{Object.const_defined?(:RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'};"
puts "export RUBY_VERSION=#{RUBY_VERSION};"
begin; require 'rubygems'; puts "export GEM_ROOT=#{Gem.default_dir.inspect};"; rescue LoadError; end
EOF
)"

	if [[ -n "$GEM_ROOT" ]]; then
		chruby_unshift_cache ADDED_PATH "$GEM_ROOT/bin" ':'
		PATH="$GEM_ROOT/bin:$PATH"
	fi

	if (( UID != 0 )); then
		GEM_HOME="$HOME/.gem/$RUBY_ENGINE/$RUBY_VERSION"

		for gem_path_to_add in "$GEM_ROOT" "$GEM_HOME"; do
			if [[ -n "$gem_path_to_add" ]]; then
				chruby_unshift_cache ADDED_GEM_PATH "$gem_path_to_add" ':'
				GEM_PATH="${gem_path_to_add}${GEM_PATH:+:$GEM_PATH}"
			fi
		done

		chruby_unshift_cache ADDED_PATH "$GEM_HOME/bin" ':'
		PATH="$GEM_HOME/bin:$PATH"
	fi

	# Store the values of these variables so that we can check them in
	# chruby_reset -- if they haven't changed, we simply restore the values of
	# GEM_HOME, GEM_PATH and PATH that we stored earlier in this function.
	chruby_unshift_cache CHRUBY_GEM_HOME "$GEM_HOME"
	chruby_unshift_cache CHRUBY_GEM_PATH "$GEM_PATH"
	chruby_unshift_cache CHRUBY_PATH "$PATH"

	unset -f chruby_unshift_cache

	export GEM_HOME GEM_PATH PATH

	hash -r
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
					echo "   ${ruby}"
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
