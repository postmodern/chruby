RUBIES=()

function chruby_reset()
{
	[[ -z "$RUBY_PATH" ]] && return

	local family=`ruby -e "require 'rbconfig'; print RbConfig::CONFIG['ruby_version']"`
	local new_path

	new_path=":$PATH:"
	new_path=${new_path/:$RUBY_PATH\/bin:/:}
	new_path=${new_path/:$HOME\/.gem\/$RUBY_ENGINE\/$RUBY_VERSION\/bin:/:}
	new_path=${new_path/:$RUBY_PATH\/lib\/ruby\/gems\/$family\/bin:/:}
	new_path=${new_path%:}
	new_path=${new_path#:}
	export PATH="$new_path"

	unset GEM_HOME
	unset GEM_PATH
	unset RUBY_PATH
	unset RUBY_ENGINE
	unset RUBY_VERSION
}

function chruby_use()
{
	[[ -n "$RUBY_PATH" ]] && chruby_reset

	local name=`basename $1`

	export PATH="$1/bin:$PATH"
	export RUBY_PATH="$1"
	export RUBY_ENGINE=`echo $name | cut -f1 -d-`
	export RUBY_VERSION=`ruby -e "print RUBY_VERSION"`

	if [[ ! $UID -eq 0 ]]; then
		local family=`ruby -e "require 'rbconfig'; print RbConfig::CONFIG['ruby_version']"`

		export GEM_HOME="$HOME/.gem/$RUBY_ENGINE/$RUBY_VERSION"
		export GEM_PATH="$RUBY_PATH/lib/ruby/gems/$family"

		export PATH="$GEM_HOME/bin:$GEM_PATH/bin:$PATH"
		export GEM_PATH="$GEM_HOME:$GEM_PATH"
	fi
}

function chruby()
{
	case "$1" in
		-h|--help) echo "usage: chruby [RUBY|VERSION|system]" ;;
		"")
			for path in ${RUBIES[@]}; do
				if [[ "$path" == "$RUBY_PATH" ]]; then
					echo -n " * "
				else
					echo -n "   "
				fi

				echo $(basename "$path")
			done
			;;
		system) chruby_reset ;;
		*)
			for path in ${RUBIES[@]}; do
				if [[ `basename "$path"` == *$1* ]]; then
					chruby_use "$path"
					return
				fi
			done

			echo "Unknown Ruby: $1"
			return 1
			;;
	esac
}
