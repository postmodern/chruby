#!/bin/sh

set -e

export PREFIX="/usr/local"
export SRC_DIR="$PREFIX/src"

CHRUBY_VERSION="0.2.1"

RUBY_BUILD_VERSION="20121110"
RUBY_BUILD="$PREFIX/bin/ruby-build"

MRI_VERSION="1.9.3-p327"
MRI_PATH="$PREFIX/ruby-$MRI_VERSION"

JRUBY_VERSION="1.7.0"
JRUBY_PATH="$PREFIX/jruby-$JRUBY_VERSION"

RUBINIUS_VERSION="2.0.0-rc1"
RUBINIUS_PATH="$PREFIX/rubinius-$RUBINIUS_VERSION"

function log() {
	if [[ -t 1 ]]; then echo -e "\e[1m\e[32m>>>\e[0m \e[1m\e[37m$1\e[0m"
	else                echo ">>> $1"
	fi
}

function install_ruby() {
	log "Installing $1 into $2 ..."
	sudo env RUBY_BUILD_BUILD_PATH=$SRC_DIR $RUBY_BUILD -k $1 $2
}

if [[ $(type -t brew) == "file" ]]; then
	# OS X
	brew install ruby-build --without-rbenv
	brew install https://raw.github.com/postmodern/chruby/master/homebrew/chruby.rb
else
	# *nix
	log "Downloading ruby-build $RUBY_BUILD_VERSION ..."
	sudo wget https://github.com/sstephenson/ruby-build/archive/v$RUBY_BUILD_VERSION.tar.gz -O $SRC_DIR/ruby-build-$RUBY_BUILD_VERSION.tar.gz
	sudo tar -C $SRC_DIR/ -xzvf $SRC_DIR/ruby-build-$RUBY_BUILD_VERSION.tar.gz
	log "Installing ruby-build $RUBY_BUILD_VERSION ..."
	sudo sh -c "cd $SRC_DIR/ruby-build-$RUBY_BUILD_VERSION/ && ./install.sh"

	log "Downloading chruby-$CHRUBY_VERSION ..."
	sudo wget https://github.com/downloads/postmodern/chruby/chruby-$CHRUBY_VERSION.tar.gz -O $SRC_DIR/chruby-$CHRUBY_VERSION.tar.gz
	sudo tar -C $SRC_DIR/ -xzvf $SRC_DIR/chruby-$CHRUBY_VERSION.tar.gz
	log "Installing chruby-$CHRUBY_VERSION ..."
	sudo make -C $SRC_DIR/chruby-$CHRUBY_VERSION/ install
fi

install_ruby "$MRI_VERSION" "$MRI_PATH"
install_ruby "jruby-$JRUBY_VERSION" "$JRUBY_PATH"
install_ruby "rbx-$RUBINIUS_VERSION" "$RUBINIUS_PATH"

CHRUBY_CONFIG=`cat <<EOS
#!/bin/sh

. /usr/local/share/chruby/chruby.sh

RUBIES=(
  $MRI_PATH
  $JRUBY_PATH
  $RUBINIUS_PATH
)
EOS`

log "Configuring chruby ..."
if [[ -d /etc/profile.d/ ]]; then
	# GNU/Linux
	sudo sh -c "echo \"$CHRUBY_CONFIG\" > /etc/profile.d/chruby.sh"
else
	# *nix
	sudo sh -c "echo \"$CHRUBY_CONFIG\" >> /etc/profile"
fi

log "Setup complete! Please restart the shell"
