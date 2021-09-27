[[ -z "$SHUNIT2"     ]] && SHUNIT2=/usr/share/shunit2/shunit2
[[ -n "$ZSH_VERSION" ]] && setopt shwordsplit

unset GEM_HOME GEM_PATH

. ${PREFIX:-/usr/local}/share/chruby/chruby.sh

chruby_reset

# Capture certain env variables so we can restore them
original_path="$PATH"
original_pwd="$PWD"
original_ruby="$(command -v ruby 2>/dev/null)"
original_gem="$(command -v gem 2>/dev/null)"

setUp() { return; }
tearDown() { return; }
oneTimeTearDown() { return; }
