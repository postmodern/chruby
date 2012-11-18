require 'formula'

class Chruby < Formula

  url 'https://github.com/downloads/postmodern/chruby/chruby-0.2.1.tar.gz'
  homepage 'https://github.com/postmodern/chruby#readme'
  md5 '8ed8b855e95a495417c56553afc7b347'
  head 'https://github.com/postmodern/chruby.git'

  def install
    system 'make', 'install', "PREFIX=#{prefix}"
  end

  def caveats
    alternatives = {
      'RVM'   => '~/.rvm/rubies',
      'rbenv' => '~/.rbenv/versions',
      'rbfu'  => '~/.rbfu/rubies'
    }

    ruby_manager, rubies_dir = alternatives.find do |name,dir|
      File.directory?(File.expand_path(dir))
    end

    message = %{
    Add chruby to ~/.bashrc or ~/.profile:

      . #{prefix}/share/chruby/chruby.sh
    }

    if rubies_dir
      message << %{
      RUBIES=(#{rubies_dir}/*)
      }
    else
      message << %{
      RUBIES=(
        /usr/local/ruby-1.9.3-p327
        /usr/local/jruby-1.7.0
        /usr/local/rubinius-2.0.0-rc1
      )
      }
    end

    message << %{
    For system-wide installation, add the above text to /etc/profile.

    }

    return message.undent
  end
end
