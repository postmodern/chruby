CHRUBY_VERSION="1.0.0"
CHRUBY_DIRS=("$PREFIX/opt/rubies" "$HOME/.rubies")

function chruby_list()
{
	local rubies_dir ruby_dir

	for rubies_dir in "${CHRUBY_DIRS[@]}"; do
		for ruby_dir in "${rubies_dir}"/*; do
			if [[ -d "$ruby_dir" ]]; then
				echo "$ruby_dir"
			fi
		done
	done
}

function chruby_find()
{
	local ruby_dir ruby_name match

	while IFS= read -r ruby_dir; do
		ruby_dir="${ruby_dir%%/}"
		ruby_name="${ruby_dir##*/}"

		case "$ruby_name" in
			"$1")	match="$ruby_dir" && break ;;
			*"$1"*)	match="$ruby_dir" ;;
		esac
	done <<< $(chruby_list)

	echo -n "$match"
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

function chruby_gem_home() { echo -n "$HOME/.gem/rubies/${RUBY_ROOT##*/}"; }
function chruby_gem_path() { echo -n "$GEM_HOME${GEM_ROOT:+:$GEM_ROOT}${GEM_PATH:+:$GEM_PATH}"; }

function chruby_set()
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
		export GEM_HOME="$(chruby_gem_home)"
		export GEM_PATH="$(chruby_gem_path)"
		export PATH="$GEM_HOME/bin:$PATH"
	fi

	hash -r
}

function chruby()
{
	case "$1" in
		-h|--help)
			echo "usage: chruby [RUBY|VERSION [RUBYOPT...] | system]"
			;;
		-V|--version)
			echo "chruby: $CHRUBY_VERSION"
			;;
		"")
			local ruby_dir ruby_name

			while IFS= read -r ruby_dir; do
				ruby_dir="${ruby_dir%%/}"
				ruby_name="${ruby_dir##*/}"

				if [[ "$ruby_dir" == "$RUBY_ROOT" ]]; then
					echo " * ${ruby_name}${RUBYOPT:+ $RUBYOPT}"
				else
					echo "   ${ruby_name}"
				fi
			done <<< $(chruby_list)
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
			chruby_set "$ruby_dir" "$*"
			;;
	esac
}
