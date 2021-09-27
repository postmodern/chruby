. ./test/integration/helper.sh

function test_chruby_RUBIES()
{
	assertNotEquals "did not correctly populate RUBIES" 0 ${#RUBIES[@]}
}

function test_chruby_gauntlet()
{
	local exit_status
	local expected_ruby_engine
	local expected_ruby_version
	local expected_ruby_api
	local expected_gem_home
	local expected_gem_root

	for ruby_root in ${RUBIES[@]}; do
		echo "> chruby_use $ruby_root ..."
		chruby_use "$ruby_root"
		exit_status=$?

		assertEquals "did not exit successfully" 0 "$exit_status"

		assertEquals "did not set RUBY_ROOT correctly" \
			"$ruby_root" \
			"$RUBY_ROOT"

		assertEquals "did not clear the command hash-table to point at the new ruby" \
				"$ruby_root/bin/ruby" \
				"$(command -v ruby 2>/dev/null)"

		# query the ruby for it's engine, version, etc.
		eval "$(RUBYGEMS_GEMDEPS="" "$ruby_root/bin/ruby" - <<EOF
puts "expected_ruby_engine=#{Object.const_defined?(:RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'};"
puts "expected_ruby_version=#{RUBY_VERSION};"
puts "expected_ruby_api=#{RbConfig::CONFIG["ruby_version"]};"
begin; require 'rubygems'; puts "expected_gem_root=#{Gem.default_dir.inspect};"; rescue LoadError; end
EOF
)"
		assertEquals "did not set RUBY_ENGINE correctly" \
			"$expected_ruby_engine" "$RUBY_ENGINE"

		assertEquals "did not set RUBY_VERSION correctly" \
			"$expected_ruby_version" "$RUBY_VERSION"

		if (( UID != 0 )); then
			expected_gem_home="$HOME/.gem/$expected_ruby_engine/$expected_ruby_version"

			assertEquals "did not set GEM_HOME correctly" \
				"$expected_gem_home" \
				"$GEM_HOME"

			assertEquals "did not set GEM_PATH correctly" \
				"$expected_gem_home:$expected_gem_root" \
				"$GEM_PATH"

			assertEquals "did not add GEM_HOME and GEM_ROOT to PATH" "$expected_gem_home/bin:$expected_gem_root/bin:$ruby_root/bin:$__shunit_tmpDir:$original_path" "$PATH"
		else
			assertEquals "did not add the ruby bin/ directory to PATH" "$ruby_root/bin:$__shunit_tmpDir:$original_path" "$PATH"

			assertEquals "did leave GEM_HOME empty" "" "$GEM_HOME"
			assertEquals "did leave GEM_PATH empty" "" "$GEM_PATH"
		fi

		chruby_reset

		assertEquals "did not unset RUBY_ROOT" "" "$RUBY_ROOT"

		assertEquals "did not clean the command hash-table to point at the original ruby" \
				"$original_ruby" \
				"$(command -v ruby 2>/dev/null)"

		assertEquals "did not clean PATH correctly" \
			"$__shunit_tmpDir:$original_path" \
			"$PATH"

		assertEquals "did not unset GEM_HOME" "" "$GEM_HOME"

		assertEquals "did not unset GEM_PATH" "" "$GEM_PATH"
	done
}

SHUNIT_PARENT=$0 . $SHUNIT2
