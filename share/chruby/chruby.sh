CHRUBY_VERSION="1.0.0"

function chruby_init()
{
	local dir

	CHRUBY_RUBIES=()
	for dir in "$PREFIX/opt/rubies" "$HOME/.rubies"; do
		if [[ -d "$dir" ]] && [[ -n "$(ls -A "$dir")" ]]; then
			CHRUBY_RUBIES+=("$dir"/*)
		fi
	done
}

function chruby_rubies()
{
	local dir

	for dir in "${CHRUBY_RUBIES[@]}"; do
		echo "$dir"
	done
}

function chruby_find()
{
	local dir ruby match

	for dir in "${CHRUBY_RUBIES[@]}"; do
		dir="${dir%%/}"; ruby="${dir##*/}"
		case "$ruby" in
			"$1")	match="$dir" && break ;;
			*"$1"*)	match="$dir" ;;
		esac
	done

	echo "$match"
}

function chruby_reset()
{
	[[ -z "$RUBY_ROOT" ]] && return

	PATH=":$PATH:"; PATH="${PATH//:$RUBY_ROOT\/bin:/:}"
	[[ -n "$GEM_ROOT" ]] && PATH="${PATH//:$GEM_ROOT\/bin:/:}"

	if (( UID != 0 )); then
		[[ -n "$GEM_HOME" ]] && PATH="${PATH//:$GEM_HOME\/bin:/:}"

		GEM_PATH=":$GEM_PATH:"
		[[ -n "$GEM_HOME" ]] && GEM_PATH="${GEM_PATH//:$GEM_HOME:/:}"
		[[ -n "$GEM_ROOT" ]] && GEM_PATH="${GEM_PATH//:$GEM_ROOT:/:}"
		GEM_PATH="${GEM_PATH#:}"; GEM_PATH="${GEM_PATH%:}"

		unset GEM_HOME
		[[ -z "$GEM_PATH" ]] && unset GEM_PATH
	fi

	PATH="${PATH#:}"; PATH="${PATH%:}"
	unset RUBY_ROOT RUBY_ENGINE RUBY_VERSION RUBYOPT GEM_ROOT
	hash -r
}

function chruby_use()
{
	local ruby_dir="$1"

	if [[ ! -x "$ruby_dir/bin/ruby" ]]; then
		echo "chruby: $ruby_dir/bin/ruby not executable" >&2
		return 1
	fi

	[[ -n "$RUBY_ROOT" ]] && chruby_reset

	export RUBY_ROOT="$ruby_dir"
	export RUBYOPT="$2"
	export PATH="$RUBY_ROOT/bin:$PATH"

	eval "$(RUBYGEMS_GEMDEPS="" "$RUBY_ROOT/bin/ruby" - <<EOF
puts "export RUBY_ENGINE=#{Object.const_defined?(:RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'};"
puts "export RUBY_VERSION=#{RUBY_VERSION};"
begin; require 'rubygems'; puts "export GEM_ROOT=#{Gem.default_dir.inspect};"; rescue LoadError; end
EOF
)"
	export PATH="${GEM_ROOT:+$GEM_ROOT/bin:}$PATH"

	if (( UID != 0 )); then
		export GEM_HOME="$HOME/.gem/rubies/${RUBY_ROOT##*/}"
		export GEM_PATH="$GEM_HOME${GEM_ROOT:+:$GEM_ROOT}${GEM_PATH:+:$GEM_PATH}"
		export PATH="$GEM_HOME/bin:$PATH"
	fi

	hash -r
}

function chruby()
{
	case "$1" in
		-h|--help)
			echo "usage: chruby [--reload | RUBY|VERSION [RUBYOPT...] | system]"
			;;
		-V|--version)
			echo "chruby: $CHRUBY_VERSION"
			;;
		--reload) chruby_init ;;
		"")
			local dir ruby
			while IFS= read dir; do
				dir="${dir%%/}"; ruby="${dir##*/}"
				if [[ "$dir" == "$RUBY_ROOT" ]]; then
					echo " * ${ruby}${RUBYOPT:+ $RUBYOPT}"
				else
					echo "   ${ruby}"
				fi
			done <<< $(chruby_rubies)
			;;
		system) chruby_reset ;;
		*)
			local ruby="$1"
			local ruby_dir="$(chruby_find "$ruby")"

			if [[ -z "$ruby_dir" ]]; then
				echo "chruby: unknown Ruby: $ruby" >&2
				return 1
			fi

			shift
			chruby_use "$ruby_dir" "$*"
			;;
	esac
}

chruby_init
