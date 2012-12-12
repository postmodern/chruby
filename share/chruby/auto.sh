function chruby_auto() {
	local version_file="$PWD/.ruby-version"

	if   [[ -f "$version_file"   ]]; then
		chruby $(cat "$version_file")
		export RUBY_VERSIONED_DIRECTORY="$PWD"
	elif [[ "$PWD" != "$RUBY_VERSIONED_DIRECTORY"/* ]]; then
		chruby_reset
		unset RUBY_VERSIONED_DIRECTORY
	fi
}

if [[ -n "$ZSH_VERSION" ]]; then
	chpwd_functions=(${chpwd_functions[@]} "chruby_auto")
else
	function cd() { builtin cd "$@" && chruby_auto; }
fi
