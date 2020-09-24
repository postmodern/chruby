# chruby(1) -- Changes the current Ruby.

## SYNOPSIS

`chruby` [OPTIONS | <RUBY|VERSION|system> [<RUBY_OPTS>]]

## ARGUMENTS

*RUBY|VERSION*
    Change current Ruby based on fuzzy matching of Ruby by name.

*system*
    Change current Ruby to system Ruby.

*RUBY_OPTS*
    Additional optional arguments to pass to Ruby.

## OPTIONS

`--reload`
    Reloads the list of available Rubies

`-h`, `--help`

`-v`, `--version`

## DESCRIPTION
Changes the current Ruby version by correctly setting the appropriate environment variables.

[https://github.com/postmodern/chruby/blob/master/README.md](https://github.com/postmodern/chruby/blob/master/README.md)

## EXAMPLES

List available Rubies:
    $ chruby
       ruby-1.9.3-p362
       jruby-1.7.2
       rubinius-2.0.0-rc1

Select a Ruby:
    $ chruby 1.9.3
    $ chruby
     * ruby-1.9.3-p362
       jruby-1.7.2
       rubinius-2.0.0-rc1

Switch to JRuby in 1.9 mode:
    $ chruby jruby --1.9

Switch back to system Ruby:
    $ chruby system

Switch to an arbitrary Ruby on the fly:
    $ chruby_use /path/to/ruby

## FILES

*/opt/rubies*
    Primary default Ruby install location.
    
*~/.rubies/*
    Secondary default Ruby install location.

*/etc/profile.d/chruby.sh*
    Application environment settings for chruby.

*~/.gem/$ruby/$version*
    Default gem install location.

## ENVIRONMENT

*PATH*
    Updates the PATH environment variable to include Rubies and RubyGems bin/ directories.

*GEM_HOME*
    Default repository location for gem installation.

*GEM_PATH*
    A colon-separated list of gem repository directories.
    
*GEM_ROOT*

*RUBY_ROOT*

*RUBY_ENGINE*
    Name of Ruby implementation.

*RUBY_VERSION*
    Ruby version number.

*RUBYOPT*
    Optionally set if additional Ruby options are given.

## AUTHOR
Postmodern [postmodern.mod3\@gmail.com](mailto:postmodern.mod3\@gmail.com).

## SEE ALSO
chruby-exec(1), ruby(1), gem(1)
