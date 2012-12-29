#!/bin/bash

set -e

#
# Constants
#
MRI_VERSION="1.9.3-p362"
JRUBY_VERSION="1.7.0"
RUBINIUS_VERSION="2.0.0-rc1"

[[ -z "$PREFIX"      ]] && export PREFIX="/usr/local"
[[ -z "$SRC_DIR"     ]] && export SRC_DIR="/usr/local/src"
[[ -z "$RUBIES_DIR"  ]] && export RUBIES_DIR="/opt/rubies"

#
# Functions
#
function log() {
	if [[ -t 1 ]]; then echo -e "\e[1m\e[32m>>>\e[0m \e[1m\e[37m$1\e[0m"
	else                echo ">>> $1"
	fi
}

function error() {
	if [[ -t 1 ]]; then echo -e "\e[1m\e[31m!!!\e[0m \e[1m\e[37m$1\e[0m" >&2
	else		    echo "!!! $1" >&2
	fi
}

function warning() {
	if [[ -t 1 ]]; then echo -e "\e[1m\e[33m***\e[0m \e[1m\e[37m$1\e[0m" >&2
	else		    echo "*** $1" >&2
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
	brew)	brew install libyaml gdbm libffi || true ;;
esac

cd $SRC_DIR

log "Downloading Ruby $MRI_VERSION ..."
wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-$MRI_VERSION.tar.gz

log "Extracting Ruby $MRI_VERSION ..."
tar -xzvf ruby-$MRI_VERSION.tar.gz
cd ruby-$MRI_VERSION

log "Configuring Ruby $MRI_VERSION ..."
./configure --prefix="$RUBIES_DIR/ruby-$MRI_VERSION"

log "Compiling Ruby $MRI_VERSION ..."
make

log "Installing Ruby $MRI_VERSION ..."
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
