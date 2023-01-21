# Avoid setting GEM_HOME and GEM_PATH for development of Ruby
function chruby_set_gem_env() {
  return 0
}
