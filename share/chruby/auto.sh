function chruby_auto() {
	if [[ -n "$RUBY_VERSIONED_DIR" ]]; then
		if [[ "$PWD" != "$RUBY_VERSIONED_DIR"/* ]]; then
			chruby_reset
			unset RUBY_VERSIONED_DIR
		fi
	else
		local dir="$PWD"
		local version_file

		until [[ "$dir" == / ]]; do
			version_file="$dir/.ruby-version"

			if [[ -f "$version_file" ]]; then
				chruby $(cat "$version_file") || return 1

				export RUBY_VERSIONED_DIR="$dir"
				break
			fi

			dir=$(dirname "$dir")
		done
	fi
}

if [[ -n "$ZSH_VERSION" ]]; then precmd_functions+=("chruby_auto")
else                             PROMPT_COMMAND="chruby_auto; $PROMPT_COMMAND"
fi
