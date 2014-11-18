if [[ -n "$ZSH_VERSION" ]]; then
	function _chruby() {
		_arguments '1:ruby version:(system ${RUBIES[@]##*/})';
	}

	compdef _chruby chruby
elif [[ -n "$BASH_VERSION" ]]; then
	function _chruby() {
		local cur=${COMP_WORDS[COMP_CWORD]}
		local rubies="system ${RUBIES[@]##*/}"

		if [[ $COMP_CWORD -eq 1 ]]; then
			COMPREPLY=($( compgen -W "$rubies" -- $cur ))
		fi
	}

	complete -F _chruby chruby
fi
