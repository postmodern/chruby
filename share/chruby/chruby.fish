set CHRUBY_VERSION '0.3.5'

set -eg RUBIES
test -d "$PREFIX/opt/rubies/"; and set -xg RUBIES $RUBIES $PREFIX/opt/rubies/*
test -d "$HOME/.rubies/";      and set -xg RUBIES $RUBIES $HOME/.rubies/*

function chruby_reset
  test -z $RUBY_ROOT; and return

  for arg in $PATH
    test "$arg" = "$RUBY_ROOT/bin"; and continue

    if test "$UID" != "0"
      test -n "$GEM_HOME"; and test "$arg" = "$GEM_HOME/bin"; and continue
      test -n "$GEM_ROOT"; and test "$arg" = "$GEM_ROOT/bin"; and continue
    end

    set -g NEW_PATH $arg $NEW_PATH
  end

  set -x PATH $NEW_PATH
  set -e NEW_PATH

  if test "$UID" != "0"
    for arg in $GEM_PATH
      test "$arg" = "$GEM_HOME"; and continue
      test "$arg" = "$GEM_ROOT"; and continue
      set -g NEW_GEM_PATH $arg $NEW_GEM_PATH
    end

    set -x GEM_PATH $NEW_GEM_PATH
    set -e NEW_GEM_PATH
    set -e GEM_ROOT
    set -e GEM_HOME
  end

  set -e RUBY_ROOT
  set -e RUBY_ENGINE
  set -e RUBY_VERSION
  set -e RUBYOPT
  return 0
end

function chruby_use
  echo $argv | read -l ruby_path opts

  if not test -x "$ruby_path/bin/ruby"
    echo "chruby: $ruby_path/bin/ruby not executable" >&2
    return 1
  end

  test -n "$RUBY_ROOT"; and chruby_reset

  set -gx RUBY_ROOT $ruby_path
  set -gx RUBYOPT $opts
  set -x PATH $RUBY_ROOT/bin $PATH

  set -gx RUBY_ENGINE  (eval "$RUBY_ROOT/bin/ruby -e 'print RUBY_ENGINE'")
  set -gx RUBY_VERSION (eval "$RUBY_ROOT/bin/ruby -e 'print RUBY_VERSION'")
  set -gx GEM_ROOT     (eval "$RUBY_ROOT/bin/ruby -e 'print Gem.default_dir'")

  if test "$UID" != "0"
    set -gx GEM_HOME "$HOME/.gem/$RUBY_ENGINE/$RUBY_VERSION"
    set -gx GEM_PATH $GEM_HOME $GEM_ROOT $GEM_PATH
    set PATH "$GEM_HOME/bin" $PATH
    set -q $GEM_ROOT; and set PATH "$GEM_ROOT/bin" $PATH
  end

  status -i; and echo "Using $RUBY_ENGINE-$RUBY_VERSION"
  return 0
end

function chruby
  echo $argv | read -l arg
  if test "$arg" = ""
    for dir in $RUBIES
      test "$dir" = "$RUBY_ROOT"; and set star '*'; or set star ' '
      set dir (basename $dir); echo " $star $dir"
    end
    return 0
  end

  switch $argv[1]
    case '-h' '--help'
      echo "usage: chruby [RUBY|VERSION|system] [RUBY_OPTS]"
    case '-v' '--version'
      echo "chruby version $CHRUBY_VERSION"
    case 'system'
      chruby_reset
    case '*'
      echo $argv | read -l ruby opts

      set -l match ''

      for dir in $RUBIES
        set basedir (basename $dir)
        test "$basedir" = "$ruby"; and set match "$dir"
      end

      if test -z "$match"
        echo "chruby: unknown Ruby: $ruby" >&2
        return 1
      end

      chruby_use "$match" "$opts"
  end
end
