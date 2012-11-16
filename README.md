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

    wget https://github.com/downloads/postmodern/chruby/chruby-0.2.1.tar.gz
    tar -xzvf chruby-0.2.1.tar.gz
    cd chruby-0.2.1/
    make install

### PGP

All releases are [PGP] signed for security. Instructions on how to import my
PGP key can be found on my [blog][1]. To verify that a release was not tampered 
with:

    wget https://github.com/downloads/postmodern/chruby/chruby-0.2.1.tar.gz.asc
    gpg --verify chruby-0.2.1.tar.gz.asc chruby-0.2.1.tar.gz

### Homebrew

chruby can also be installed with [homebrew]:

    brew install https://raw.github.com/postmodern/chruby/master/homebrew/chruby.rb

## Configuration

Add the following lines to your `~/.bashrc` or `~/.profile` file:

    . /usr/local/share/chruby/chruby.sh
    
    RUBIES=~/src/{ruby,jruby,rubinius}*

### System Wide

Add the following to `/etc/profile.d/chruby.sh` or `/etc/profile`:

    . /usr/local/share/chruby/chruby.sh
    
    RUBIES=(
      /usr/local/ruby-1.8.7-p370
      /usr/local/ruby-1.9.3-p194
      /usr/local/jruby-1.6.7.2
      /usr/local/rubinius
    )

## Examples

List available Rubies:

    $ chruby
       ruby-1.8.7-p370
       ruby-1.9.3-p194
       jruby-1.6.7.2
       rubinius

Select a Ruby:

    $ chruby 1.8
    $ chruby
     * ruby-1.8.7-p370
       ruby-1.9.3-p194
       jruby-1.6.7.2
       rubinius
    $ echo $PATH
    /home/hal/.gem/ruby/1.8.7/bin:/usr/local/ruby-1.8.7-p370/lib/ruby/gems/1.8/bin:/usr/local/ruby-1.8.7-p370/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/hal/bin
    $ echo $GEM_HOME
    /home/hal/.gem/ruby/1.8.7
    $ echo $GEM_PATH
    /home/hal/.gem/ruby/1.8.7:/usr/local/ruby-1.8.7-p370/lib/ruby/gems/1.8

Switch to JRuby in 1.9 mode:

    $ chruby jruby --1.9
    $ ruby -v
    jruby 1.6.7.2 (ruby-1.9.2-p312) (2012-05-01 26e08ba) (OpenJDK 64-Bit Server VM 1.6.0_24) [linux-amd64-java]

Switch back to system Ruby:

    $ chruby system
    $ echo $PATH
    /usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/hal/bin

Switch to an arbitrary Ruby on the fly:

    $ chruby_use /path/to/ruby

## Alternatives

* [RVM]
* [rbenv]
* [rbfu]

## Endorsements

> yeah `chruby` is nice, does the limited thing of switching really good,
> the only hope it never grows 

-- [Michal Papis](https://twitter.com/mpapis/status/258049391791841280) of [RVM]

## Credits

* [mpapis](https://github.com/mpapis) for reviewing the code.

[bash]: http://www.gnu.org/software/bash/
[zsh]: http://www.zsh.org/
[PGP]: http://en.wikipedia.org/wiki/Pretty_Good_Privacy
[homebrew]: http://mxcl.github.com/homebrew/

[RVM]: https://rvm.io/
[rbenv]: https://github.com/sstephenson/rbenv#readme
[rbfu]: https://github.com/hmans/rbfu#readme

[1]: http://postmodern.github.com/contact.html#pgp
