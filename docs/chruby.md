# chruby(1) -- Changes the current Ruby.

## SYNOPSIS

`chruby` [RUBY|VERSION|system] [RUBY_OPTS]

## ARGUMENTS

RUBY Fuzzy matching of Rubies by name.

VERSION Ruby version.

system System ruby.

RUBY_OPTS Additional optional arguements to pass to Ruby.

## DESCRIPTION
Changes the current Ruby version by correctly setting the appropriate environment variables.

[https://github.com/postmodern/chruby/blob/master/README.md](https://github.com/postmodern/chruby/blob/master/README.md)

## OPTIONS

`-h`, `--help`

## EXAMPLES

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

Switch to JRuby in 1.9 mode:
    $ chruby jruby --1.9

Switch back to system Ruby:
    $ chruby system

Switch to an arbitrary Ruby on the fly:
    $ chruby_use /path/to/ruby

##FILES

/opt/rubies

/etc/profile.d/chruby.sh

~/.rubies/

~/.gem/$ruby/$version

/path/to/$ruby/$gemdir

##ENVIRONMENT

PATH Updated to include Rubies and RubyGems bin/ directories.

GEM_HOME

GEM_PATH

RUBY_ROOT

RUBY_ENGINE

RUBY_VERSION

GEM_ROOT

RUBYOPT Optionally set if second arguement is given.

##AUTHOR
Postmodern <postmodern.mod3\@gmail.com>

##SEE ALSO
ruby(1), gem(1)