#!/bin/bash

set -e

#
# Constants
#
MRI_VERSION="1.9.3-p327"
JRUBY_VERSION="1.7.0"
RUBINIUS_VERSION="2.0.0-rc1"

[[ -z "$PREFIX"  ]] && export PREFIX="/usr/local"
[[ -z "$SRC_DIR" ]] && export SRC_DIR="$PREFIX/src"

#
# Functions
#
function log() {
	if [[ -t 1 ]]; then echo -e "\e[1m\e[32m>>>\e[0m \e[1m\e[37m$1\e[0m"
	else                echo ">>> $1"
	fi
}

function error() {
	if [[ -t 1 ]]; then echo -e "!!! $1" >&2
	else		    echo "!!! $1" >&2
	fi
}

#
# Detect the Package Manager
#
if   [[ $(type -t apt-get) == "file" ]]; then PACKAGE_MANAGER="apt"
elif [[ $(type -t yum)     == "file" ]]; then PACKAGE_MANAGER="yum"
elif [[ $(type -t brew)    == "file" ]];
	PACKAGE_MANAGER="homebrew"

	if [[ $(type -t cc) != "file" ]] || [[ $(type -t cpp) != "file" ]]; then
		error "Could not find a C/C++ compiler"
		error "Please install Command Line Tools:"
		error "  https://developer.apple.com/downloads/index.action"
		exit 1
	fi
fi

#
# Install chruby
#
log "Installing chruby ..."
make install

#
# Install MRI (https://github.com/postmodern/chruby/wiki/MRI)
#
log "Installing dependencies for Ruby $RUBY_VERSION ..."

case "$PACKAGE_MANAGER" in
	apt) apt-get install -y build-essential zlib1g-dev libyaml-dev \
			        libssl-dev libgdbm-dev libreadline-dev \
				libncurses5-dev libffi-dev ;;
	yum) yum install -y gcc automake zlib-devel libyaml-devel \
			    openssl-devel gdbm-devel readline-devel \
			    ncurses-devel libffi-devel ;;
	homebrew) brew install libyaml gdbm libffi ;;
esac

cd $SRC_DIR

log "Downloading Ruby $MRI_VERSION ..."
wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-$MRI_VERSION.tar.gz

log "Extracting Ruby $MRI_VERSION ..."
tar -xzvf ruby-$MRI_VERSION.tar.gz
cd ruby-$MRI_VERSION

log "Configuring Ruby $MRI_VERSION ..."
./configure --prefix=$PREFIX/ruby-$MRI_VERSION

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
	homebrew)
		# prompt user to install OracleJDK
		;;
esac

cd $SRC_DIR

log "Downloading JRuby $JRUBY_VERSION ..."
wget http://jruby.org.s3.amazonaws.com/downloads/$JRUBY_VERSION/jruby-bin-$JRUBY_VERSION.tar.gz

log "Installing JRuby $JRUBY_VERSION ..."
tar -xzvf jruby-bin-$JRUBY_VERSION.tar.gz -C $PREFIX
ln -s jruby $PREFIX/jruby-$JRUBY_VERSION/bin/ruby

#
# Install Rubinius (https://github.com/postmodern/chruby/wiki/Rubinius)
#

log "Installing dependencies for Rubinius ..."
case "$PACKAGE_MANAGER" in
	apt)
		# Debian
		apt-get install -y gcc g++ automake flex bison ruby-dev rake \
		zlib1g-dev libyaml-dev libssl-dev libgdbm-dev libreadline-dev \
		libncurses5-dev

		# Ubuntu
		apt-get install -y gcc g++ automake flex bison ruby-dev rake \
			           llvm-3.0-dev zlib1g-dev libyaml-dev \
				   libssl-dev libgdbm-dev libreadline-dev \
				   libncurses5-dev
		update-alternatives --install /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-3.0 30
		;;
	yum)	yum install -y gcc gcc-c++ automake flex bison ruby-devel \
		               rubygems rubygem-rake llvm-devel zlib-devel \
			       libyaml-devel openssl-devel gdbm-devel \
			       readline-devel ncurses-devel ;;
	homebrew)	brew install libyaml gdbm ;;
esac

log "Downloading Rubinius $RUBINIUS_VERSION ..."
wget -O rubinius-release-$RUBINIUS_VERSION.tar.gz https://github.com/rubinius/rubinius/archive/release-$RUBINIUS_VERSION.tar.gz

log "Extracting Rubinius $RUBINIUS_VERSION ..."
tar -xzvf rubinius-release-$RUBINIUS_VERSION.tar.gz
cd rubinius-release-$RUBINIUS_VERSION

log "Configuring Rubinius $RUBINIUS_VERSION ..."
./configure --prefix=/usr/local/rubinius-$RUBINIUS_VERSION

log "Compiling Rubinius $RUBINIUS_VERSION ..."
rake

log "Installing Rubinius $RUBINIUS_VERSION ..."
rake install

CHRUBY_CONFIG=`cat <<EOS
#!/bin/sh

. $PREFIX/share/chruby/chruby.sh

RUBIES=(
  $PREFIX/ruby-$MRI_VERSION
  $PREFIX/jruby-$JRUBY_VERSION
  $PREFIX/rubinius-$RUBINIUS_VERSION
)
EOS`

log "Configuring chruby ..."

if [[ -d /etc/profile.d/ ]]; then
	# GNU/Linux
	echo "$CHRUBY_CONFIG" > /etc/profile.d/chruby.sh
else
	# *nix
	echo "$CHRUBY_CONFIG" >> /etc/profile
fi

log "Setup complete! Please restart the shell"
