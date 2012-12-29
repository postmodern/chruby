### 0.3.1 / 2012-12-29

* Fixed the auto-detection of `~/.rubies/*`.
* Check if `bin/ruby` exists and is executable before switching to a Ruby.
* Prevent `export=""` from accidentally being set under [zsh].
* Prevent `script/setup.sh` from exiting if a `brew install` fails because all
  packages are already installed.
* Updated the example `/etc/profile.d/chruby.sh` to only load under [bash]
  and [zsh].

### 0.3.0 / 2012-12-20

* Added the `chruby-exec` utility for use in `crontab` or with Continuous
  Integration (CI).
* Added support for auto-detecting Rubies installed into `/opt/rubies/` or
  `~/.rubies/`.
* Added `share/chruby/auto.sh`, which provides support for auto-switching
  to Rubies specified in the [.ruby-version](https://gist.github.com/1912050)
  file.
* Removed the "short circuit" check in `chruby_use`, to allow forcibly
  switching to the current Ruby, in case `PATH` or `GEM_PATH` become corrupted.

### 0.2.6 / 2012-12-18

* Forcibly switch to system Ruby when loading `share/chruby/chruby.sh`.
  This fixes switching issues for [tmux] users.

### 0.2.5 / 2012-12-15

* Renamed the `RUBY` environment variable to `RUBY_ROOT` to avoid breaking
  the `FileUtils#ruby` method in [rake](http://rake.rubyforge.org/).
* Do not unset `GEM_HOME`, `GEM_PATH`, `GEM_ROOT` if running under root.

### 0.2.4 / 2012-12-13

* Added a `Vagrantfile` for testing chruby in various environments.
* Changed all code and examples to reference `/opt/rubies/`.
* Ensure all error messages are printed to stderr.
* Refactored `scripts/setup.sh` to manually install all Rubies and install any
  dependencies via the System Package Manager.
* PGP signatures are now stored in `pkg/`.

#### Makefile

* Updated the `Makefile` to be compatible with BSD automake.
* Do not override `PREFIX`.
* Added a `test` task.

#### Homebrew

* Use `HOMEBREW_PREFIX`.
* Use `sha1` instead of `md5` (deprecated).
* No longer dynamically generate the example configuration.

### 0.2.3 / 2012-11-19

* Updated the `Makefile` to be compatible with the [dash] shell.
* Use inline substring substitutions instead of `sed`.

### 0.2.2 / 2012-11-17

* Use `typeset` to declare `RUBIES` as an indexed Array.
* Use the correct globbed Array syntax for both [zsh] and [bash].
* Improved the post-installation message in the [homebrew] recipe to auto-detect
  [RVM], [rbenv] and [rbfu].

### 0.2.1 / 2012-10-23

* Fixed `make install` to work on OS X.
* Added a [homebrew] recipe.

### 0.2.0 / 2012-10-16

* Install `chruby.sh` into `$PREFIX/share/chruby/`.

### 0.1.2 / 2012-08-29

* Check if `$RUBY` _and_ `$RUBYOPT` are different from the arguments passed to
  `chruby_use`.
* Fixed a spelling error in the README (thanks Ian Barnett).

### 0.1.1 / 2012-08-24

* Added unit-tests using [shunit2](http://code.google.com/p/shunit2/)
* Improved sanitation of `$PATH` in `chruby_reset`. (thanks mpapis)
* If the desired Ruby is already in use, immediately return from `chruby_use`.
* Export `$RUBY_ENGINE`, `$RUBY_VERSION`, `$GEM_ROOT` in `chruby_use`.

### 0.1.0 / 2012-08-18

* Added support for [zsh].
* Renamed the `$RUBY_PATH` variable to `$RUBY`.
* Set the `$RUBY_ENGINE` variable.
* Set the `$GEM_ROOT` variable to `Gem.default_dir`.
  This supports the custom RubyGems directory used by [Rubinius].
* Only initialize the `$RUBIES` variable if it does not have a value.

### 0.0.2 / 2012-08-14

* Added a `LICENSE.txt`.
* Added a `ChangeLog.md`.
* Updated the `Makefile` to generate proper tar archives.

### 0.0.1 / 2012-08-01

* Initial release.

[dash]: http://gondor.apana.org.au/~herbert/dash/
[bash]: http://www.gnu.org/software/bash/
[zsh]: http://www.zsh.org/
[tmux]: http://tmux.sourceforge.net/

[Rubinius]: http://rubini.us/
[homebrew]: http://mxcl.github.com/homebrew/

[RVM]: https://rvm.io/
[rbenv]: https://github.com/sstephenson/rbenv#readme
[rbfu]: https://github.com/hmans/rbfu#readme
