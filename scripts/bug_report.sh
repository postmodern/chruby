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

function print_version()
{
	if [[ -n $(which $1) ]]; then
		indent "$($1 --version | head -n 1) ($(which $1))"
	fi
}

print_section "System"

indent "$(uname -a)"
print_version "bash"
print_version "zsh"
print_version "ruby"
print_version "bundle"

print_section "Environment"

print_variable "SHELL"
print_variable "PATH"
[[ -n "$PROMPT_COMMAND" ]] && print_variable "PROMPT_COMMAND"

[[ -n "$RUBIES"       ]] && print_variable "RUBIES" "(${RUBIES[*]})"
[[ -n "$RUBY_ROOT"    ]] && print_variable "RUBY_ROOT"
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
