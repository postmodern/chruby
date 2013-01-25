#!/bin/sh -il

function print_section()
{
	echo
	echo "## $1"
	echo
}

function indent()
{
	echo "    $1"
}

function print_variable()
{
	if [[ -n "$2" ]]; then echo "    $1=$2"
	else                   echo "    $1=$(eval "echo \$$1")"
	fi
}

print_section "System"

echo "    $(uname -a)"
[[ -n "$BASH_VERSION" ]] && indent "Bash $BASH_VERSION"
[[ -n "$ZSH_VERSION"  ]] && indent "Zsh $ZSH_VERSION"

print_section "Environment"

print_variable "SHELL"
print_variable "PATH"
[[ -n "$PROMPT_COMMAND" ]] && print_variable "PROMPT_COMMAND"

print_section "Ruby"

[[ -n "$RUBIES"       ]] && print_variable "RUBIES" "(${RUBIES[*]})"
[[ -n "$FUBY_ROOT"    ]] && print_variable "RUBY_ROOT"
[[ -n "$RUBY_VERSION" ]] && print_variable "RUBY_VERSION"
[[ -n "$RUBY_ENGINE"  ]] && print_variable "RUBY_ENGINE"
[[ -n "$GEM_ROOT"     ]] && print_variable "GEM_HOME"
[[ -n "$GEM_HOME"     ]] && print_variable "GEM_HOME"
[[ -n "$GEM_PATH"     ]] && print_variable "GEM_PATH"

if [[ -f .ruby-version ]]; then
	print_section ".ruby-version"
	echo "    $(cat .ruby-version)"
fi

print_section "Aliases"
alias | sed 's/^/    /'
