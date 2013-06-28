unset RUBY_VERSION_FILE

function chruby_auto() {
	local dir="$PWD"
	local version_file
	local version

	until [[ -z "$dir" ]]; do
		version_file="$dir/.ruby-version"

		if [[ -f "$version_file" ]]; then
			version="$(cat "$version_file")"

			if [[ "$version" == "$RUBY_AUTO_VERSION" ]]; then return
			else
				export RUBY_AUTO_VERSION="$version"
				chruby "$version"
				return $?
			fi
		fi

		dir="${dir%/*}"
	done

	if [[ -n "$RUBY_AUTO_VERSION" ]]; then
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
