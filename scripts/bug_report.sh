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
	echo "$1" | sed 's/^/    /'
}

function print_variable()
{
	if [[ -n "$2" ]]; then echo "    $1=$2"
	else                   echo "    $1=$(eval "echo \$$1")"
	fi
}

function print_version()
{
	local path="$(command -v "$1")"

	if [[ -n "$path" ]]; then
		indent "$("$1" --version | head -n 1) ($path)"
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
print_variable "HOME"

[[ -n "$RUBIES"       ]] && print_variable "RUBIES" "(${RUBIES[@]})"
[[ -n "$RUBY_ROOT"    ]] && print_variable "RUBY_ROOT"
[[ -n "$RUBY_VERSION" ]] && print_variable "RUBY_VERSION"
[[ -n "$RUBY_ENGINE"  ]] && print_variable "RUBY_ENGINE"
[[ -n "$GEM_ROOT"     ]] && print_variable "GEM_ROOT"
[[ -n "$GEM_HOME"     ]] && print_variable "GEM_HOME"
[[ -n "$GEM_PATH"     ]] && print_variable "GEM_PATH"

if [[ -n "$ZSH_VERSION" ]]; then
	print_section "Hooks"
	
	for f in "${preexec_functions[@]}"; do
		echo "  $f"
	done
elif [[ -n "$BASH_VERSION" ]]; then
	print_section "Hooks"
	indent "$(trap -p DEBUG)"
fi

if [[ -f .ruby-version ]]; then
	print_section ".ruby-version"
	echo "    $(< .ruby-version)"
fi

print_section "Aliases"

indent "$(alias)"
