# chruby

Simple Ruby switcher.

## Features

* Simply modifies `$PATH`.
* Correctly sets `$GEM_HOME` and `$GEM_PATH`.
  * Users: gems are installed into `~/.gem/$ruby/$version`.
  * Root: gems are installed directly into `/path/to/$ruby/lib/ruby/gems/$version`.
* Adds `$GEM_HOME` and `$GEM_PATH` to `$PATH`.
* Additionally sets `$RUBY_PATH`, `$RUBY_VERSION` and `$RUBY_ENGINE`.
* Defaults to the system Ruby.
* Fuzzy matching of Rubies by name.
* Small (~80 LOC).

## Anti-Features

* Does not hook `cd`.
* Does not install executable shims.
* Does not require Rubies be installed into your home directory.
* Does not automatically switch Rubies upon login or when changing directories.
* Does not require write-access to the Ruby directory in order to install gems.

## Install

    wget http://cloud.github.com/downloads/postmodern/chruby/chruby-0.0.1.tar.bz2 \
    gpg --verify chruby-0.0.1.tar.bz2.asc churby-0.0.1.tar.bz2
    tar -xjvf chruby-0.0.1.tar.bz2
    cd chrub-0.0.1/
    make install

### PGP

All releases are [PGP](http://en.wikipedia.org/wiki/Pretty_Good_Privacy) signed 
for security. My PGP Key can be found [here](http://postmodern.github.com/contact.html). To verify that a release was not tampered with:

    wget http://cloud.github.com/downloads/postmodern/chruby/chruby-0.0.1.tar.bz2.asc
    gpg --verify chruby-0.0.1.tar.bz2.asc chruby-0.0.1.tar.bz2

## Configuration

Add the lines following to your `~/.bashrc` or `~/.profile` file:

    . /usr/local/etc/profile.d/chruby.sh
    
    RUBIES=~/src/{ruby,jruby,rubinius}*

### System Wide

Create a `/etc/profile.d/chruby.sh` file, containing the following:

    . /usr/local/etc/profile.d/chruby.sh
    
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

Switch back to system Ruby:

    $ chruby system
    $ echo $PATH
    /usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/hal/bin

Switch to an arbitrary Ruby on the fly:

    $ chruby_use /path/to/ruby

## Alteratives

* [RVM](https://rvm.io/)
* [rbenv](https://github.com/sstephenson/rbenv#readme)
* [rbfu](https://github.com/hmans/rbfu#readme)
