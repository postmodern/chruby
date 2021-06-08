unset RUBY_AUTO_VERSION

function chruby_auto() {
	local dir="$PWD/" version

	until [[ -z "$dir" ]]; do
		dir="${dir%/*}"

		if { read -r version <"$dir/.ruby-version"; } 2>/dev/null || [[ -n "$version" ]]; then
			version="${version%%[[:space:]]}"

			if [[ "$version" == "$RUBY_AUTO_VERSION" ]]; then return
			else
				RUBY_AUTO_VERSION="$version"
				chruby "$version"
				return $?
			fi
		fi
	done

	if [[ -n "$RUBY_AUTO_VERSION" ]]; then
		chruby_reset
		unset RUBY_AUTO_VERSION
	fi
}

function ruby_version_autoexec() {
	chruby_auto
}

if [[ -n "$ZSH_VERSION" ]]; then
	if [[ ! "$preexec_functions" == *ruby_version_autoexec* ]]; then
		preexec_functions+=("ruby_version_autoexec")
	fi
elif [[ -n "$BASH_VERSION" ]]; then
	trap '[[ "$BASH_COMMAND" != "$PROMPT_COMMAND" ]] && ruby_version_autoexec' DEBUG
fi
