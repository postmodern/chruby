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

[zsh]: http://www.zsh.org/
[Rubinius]: http://rubini.us/
