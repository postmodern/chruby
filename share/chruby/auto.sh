function chruby_auto() {
	if [[ -f .ruby-version ]]; then
		chruby $(cat .ruby-version) && export RUBY_VERSIONED_DIR="$PWD"
	elif [[ "$PWD" != "$RUBY_VERSIONED_DIR"/* ]]; then
		chruby_reset; unset RUBY_VERSIONED_DIR
	fi
}

if [[ -n "$ZSH_VERSION" ]]; then
	precmd_functions+=("chruby_auto")
else
	PROMPT_COMMAND="chruby_auto; $PROMPT_COMMAND"
fi
