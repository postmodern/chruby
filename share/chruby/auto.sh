unset RUBY_VERSION_FILE

function chruby_auto() {
	local dir="$PWD"
	local version_file

	until [[ -z "$dir" ]]; do
		version_file="$dir/.ruby-version"

		if   [[ "$version_file" == "$RUBY_VERSION_FILE" ]]; then return
		elif [[ -f "$version_file" ]]; then
			chruby $(cat "$version_file") || return 1

			export RUBY_VERSION_FILE="$version_file"
			return
		fi

		dir="${dir%/*}"
	done

	if [[ -n "$RUBY_VERSION_FILE" ]]; then
		chruby_reset
		unset RUBY_VERSION_FILE
	fi
}

if [[ -n "$ZSH_VERSION" ]]; then
	if [[ ! "$precmd_functions" == *chruby_auto* ]]; then
		precmd_functions+=("chruby_auto")
	fi
elif [[ -n "$BASH_VERSION" ]]; then
	if [[ -n "$PROMPT_COMMAND" ]]; then
		if [[ ! "$PROMPT_COMMAND" == *chruby_auto* ]]; then
			PROMPT_COMMAND="$PROMPT_COMMAND; chruby_auto"
		fi
	else
		PROMPT_COMMAND="chruby_auto"
	fi
fi
