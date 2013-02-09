unset RUBY_VERSION_FILE

function chruby_auto_use() {
	local version_file="$1/.ruby-version"

	if   [[ "$version_file" == "$RUBY_VERSION_FILE" ]]; then return
	elif [[ -f "$version_file" ]]; then
		export RUBY_VERSION_FILE="$version_file"
		chruby $(cat "$version_file") || return 1
	else return 2
	fi
}

function chruby_auto() {
	local dir="$PWD"

	until [[ -z "$dir" ]]; do
		chruby_auto_use "$dir"
		[[ $? == 2 ]] || return $?
		dir="${dir%/*}"
	done

	chruby_auto_use "$HOME"
	[[ $? == 2 ]] || return $?

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
	PROMPT_COMMAND="${PROMPT_COMMAND%% }"

	if [[ -n "$PROMPT_COMMAND" ]]; then
		if [[ ! "$PROMPT_COMMAND" == *chruby_auto* ]]; then
			PROMPT_COMMAND="${PROMPT_COMMAND%%;}"
			PROMPT_COMMAND="$PROMPT_COMMAND; chruby_auto"
		fi
	else
		PROMPT_COMMAND="chruby_auto"
	fi
fi
