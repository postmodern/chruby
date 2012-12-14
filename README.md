# chruby

Changes the current Ruby.

## Features

* Updates `$PATH`.
  * Also adds RubyGems `bin/` directories to `$PATH`.
* Correctly sets `$GEM_HOME` and `$GEM_PATH`.
  * Users: gems are installed into `~/.gem/$ruby/$version`.
  * Root: gems are installed directly into `/path/to/$ruby/$gemdir`.
* Additionally sets `$RUBY`, `$RUBY_ENGINE`, `$RUBY_VERSION` and `$GEM_ROOT`.
* Optionally sets `$RUBYOPT` if second argument is given.
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

    wget https://github.com/postmodern/chruby/archive/v0.2.3.tar.gz -O chruby-0.2.3.tar.gz
    tar -xzvf chruby-0.2.3.tar.gz
    cd chruby-0.2.3/
    make install

### PGP

All releases are [PGP] signed for security. Instructions on how to import my
PGP key can be found on my [blog][1]. To verify that a release was not tampered 
with:

    wget https://github.com/downloads/postmodern/chruby/chruby-0.2.3.tar.gz.asc
    gpg --verify chruby-0.2.3.tar.gz.asc chruby-0.2.3.tar.gz

### setup.sh

chruby also includes a `setup.sh` script, which installs chruby and the latest
releases of [MRI], [JRuby] and [Rubinius]. Simply run the script as root or 
via `sudo`:

    $ sudo ./scripts/setup.sh

### Homebrew

chruby can also be installed with [homebrew]:

    brew install https://raw.github.com/postmodern/chruby/master/homebrew/chruby.rb

### Rubies

Once chruby has been installed, you may want to install additional Rubies:
This can be done with the [ruby-build] utility or manually:

* [MRI](https://github.com/postmodern/chruby/wiki/MRI)
* [JRuby](https://github.com/postmodern/chruby/wiki/JRuby)
* [Rubinius](https://github.com/postmodern/chruby/wiki/Rubinius)

## Configuration

Add the following lines to your `~/.bashrc` or `~/.profile` file:

    source /usr/local/share/chruby/chruby.sh
    
    RUBIES=(/opt/rubies/*)

### System Wide

Add the following to `/etc/profile.d/chruby.sh` or `/etc/profile`:

    source /usr/local/share/chruby/chruby.sh
    
    RUBIES=(
      /opt/rubies/ruby-1.9.3-p327
      /opt/rubies/jruby-1.7.0
      /opt/rubies/rubinius-2.0.0-rc1
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
       ruby-1.9.3-p327
       jruby-1.7.0
       rubinius-2.0.0-rc1

Select a Ruby:

    $ chruby 1.9.3
    $ chruby
     * ruby-1.9.3-p327
       jruby-1.7.0
       rubinius-2.0.0-rc1
    $ echo $PATH
    /home/hal/.gem/ruby/1.9.3/bin:/opt/rubies/ruby-1.9.3-p327/lib/ruby/gems/1.9.1/bin:/opt/rubies/ruby-1.9.3-p327/bin:/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/home/hal/bin:/home/hal/bin
    $ gem env
    RubyGems Environment:
      - RUBYGEMS VERSION: 1.8.23
      - RUBY VERSION: 1.9.3 (2012-11-10 patchlevel 327) [x86_64-linux]
      - INSTALLATION DIRECTORY: /home/hal/.gem/ruby/1.9.3
      - RUBY EXECUTABLE: /opt/rubies/ruby-1.9.3-p327/bin/ruby
      - EXECUTABLE DIRECTORY: /home/hal/.gem/ruby/1.9.3/bin
      - RUBYGEMS PLATFORMS:
        - ruby
        - x86_64-linux
      - GEM PATHS:
         - /home/hal/.gem/ruby/1.9.3
         - /opt/rubies/ruby-1.9.3-p327/lib/ruby/gems/1.9.1
      - GEM CONFIGURATION:
         - :update_sources => true
         - :verbose => true
         - :benchmark => false
         - :backtrace => false
         - :bulk_threshold => 1000
         - "gem" => "--no-rdoc"
      - REMOTE SOURCES:
         - http://rubygems.org/

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
* [ruby-version]

## Endorsements

> yeah `chruby` is nice, does the limited thing of switching really good,
> the only hope it never grows 

-- [Michal Papis](https://twitter.com/mpapis/status/258049391791841280) of [RVM]

> I just looooove [chruby](#readme) For the first time I'm in total control of
> all aspects of my Ruby installation. 

-- [Marius Mathiesen](https://twitter.com/zmalltalker/status/271192206268829696)

> Written by Postmodern, it's basically the simplest possible thing that can
> work.

-- [Steve Klabnik](http://blog.steveklabnik.com/posts/2012-12-13-getting-started-with-chruby)

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
[ruby-version]: https://github.com/wilmoore/ruby-version#readme

[MRI]: http://www.ruby-lang.org/en/
[JRuby]: http://jruby.org/
[Rubinius]: http://rubini.us/

[1]: http://postmodern.github.com/contact.html#pgp
