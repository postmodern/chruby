unset ruby_auto_version

function chruby_auto() {
	local dir="$PWD"
	local version_file
	local version

	until [[ -z "$dir" ]]; do
		version_file="$dir/.ruby-version"

		if [[ -f "$version_file" ]]; then
			read -r version < "$version_file"

			if [[ "$version" == "$ruby_auto_version" ]]; then return
			else
				ruby_auto_version="$version"
				chruby "$version"
				return $?
			fi
		fi

		dir="${dir%/*}"
	done

	if [[ -n "$ruby_auto_version" ]]; then
		chruby_reset
		unset ruby_auto_version
	fi
}

if [[ -n "$ZSH_VERSION" ]]; then
	if [[ ! "$preexec_functions" == *chruby_auto* ]]; then
		preexec_functions+=("chruby_auto")
	fi
elif [[ -n "$BASH_VERSION" ]]; then
	trap '[[ "$BASH_COMMAND" != "$PROMPT_COMMAND" ]] && chruby_auto' DEBUG
fi
