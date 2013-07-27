#
# chruby script to collect environment information for bug reports.
#

[[ -z "$PS1" ]] && exec "$SHELL" -i -l "$0"

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
	if [[ -n $(which $1 2>/dev/null) ]]; then
		indent "$("$1" --version | head -n 1) ($(which "$1"))"
	fi
}

print_section "System"

indent "$(uname -a)"
print_version "bash"
print_version "tmux"
print_version "zsh"
print_version "ruby"
print_version "bundle"

print_section "Environment"

print_variable "CHRUBY_VERSION"
print_variable "SHELL"
print_variable "PATH"

[[ -n "$PROMPT_COMMAND"    ]] && print_variable "PROMPT_COMMAND"
[[ -n "$preexec_functions" ]] && print_variable "preexec_functions"
[[ -n "$precmd_functions"  ]] && print_variable "precmd_functions"

[[ -n "$RUBIES"       ]] && print_variable "RUBIES" "(${RUBIES[*]})"
[[ -n "$RUBY_ROOT"    ]] && print_variable "RUBY_ROOT"
[[ -n "$RUBY_VERSION" ]] && print_variable "RUBY_VERSION"
[[ -n "$RUBY_ENGINE"  ]] && print_variable "RUBY_ENGINE"
[[ -n "$GEM_ROOT"     ]] && print_variable "GEM_ROOT"
[[ -n "$GEM_HOME"     ]] && print_variable "GEM_HOME"
[[ -n "$GEM_PATH"     ]] && print_variable "GEM_PATH"

if [[ -f .ruby-version ]]; then
	print_section ".ruby-version"
	read -r ruby_version < .ruby_version
	echo "    $ruby_version"
fi

print_section "Aliases"

alias | sed 's/^/    /'
