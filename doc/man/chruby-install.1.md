# chruby-install(1) -- Install the selected Ruby with ruby-install.

## SYNOPSIS

`chruby-install` [OPTIONS] [RUBY [VERSION]] [-- CONFIGURE_OPTS ...]

## ARGUMENTS

*RUBY*
  Install Ruby by name.

*VERSION*
	Optionally select Ruby version.

*CONFIGURE_OPTS*
	Additional optional configure arguments.

## OPTIONS

`-h`, `--help`

`-V`, `--version`

See `man ruby-install` for Ruby installation options.

## DESCRIPTION
Installs Ruby, JRuby, Rubinius or MagLev with ruby-install.

[https://github.com/postmodern/ruby-install#readme](https://github.com/postmodern/ruby-install#readme)

And then reloads chruby Rubies.

[https://github.com/postmodern/chruby/blob/master/README.md](https://github.com/postmodern/chruby/blob/master/README.md)

## ARGUMENTS

*RUBY*
	Install Ruby by name.

*VERSION*
	Optionally select the version of selected Ruby.

*CONFIGURE_OPTS*
	Additional optional configure arguments.

## EXAMPLES

Install the current stable version of Ruby:

    $ chruby-install ruby

Install a specific version of Ruby:

    $ chruby-install ruby 1.9.3-p395

## FILES

*/usr/local/src*
	Default root user source directory.
    
*~/src*
	Default non-root user source directory.

*/opt/rubies/$ruby-$version*
	Default root user installation directory.

*~/.rubies/$ruby-$version*
	Default non-root user installation directory.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ruby-install(1), chruby(1), chruby-exec(1), ruby(1), gem(1)
