# chruby

Changes the current Ruby.

## Features

* Updates `$PATH`.
  * Also adds RubyGems `bin/` directories to `$PATH`.
* Correctly sets `$GEM_HOME` and `$GEM_PATH`.
  * Users: gems are installed into `~/.gem/$ruby/$version`.
  * Root: gems are installed directly into `/path/to/$ruby/$gemdir`.
* Additionally sets `$RUBY_ROOT`, `$RUBY_ENGINE`, `$RUBY_VERSION` and
  `$GEM_ROOT`.
* Optionally sets `$RUBYOPT` if second argument is given.
* Calls `hash -r` to clear the command-lookup hash-table.
* Fuzzy matching of Rubies by name.
* Defaults to the system Ruby.
* Optionally supports auto-switching and the `.ruby-version` file.
* Supports [bash] and [zsh].
* Small (~80 LOC).
* Has tests.

## Anti-Features

* Does not hook `cd`.
* Does not install executable shims.
* Does not require Rubies be installed into your home directory.
* Does not automatically switch Rubies by default.
* Does not require write-access to the Ruby directory in order to install gems.

## Install

    wget -O chruby-0.3.3.tar.gz https://github.com/postmodern/chruby/archive/v0.3.3.tar.gz
    tar -xzvf chruby-0.3.3.tar.gz
    cd chruby-0.3.3/
    make install

### PGP

All releases are [PGP] signed for security. Instructions on how to import my
PGP key can be found on my [blog][1]. To verify that a release was not tampered 
with:

    wget https://raw.github.com/postmodern/chruby/master/pkg/chruby-0.3.3.tar.gz.asc
    gpg --verify chruby-0.3.3.tar.gz.asc chruby-0.3.3.tar.gz

### setup.sh

chruby also includes a `setup.sh` script, which installs chruby and the latest
releases of [MRI], [JRuby] and [Rubinius]. Simply run the script as root or 
via `sudo`:

    sudo ./scripts/setup.sh

### Homebrew

chruby can also be installed with [homebrew]:

    brew install chruby

### Arch Linux

chruby is already included in the [AUR](https://aur.archlinux.org/):

    yaourt -S chruby

### Rubies

Once chruby has been installed, you may want to install additional Rubies:
This can be done with the [ruby-build] utility or manually:

* [MRI](https://github.com/postmodern/chruby/wiki/MRI)
* [JRuby](https://github.com/postmodern/chruby/wiki/JRuby)
* [Rubinius](https://github.com/postmodern/chruby/wiki/Rubinius)

## Configuration

Add the following to the `/etc/profile.d/chruby.sh`, `~/.bashrc` or
`~/.zshrc` file:

    source /usr/local/share/chruby/chruby.sh

By default chruby will search for Rubies installed into `/opt/rubies/` or
`~/.rubies/`. For non-standard installation locations, simply set the
`RUBIES` variable:

    RUBIES=(
      /opt/jruby-1.7.0
      $HOME/src/rubinius
    )

### Migrating

If you are migrating from another Ruby manager, set `RUBIES` accordingly:

* [RVM]: `RUBIES=(~/.rvm/rubies/*)`
* [rbenv]: `RUBIES=(~/.rbenv/versions/*)`
* [rbfu]: `RUBIES=(~/.rbfu/rubies/*)`

### System Wide

If you wish to enable chruby system-wide, add the following to
`/etc/profile.d/chruby.sh`:

    [ -n "$BASH_VERSION" ] || [ -n "$ZSH_VERSION" ] || return
    
    source /usr/local/share/chruby/chruby.sh

### Auto-Switching

If you want chruby to auto-switch the current version of Ruby when you `cd`
between your different projects, load `auto.sh` after `chruby.sh`:

    source /usr/local/share/chruby/chruby.sh
    source /usr/local/share/chruby/auto.sh

chruby will check the current and parent directories for a [.ruby-version]
file. Other Ruby switchers also understand this file:
https://gist.github.com/1912050

### Default Ruby

If you wish to set a default Ruby, simply call `chruby` in `~/.bashrc` or
`~/.zshrc`:

    chruby ruby-1.9

If you have enabled auto-switching, simply create a `.ruby-version` file:

    echo "ruby-1.9" > ~/.ruby-version

### Integration

For instructions on using chruby with other tools, please see the [wiki]:

* [Cron](https://github.com/postmodern/chruby/wiki/Cron)
* [Capistrano](https://github.com/postmodern/chruby/wiki/Capistrano)
* [Pow](https://github.com/postmodern/chruby/wiki/Pow)

## Examples

List available Rubies:

    $ chruby
       ruby-1.9.3-p392
       jruby-1.7.0
       rubinius-2.0.0-rc1

Select a Ruby:

    $ chruby 1.9.3
    $ chruby
     * ruby-1.9.3-p392
       jruby-1.7.0
       rubinius-2.0.0-rc1
    $ echo $PATH
    /home/hal/.gem/ruby/1.9.3/bin:/opt/rubies/ruby-1.9.3-p392/lib/ruby/gems/1.9.1/bin:/opt/rubies/ruby-1.9.3-p392/bin:/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/home/hal/bin:/home/hal/bin
    $ gem env
    RubyGems Environment:
      - RUBYGEMS VERSION: 1.8.23
      - RUBY VERSION: 1.9.3 (2013-02-06 patchlevel 385) [x86_64-linux]
      - INSTALLATION DIRECTORY: /home/hal/.gem/ruby/1.9.3
      - RUBY EXECUTABLE: /opt/rubies/ruby-1.9.3-p392/bin/ruby
      - EXECUTABLE DIRECTORY: /home/hal/.gem/ruby/1.9.3/bin
      - RUBYGEMS PLATFORMS:
        - ruby
        - x86_64-linux
      - GEM PATHS:
         - /home/hal/.gem/ruby/1.9.3
         - /opt/rubies/ruby-1.9.3-p392/lib/ruby/gems/1.9.1
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

Run a command under a Ruby with `chruby-exec`:

    $ chruby-exec jruby -- gem update

Switch to an arbitrary Ruby on the fly:

    $ chruby_use /path/to/ruby

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

> I wrote ruby-version; however, chruby is already what ruby-version wanted to
> be. I've deprecated ruby-version in favor of chruby.

-- [Wil Moore III](https://github.com/wilmoore)

## Credits

* [mpapis](https://github.com/mpapis) for reviewing the code.
* [havenn](https://github.com/havenwood) for handling the homebrew formula.
* `#bash`, `#zsh`, `#machomebrew` for answering all my questions.

[wiki]: https://github.com/postmodern/chruby/wiki

[bash]: http://www.gnu.org/software/bash/
[zsh]: http://www.zsh.org/
[PGP]: http://en.wikipedia.org/wiki/Pretty_Good_Privacy
[homebrew]: http://mxcl.github.com/homebrew/
[ruby-build]: https://github.com/sstephenson/ruby-build#readme
[.ruby-version]: https://gist.github.com/1912050

[RVM]: https://rvm.io/
[rbenv]: https://github.com/sstephenson/rbenv#readme
[rbfu]: https://github.com/hmans/rbfu#readme
[ry]: https://github.com/jayferd/ry#readme
[ruby-version]: https://github.com/wilmoore/ruby-version#readme

[MRI]: http://www.ruby-lang.org/en/
[JRuby]: http://jruby.org/
[Rubinius]: http://rubini.us/

[1]: http://postmodern.github.com/contact.html#pgp
