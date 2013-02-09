#!/bin/bash
#
# chruby script which installs the latest stable versions of Ruby, JRuby
# and Rubinius into /opt/rubies.
#

set -e

#
# Constants
#
RUBY_VERSION="1.9.3-p385"
JRUBY_VERSION="1.7.2"
RUBINIUS_VERSION="2.0.0-rc1"

[[ -z "$PREFIX"      ]] && export PREFIX="/usr/local"
[[ -z "$SRC_DIR"     ]] && export SRC_DIR="/usr/local/src"
[[ -z "$RUBIES_DIR"  ]] && export RUBIES_DIR="/opt/rubies"

#
# Functions
#
function log() {
	if [[ -t 1 ]]; then
		echo -e "\x1b[1m\x1b[32m>>>\x1b[0m \x1b[1m\x1b[37m$1\x1b[0m"
	else
		echo ">>> $1"
	fi
}

function error() {
	if [[ -t 1 ]]; then
		echo -e "\x1b[1m\x1b[31m!!!\x1b[0m \x1b[1m\x1b[37m$1\x1b[0m" >&2
	else
		echo "!!! $1" >&2
	fi
}

function warning() {
	if [[ -t 1 ]]; then
		echo -e "\x1b[1m\x1b[33m***\x1b[0m \x1b[1m\x1b[37m$1\x1b[0m" >&2
	else
		echo "*** $1" >&2
	fi
}

#
# Detect the Package Manager
#
if   [[ $(type -t apt-get) == "file" ]]; then PACKAGE_MANAGER="apt"
elif [[ $(type -t yum)     == "file" ]]; then PACKAGE_MANAGER="yum"
elif [[ $(type -t brew)    == "file" ]]; then PACKAGE_MANAGER="brew"
else
	warning "Could not determine Package Manager. Proceeding anyways."
fi

#
# Install chruby
#
log "Installing chruby ..."
make install

#
# Pre Install
#
install -d "$SRC_DIR"
install -d "$RUBIES_DIR"

log "Synching Package Manager"
case "$PACKAGE_MANAGER" in
	apt)	apt-get update ;;
	yum)	yum updateinfo ;;
	brew)	brew update ;;
esac

#
# Install MRI (https://github.com/postmodern/chruby/wiki/MRI)
#
log "Installing dependencies for Ruby $RUBY_VERSION ..."
case "$PACKAGE_MANAGER" in
	apt)	apt-get install -y build-essential zlib1g-dev libyaml-dev \
			           libssl-dev libgdbm-dev libreadline-dev \
				   libncurses5-dev libffi-dev ;;
	yum)	yum install -y gcc automake zlib-devel libyaml-devel \
			       openssl-devel gdbm-devel readline-devel \
			       ncurses-devel libffi-devel ;;
	brew)	brew install openssl readline libyaml gdbm libffi || true ;;
esac

cd $SRC_DIR

log "Downloading Ruby $RUBY_VERSION ..."
wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-$RUBY_VERSION.tar.gz

log "Extracting Ruby $RUBY_VERSION ..."
tar -xzvf ruby-$RUBY_VERSION.tar.gz
cd ruby-$RUBY_VERSION

log "Configuring Ruby $RUBY_VERSION ..."
if [[ "$PACKAGE_MANAGER" == "brew" ]]; then
	./configure --prefix="$RUBIES_DIR/ruby-$RUBY_VERSION" \
		    --with-openssl-dir=`brew --prefix openssl` \
		    --with-readline-dir=`brew --prefix readline` \
		    --with-yaml-dir=`brew --prefix yaml` \
		    --with-gdbm-dir=`brew --prefix gdbm` \
		    --with-libffi-dir=`brew --prefix libffi`
else
	./configure --prefix="$RUBIES_DIR/ruby-$RUBY_VERSION"
fi

log "Compiling Ruby $RUBY_VERSION ..."
make

log "Installing Ruby $RUBY_VERSION ..."
make install

#
# Install JRuby (https://github.com/postmodern/chruby/wiki/JRuby)
#
log "Installing dependencies for JRuby ..."
case "$PACKAGE_MANAGER" in
	apt)	apt-get install -y openjdk-7-jdk ;;
	yum)	yum install -y java-1.7.0-openjdk ;;
	brew)	;;
esac

cd $SRC_DIR

log "Downloading JRuby $JRUBY_VERSION ..."
wget http://jruby.org.s3.amazonaws.com/downloads/$JRUBY_VERSION/jruby-bin-$JRUBY_VERSION.tar.gz

log "Installing JRuby $JRUBY_VERSION ..."
tar -xzvf jruby-bin-$JRUBY_VERSION.tar.gz -C "$RUBIES_DIR"
ln -fs jruby "$RUBIES_DIR/jruby-$JRUBY_VERSION/bin/ruby"

#
# Install Rubinius (https://github.com/postmodern/chruby/wiki/Rubinius)
#
log "Installing dependencies for Rubinius ..."
case "$PACKAGE_MANAGER" in
	apt)
		apt-get install -y gcc g++ automake flex bison ruby-dev rake \
			           zlib1g-dev libyaml-dev libssl-dev \
				   libgdbm-dev libreadline-dev libncurses5-dev

		(apt-get install -y llvm-3.0-dev && update-alternatives --install /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-3.0 30) || true
		;;
	yum)
		yum install -y gcc gcc-c++ automake flex bison ruby-devel \
		               rubygems rubygem-rake llvm-devel zlib-devel \
			       libyaml-devel openssl-devel gdbm-devel \
			       readline-devel ncurses-devel
		;;
	brew)	brew install libyaml gdbm || true ;;
esac

log "Downloading Rubinius $RUBINIUS_VERSION ..."
wget -O rubinius-release-$RUBINIUS_VERSION.tar.gz https://github.com/rubinius/rubinius/archive/release-$RUBINIUS_VERSION.tar.gz

log "Extracting Rubinius $RUBINIUS_VERSION ..."
tar -xzvf rubinius-release-$RUBINIUS_VERSION.tar.gz
cd rubinius-release-$RUBINIUS_VERSION

log "Configuring Rubinius $RUBINIUS_VERSION ..."
./configure --prefix="$RUBIES_DIR/rubinius-$RUBINIUS_VERSION"

log "Compiling Rubinius $RUBINIUS_VERSION ..."
rake build

log "Installing Rubinius $RUBINIUS_VERSION ..."
rake install

#
# Configuration
#
log "Configuring chruby ..."

CHRUBY_CONFIG=`cat <<EOS
[ -n "\\\$BASH_VERSION" ] || [ -n "\\\$ZSH_VERSION" ] || return

source $PREFIX/share/chruby/chruby.sh

RUBIES=($RUBIES_DIR/*)
EOS`

if [[ -d /etc/profile.d/ ]]; then
	# Bash/Zsh
	echo "$CHRUBY_CONFIG" > /etc/profile.d/chruby.sh
	log "Setup complete! Please restart the shell"
else
	warning "Could not determine where to add chruby configuration."
	warning "Please add the following configuration where appropriate:"
	echo
	echo "$CHRUBY_CONFIG"
	echo
fi

#
# Post Install
#
case "$PACKAGE_MANAGER" in
	apt)	;;
	yum)	;;
	brew)
		warning "In order to use JRuby you must install OracleJDK:"
		warning "  http://www.oracle.com/technetwork/java/javase/downloads/index.html"
		;;
esac
