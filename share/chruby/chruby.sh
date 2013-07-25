CHRUBY_VERSION=0.3.7

while IFS= read -r rubypath; do
  rubies+=("$rubypath")
done < <(paths=("$prefix/opt/rubies" "$HOME/.rubies")
	args=(
		-mindepth 1
		-maxdepth 1
		-type d
	)
	find "${paths[@]}" "${args[@]}" 2>/dev/null
	)

chruby_reset() {
	[[ -z $RUBY_ROOT ]] && return

	PATH=:$PATH: PATH=${PATH//:$RUBY_ROOT\/bin:/:}

	if (( UID )); then
		[[ -n $GEM_HOME ]] && PATH=${PATH//:$GEM_HOME\/bin:/:}
		[[ -n $GEM_ROOT ]] && PATH=${PATH//:$GEM_ROOT\/bin:/:}

		GEM_PATH=:$GEM_PATH:
		GEM_PATH=${GEM_PATH//:$GEM_HOME:/:}
		GEM_PATH=${GEM_PATH//:$GEM_ROOT:/:}
		GEM_PATH=${GEM_PATH#:}
		GEM_PATH=${GEM_PATH%:}
		export GEM_PATH
		unset GEM_ROOT GEM_HOME
	fi

	PATH=${PATH#:} PATH=${PATH%:}
	export PATH
	unset RUBY_ROOT RUBY_ENGINE RUBY_VERSION RUBYOPT
	hash -r
}

chruby_use() {
	if [[ ! -x $1/bin/ruby ]]; then
		printf '%s\n' "chruby: $1/bin/ruby not executable" >&2
		return 1
	fi

	[[ -n $RUBY_ROOT ]] && chruby_reset

	RUBY_ROOT=$1
	RUBYOPT=$2
	PATH=$RUBY_ROOT/bin:$PATH
	export RUBY_ROOT RUBYOPT PATH

	eval "$("$RUBY_ROOT"/bin/ruby - <<EOF
begin; require 'rubygems'; rescue LoadError; end
puts "export RUBY_ENGINE=#{defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'};"
puts "export RUBY_VERSION=#{RUBY_VERSION};"
puts "export GEM_ROOT=#{Gem.default_dir.inspect};" if defined?(Gem)
EOF)"

	if (( UID )); then
		GEM_HOME=$HOME/.gem/$RUBY_ENGINE/$RUBY_VERSION
		GEM_PATH=$GEM_HOME${GEM_ROOT:+:$GEM_ROOT}${GEM_PATH:+:$GEM_PATH}
		PATH=$GEM_HOME/bin${GEM_ROOT:+:$GEM_ROOT/bin}:$PATH
		export GEM_HOME GEM_PATH PATH
	fi
}

chruby() {
	case $1 in
		-h|--help)
			printf '%s\n' "usage: chruby [RUBY|VERSION|system] [RUBY_OPTS]"
			;;
		-V|--version)
			printf '%s\n' "chruby: $CHRUBY_VERSION"
			;;
		"")
			local star

			for dir in ${rubies[@]}; do
				if [[ $dir == $RUBY_ROOT ]]; then
					star=*
				else
					star=" "
				fi

				printf '%s\n' " $star ${dir##*/}"
			done
			;;
		system) chruby_reset ;;
		*)
			local match

			for dir in ${rubies[@]}; do
				[[ ${dir##*/} == *$1* ]] && match=$dir
			done

			if [[ -z $match ]]; then
				printf '%s\n' "chruby: unknown Ruby: $1" >&2
				return 1
			fi

			shift
			IFS= chruby_use "$match" "$*"
			;;
	esac
}
