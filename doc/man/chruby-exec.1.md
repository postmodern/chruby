# chruby-exec(1) -- Run a command with selected Ruby.

## SYNOPSIS

`chruby-exec` RUBY [RUBYOPTS] -- COMMAND

## ARGUMENTS

*RUBY*
    Change current Ruby based on fuzzy matching of Ruby by name.

*RUBYOPTS*
    Additional optional arguments to pass to Ruby.

*COMMAND*
    Command to run under the selected Ruby.

## OPTIONS

`-h`, `--help`

`-v`, `--version`

## DESCRIPTION
Run a command with the selected Ruby version by correctly setting the appropriate environment variables.

[https://github.com/postmodern/chruby/blob/master/README.md](https://github.com/postmodern/chruby/blob/master/README.md)

## EXAMPLES

Run the command `gem update` under JRuby:
    $ chruby-exec jruby -- gem update

##FILES

*/opt/rubies*
    Primary default Ruby install location.
    
*~/.rubies/*
    Secondary default Ruby install location.

*/etc/profile.d/chruby.sh*
    Application environment settings for chruby.

*~/.gem/$ruby/$version*
    Default gem install location.

##ENVIRONMENT

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

##AUTHOR
Postmodern [postmodern.mod3\@gmail.com](mailto:postmodern.mod3\@gmail.com).

##SEE ALSO
chruby(1), ruby(1), gem(1)
