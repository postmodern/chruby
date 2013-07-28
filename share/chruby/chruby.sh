chruby_version="0.3.7"

${BASH_VERSION+shopt -s nullglob}
${ZSH_VERSION+setopt nullglob}
for rubydir in "$PREFIX"/opt/rubies/* "$HOME"/.rubies/*; do
  [[ -d "$rubydir/bin" ]] && RUBIES+=("$rubydir")
done
${BASH_VERSION+shopt -u nullglob}
${ZSH_VERSION+setopt nonullglob}

function chruby_reset()
{
	[[ -z "$RUBY_ROOT" ]] && return

	PATH=":$PATH:" PATH="${PATH//:$RUBY_ROOT\/bin:/:}"

	if (( ! UID == 0 )); then
		[[ -n "$GEM_HOME" ]] && PATH="${PATH//:$GEM_HOME\/bin:/:}"
		[[ -n "$GEM_ROOT" ]] && PATH="${PATH//:$GEM_ROOT\/bin:/:}"

		GEM_PATH=":$GEM_PATH:"
		GEM_PATH="${GEM_PATH//:$GEM_HOME:/:}"
		GEM_PATH="${GEM_PATH//:$GEM_ROOT:/:}"
		GEM_PATH="${GEM_PATH#:}" GEM_PATH="${GEM_PATH%:}"
		unset GEM_ROOT GEM_HOME
	fi

	PATH="${PATH#:}" PATH="${PATH%:}"
	export PATH
	unset RUBY_ROOT RUBY_ENGINE RUBY_VERSION RUBYOPT
	hash -r
}

function chruby_use()
{
	if [[ ! -x "$1/bin/ruby" ]]; then
		printf '%s\n' "chruby: $1/bin/ruby not executable" >&2
		return 1
	fi

	[[ -n "$RUBY_ROOT" ]] && chruby_reset

	RUBY_ROOT="$1"
	RUBYOPT="$2"
	PATH="$RUBY_ROOT/bin:$PATH"

	eval "$("$RUBY_ROOT/bin/ruby" - <<EOF
begin; require 'rubygems'; rescue LoadError; end
puts "export RUBY_ENGINE=#{defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'};"
puts "export RUBY_VERSION=#{RUBY_VERSION};"
puts "export GEM_ROOT=#{Gem.default_dir.inspect};" if defined?(Gem)
EOF
)"

	if (( ! UID == 0 )); then
		GEM_HOME="$HOME/.gem/$RUBY_ENGINE/$RUBY_VERSION"
		GEM_PATH="$GEM_HOME${GEM_ROOT:+:$GEM_ROOT}${GEM_PATH:+:$GEM_PATH}"
		PATH="$GEM_HOME/bin${GEM_ROOT:+:$GEM_ROOT/bin}:$PATH"
	fi
	export RUBY_ROOT RUBYOPT GEM_HOME GEM_PATH PATH
}

function chruby()
{
	case "$1" in
		-h|--help)
			printf '%s\n' "usage: chruby [RUBY|VERSION|system] [RUBY_OPTS]"
			;;
		-V|--version)
			printf '%s\n' "chruby: $chruby_version"
			;;
		"")
			local star

			for dir in "${RUBIES[@]}"; do
				if [[ "$dir" == "$RUBY_ROOT" ]]; then star="*"
				else                                  star=" "
				fi

				printf '%s\n' " $star ${dir##*/}"
			done
			;;
		system) chruby_reset ;;
		*)
			local match

			for dir in "${RUBIES[@]}"; do
				[[ "${dir##*/}" == *"$1"* ]] && match="$dir"
			done

			if [[ -z "$match" ]]; then
				printf '%s\n' "chruby: unknown Ruby: $1" >&2
				return 1
			fi

			shift
			chruby_use "$match" "$@"
			;;
	esac
}
