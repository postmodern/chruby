fixtures_dir="$PWD/test/fixtures"
ruby_version_fixtures="$fixtures_dir/ruby_versions"

cat > "$ruby_version_fixtures/.ruby-version" <<EOF
${test_ruby_engine}-${test_ruby_version%*.}
EOF

cat > "$ruby_version_fixtures/modified_version/.ruby-version" <<EOF
system
EOF
