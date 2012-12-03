# chruby

Changes the current Ruby.

## Features

* Updates `$PATH`.
  * Also adds RubyGems `bin/` directories to `$PATH`.
* Correctly sets `$GEM_HOME` and `$GEM_PATH`.
  * Users: gems are installed into `~/.gem/$ruby/$version`.
  * Root: gems are installed directly into `/path/to/$ruby/$gemdir`.
* Optionally sets `$RUBYOPT` is a second argument is given.
* Additionally sets `$RUBY`, `$RUBY_ENGINE`, `$RUBY_VERSION` and `$GEM_ROOT`.
* Calls `hash -r` to clear the command-lookup hash-table.
* Fuzzy matching of Rubies by name.
* Defaults to the system Ruby.
* Supports [bash] and [zsh].
* Small (~80 LOC).
* Has tests.

## Anti-Features

* Does not hook `cd`.
* Does not install executable shims.
* Does not require Rubies be installed into your home directory.
* Does not automatically switch Rubies upon login or when changing directories.
* Does not require write-access to the Ruby directory in order to install gems.

## Install

    wget https://github.com/downloads/postmodern/chruby/chruby-0.2.3.tar.gz
    tar -xzvf chruby-0.2.3.tar.gz
    cd chruby-0.2.3/
    make install

### PGP

All releases are [PGP] signed for security. Instructions on how to import my
PGP key can be found on my [blog][1]. To verify that a release was not tampered 
with:

    wget https://github.com/downloads/postmodern/chruby/chruby-0.2.3.tar.gz.asc
    gpg --verify chruby-0.2.3.tar.gz.asc chruby-0.2.3.tar.gz

### Homebrew

chruby can also be installed with [homebrew]:

    brew install https://raw.github.com/postmodern/chruby/master/homebrew/chruby.rb

## Rubies

Once chruby has been installed, you will probably want to install additional
Rubies. This can be done by copying and pasting the following commands,
or via [ruby-build].

### MRI

* Requirements: [libyaml], [zlib], [openssl] and [readline].

        wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p327.tar.gz
        tar -xzvf ruby-1.9.3-p327.tar.gz
        cd ruby-1.9.3-p327
        ./configure --prefix=/usr/local/ruby-1.9.3-p327
        make
        make install

### JRuby

* Requirements: [Java]

        wget http://jruby.org.s3.amazonaws.com/downloads/1.7.0/jruby-bin-1.7.0.tar.gz
        tar -xzvf jruby-bin-1.7.0.tar.gz -C /usr/local
        cd /usr/local/jruby-1.7.0/bin
        ln -s jruby ruby

* For improved load times, install the [jruby-launcher] gem:

        chruby jruby
        gem install jruby-launcher

### Rubinius

* [Requirements](http://rubini.us/doc/en/getting-started/requirements/)

        wget -O rubinius-release-2.0.0-rc1.tar.gz https://github.com/rubinius/rubinius/archive/release-2.0.0-rc1.tar.gz
        tar -xzvf rubinius-release-2.0.0-rc1.tar.gz
        cd rubinius-release-2.0.0-rc1
        ./configure --prefix=/usr/local/rubinius-2.0.0-rc1
        rake
        rake install

## Configuration

Add the following lines to your `~/.bashrc` or `~/.profile` file:

    . /usr/local/share/chruby/chruby.sh
    
    RUBIES=(/usr/local/{ruby,jruby,rubinius}*)

### System Wide

Add the following to `/etc/profile.d/chruby.sh` or `/etc/profile`:

    . /usr/local/share/chruby/chruby.sh
    
    RUBIES=(
      /usr/local/ruby-1.9.3-p237
      /usr/local/jruby-1.7.0
      /usr/local/rubinius-2.0.0-rc1
    )

### Migrating

If you are migrating from another Ruby manager, set `RUBIES` accordingly:

* [RVM]: `RUBIES=(~/.rvm/rubies/*)`
* [rbenv]: `RUBIES=(~/.rbenv/versions/*)`
* [rbfu]: `RUBIES=(~/.rbfu/rubies/*)`

### Default Ruby

If you wish to set a default Ruby, simply call `chruby` in `~/.bashrc`:

    chruby 1.9.3

## Examples

List available Rubies:

    $ chruby
       ruby-1.9.3-p237
       jruby-1.7.0
       rubinius-2.0.0-rc1

Select a Ruby:

    $ chruby 1.9.3
    $ chruby
     * ruby-1.9.3-p237
       jruby-1.7.0
       rubinius-2.0.0-rc1
    $ echo $PATH
    /home/hal/.gem/ruby/1.9.3/bin:/usr/local/ruby-1.9.3-p327/lib/ruby/gems/1.9.1/bin:/usr/local/ruby-1.9.3-p327/bin:/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/home/hal/bin:/home/hal/bin
    $ echo $GEM_HOME
    /home/hal/.gem/ruby/1.9.3
    $ echo $GEM_PATH
    /home/hal/.gem/ruby/1.9.3:/usr/local/ruby-1.9.3-p327/lib/ruby/gems/1.9.1

Switch to JRuby in 1.9 mode:

    $ chruby jruby --1.9
    $ ruby -v
    jruby 1.7.0 (1.9.3p203) 2012-10-22 ff1ebbe on OpenJDK 64-Bit Server VM 1.7.0_09-icedtea-mockbuild_2012_10_17_15_53-b00 [linux-amd64]

Switch back to system Ruby:

    $ chruby system
    $ echo $PATH
    /usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/hal/bin

Switch to an arbitrary Ruby on the fly:

    $ chruby_use /path/to/ruby

### Cron

Select a Ruby within a cron job:

    30 18 * * *   bash -lc "chruby 1.9.3 && /path/to/script"

## Alternatives

* [RVM]
* [rbenv]
* [rbfu]
* [ry]

## Endorsements

> yeah `chruby` is nice, does the limited thing of switching really good,
> the only hope it never grows 

-- [Michal Papis](https://twitter.com/mpapis/status/258049391791841280) of [RVM]

> I just looooove [chruby](#readme) For the first time I'm in total control of
> all aspects of my Ruby installation. 

-- [Marius Mathiesen](https://twitter.com/zmalltalker/status/271192206268829696)

## Credits

* [mpapis](https://github.com/mpapis) for reviewing the code.

[bash]: http://www.gnu.org/software/bash/
[zsh]: http://www.zsh.org/
[PGP]: http://en.wikipedia.org/wiki/Pretty_Good_Privacy
[homebrew]: http://mxcl.github.com/homebrew/
[ruby-build]: https://github.com/sstephenson/ruby-build#readme

[RVM]: https://rvm.io/
[rbenv]: https://github.com/sstephenson/rbenv#readme
[rbfu]: https://github.com/hmans/rbfu#readme
[ry]: https://github.com/jayferd/ry#readme

[flex]: http://flex.sourceforge.net/
[bison]: http://www.gnu.org/software/bison/
[zlib]: http://www.zlib.net/
[libyaml]: http://pyyaml.org/wiki/LibYAML
[openssl]: http://www.openssl.org/
[readline]: http://cnswww.cns.cwru.edu/php/chet/readline/rltop.html
[Java]: http://www.java.com/en/download/index.jsp
[jruby-launcher]: https://github.com/jruby/jruby-launcher

[1]: http://postmodern.github.com/contact.html#pgp
