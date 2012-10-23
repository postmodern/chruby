require 'formula'

class Chruby < Formula

  url 'https://github.com/downloads/postmodern/chruby/chruby-0.2.0.tar.gz'
  homepage 'https://github.com/postmodern/chruby#readme'
  md5 '6b6424e0455101e9f071fd72515c3b38'
  head 'https://github.com/postmodern/chruby.git'

  def install
    system 'make', 'install', "PREFIX=#{prefix}"
  end

  def caveats; <<-EOS.undent
    Add chruby to ~/.bashrc or ~/.profile:

      . #{prefix}/share/chruby/chruby.sh

      RUBIES=(
        /usr/local/ruby-1.9.3
        /opt/jruby-1.7.0
      )

    For system-wide installation, add the above text to /etc/profile.d/chruby.sh

    EOS
  end
end
