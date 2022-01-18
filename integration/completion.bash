function _chruby() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    local rubies="system ${RUBIES[@]##*/}"

    if [[ $COMP_CWORD -eq 1 ]]; then
        COMPREPLY=($( compgen -W "$rubies" -- $cur ))
    fi
}

complete -F _chruby chruby
