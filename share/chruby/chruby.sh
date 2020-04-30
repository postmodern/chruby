CHRUBY_VERSION="0.3.9"

function chruby_list_rubies()
{
	local chruby_entry
	for chruby_entry in "$@"; do
		[[ -x "$chruby_entry/bin/ruby" ]] && echo "$chruby_entry"
	done 
}

function chruby_detect_rubies()
{
	if [[ -d "$1" ]]; then
		{ chruby_list_rubies "$1"/* ;} 2>/dev/null || true
	else
		chruby_list_rubies $1
	fi
}

function chruby_stable_version_sort() {
	local dir last_engine ruby engine_no=0 engine ver old_ver v0 v1 v2 v3 v4
	sort -u | while read -r dir; do
		last_engine="$engine"
		ruby="${dir##*/}"; engine="${ruby%%-*}"; ver="${ruby#*-}"
		[[ "$last_engine" != "$engine" ]] && engine_no=$((engine_no + 1))
		v0="${ver%%\.*}"; ver="${ver#*\.}"
		v1="${ver%%\.*}"; old_ver="$ver"; ver="${ver#*\.}"
		[[ "$ver" == "$old_ver" ]] && ver=""
		v2="${ver%%\.*}"; old_ver="$ver"; ver="${ver#*\.}"
		[[ "$ver" == "$old_ver" ]] && ver=""
		v3="${ver%%\.*}"; old_ver="$ver"; ver="${ver#*\.}"
		[[ "$ver" == "$old_ver" ]] && ver=""
		v4="${v2#*-p}"
		[[ "$v2" == "$v4" ]] && v4=""
		echo "$engine_no:$v0:$v1:$v2:$v3:$v4:$dir"
	done | sort -nt: -k1 -k2 -k3 -k4 -k5 -k6 | cut -d: -f7-
}

function chruby_detect_all_rubies()
{
	{
		chruby_detect_rubies "$PREFIX/opt/rubies"
		chruby_detect_rubies "$HOME/.rubies"
		if [[ -n "$RUBIES" ]]; then
			local chruby_rubies_dir
			for chruby_rubies_dir in "${RUBIES[@]}"; do
				chruby_detect_rubies "$chruby_rubies_dir"
			done
		fi
	} | chruby_stable_version_sort
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
	if [[ ! -x "$1/bin/ruby" ]]; then
		echo "chruby: $1/bin/ruby not executable" >&2
		return 1
	fi

	[[ -n "$RUBY_ROOT" ]] && chruby_reset

	export RUBY_ROOT="$1"
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
		export GEM_HOME="$HOME/.gem/$RUBY_ENGINE/$RUBY_VERSION"
		export GEM_PATH="$GEM_HOME${GEM_ROOT:+:$GEM_ROOT}${GEM_PATH:+:$GEM_PATH}"
		export PATH="$GEM_HOME/bin:$PATH"
	fi

	hash -r
}

function chruby()
{
	case "$1" in
		-h|--help)
			echo "usage: chruby [RUBY|VERSION|system] [RUBYOPT...]"
			;;
		-V|--version)
			echo "chruby: $CHRUBY_VERSION"
			;;
		"")
			local dir ruby
			chruby_detect_all_rubies | while read -r dir; do
				dir="${dir%%/}"; ruby="${dir##*/}"
				if [[ "$dir" == "$RUBY_ROOT" ]]; then
					echo " * ${ruby} ${RUBYOPT}"
				else
					echo "   ${ruby}"
				fi

			done
			;;
		system) chruby_reset ;;
		*)
			local dir ruby match
			chruby_detect_all_rubies | while read -r dir; do
				dir="${dir%%/}"; ruby="${dir##*/}"
				case "$ruby" in
					"$1")	match="$dir" && break ;;
					*"$1"*)	match="$dir" ;;
				esac
			done

			if [[ -z "$match" ]]; then
				echo "chruby: unknown Ruby: $1" >&2
				return 1
			fi

			shift
			chruby_use "$match" "$*"
			;;
	esac
}
