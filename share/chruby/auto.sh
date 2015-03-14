unset RUBY_AUTO_VERSION

function chruby_auto_version()
{
	local dir="$PWD/" version

	until [[ -z "$dir" ]]; do
		dir="${dir%/*}"

		if { read -r version <"$dir/.ruby-version"; } 2>/dev/null || [[ -n "$version" ]]; then
			echo -n "${version%%[[:space:]]}"
			return
		fi
	done
}

function chruby_auto() {
	local version="$(chruby_auto_version)"

	if [[ -n "$version" ]]; then
		if [[ "$version" == "$RUBY_AUTO_VERSION" ]]; then return
		else
			RUBY_AUTO_VERSION="$version"
			chruby "$version"
			return $?
		fi
	elif [[ -n "$RUBY_AUTO_VERSION" ]]; then
		chruby_reset
		unset RUBY_AUTO_VERSION
	fi
}

if [[ -n "$ZSH_VERSION" ]]; then
	if [[ ! "$preexec_functions" == *chruby_auto* ]]; then
		preexec_functions+=("chruby_auto")
	fi
elif [[ -n "$BASH_VERSION" ]]; then
	trap '[[ "$BASH_COMMAND" != "$PROMPT_COMMAND" ]] && chruby_auto' DEBUG
fi
