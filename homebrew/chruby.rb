require 'formula'

class Chruby < Formula

  url 'https://github.com/downloads/postmodern/chruby/chruby-0.2.1.tar.gz'
  homepage 'https://github.com/postmodern/chruby#readme'
  md5 '8ed8b855e95a495417c56553afc7b347'
  head 'https://github.com/postmodern/chruby.git'

  def install
    system 'make', 'install', "PREFIX=#{prefix}"
  end

  def caveats; <<-EOS.undent
    Add chruby to ~/.bashrc or ~/.profile:

      . #{prefix}/share/chruby/chruby.sh

      RUBIES=(
        # Examples:
        #
        # /usr/local/ruby-1.9.3
        # /opt/jruby-1.7.0
        # #{ENV['HOME']}/.rbenv/versions/2.0.0-preview1
        # #{ENV['HOME']}/.rvm/gems/rbx-2.0.0-rc1
      )

    $RUBIES should contain a list of existing Ruby installation paths.

    For system-wide installation, add the above text to /etc/profile.

    EOS
  end
end
