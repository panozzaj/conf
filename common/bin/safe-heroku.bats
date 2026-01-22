#!/usr/bin/env bats
#
# Tests for heroku-wrapper
#
# Run with: bats heroku.bats
#

setup() {
  # Create a mock "real heroku" that just records what it was called with
  export MOCK_HEROKU="$BATS_TEST_TMPDIR/mock-heroku"
  cat > "$MOCK_HEROKU" << 'EOF'
#!/bin/bash
echo "MOCK_CALLED_WITH: $*"
exit 0
EOF
  chmod +x "$MOCK_HEROKU"

  # Point the wrapper at our mock (never hits real heroku)
  export REAL_HEROKU="$MOCK_HEROKU"

  # Get path to the wrapper script under test
  export WRAPPER="$BATS_TEST_DIRNAME/safe-heroku"
}

# -----------------------------------------------------------------------------
# Tests: Outside Claude Code session (CLAUDECODE unset)
# -----------------------------------------------------------------------------

@test "outside claude: passes through any command unchanged" {
  unset CLAUDECODE
  run "$WRAPPER" config:set FOO=bar -a myapp
  [ "$status" -eq 0 ]
  [[ "$output" == *"MOCK_CALLED_WITH: config:set FOO=bar -a myapp"* ]]
}

@test "outside claude: passes through destructive commands" {
  unset CLAUDECODE
  run "$WRAPPER" pg:reset -a myapp --confirm myapp
  [ "$status" -eq 0 ]
  [[ "$output" == *"MOCK_CALLED_WITH: pg:reset -a myapp --confirm myapp"* ]]
}

# -----------------------------------------------------------------------------
# Tests: Inside Claude Code session (CLAUDECODE=1)
# -----------------------------------------------------------------------------

@test "in claude: BLOCKS 'config' (may contain secrets)" {
  export CLAUDECODE=1
  run "$WRAPPER" config -a myapp
  [ "$status" -eq 1 ]
  [[ "$output" == *"BLOCKED"* ]]
}

@test "in claude: BLOCKS 'config:get' (may contain secrets)" {
  export CLAUDECODE=1
  run "$WRAPPER" config:get DATABASE_URL -a myapp
  [ "$status" -eq 1 ]
  [[ "$output" == *"BLOCKED"* ]]
}

@test "in claude: BLOCKS 'logs' (may contain sensitive data)" {
  export CLAUDECODE=1
  run "$WRAPPER" logs -a myapp --tail
  [ "$status" -eq 1 ]
  [[ "$output" == *"BLOCKED"* ]]
}

@test "in claude: allows 'ps'" {
  export CLAUDECODE=1
  run "$WRAPPER" ps -a myapp
  [ "$status" -eq 0 ]
  [[ "$output" == *"MOCK_CALLED_WITH: ps -a myapp"* ]]
}

@test "in claude: allows 'apps'" {
  export CLAUDECODE=1
  run "$WRAPPER" apps
  [ "$status" -eq 0 ]
  [[ "$output" == *"MOCK_CALLED_WITH: apps"* ]]
}

@test "in claude: allows 'releases'" {
  export CLAUDECODE=1
  run "$WRAPPER" releases -a myapp
  [ "$status" -eq 0 ]
  [[ "$output" == *"MOCK_CALLED_WITH: releases -a myapp"* ]]
}

@test "in claude: allows 'pg:info'" {
  export CLAUDECODE=1
  run "$WRAPPER" pg:info -a myapp
  [ "$status" -eq 0 ]
  [[ "$output" == *"MOCK_CALLED_WITH: pg:info -a myapp"* ]]
}

@test "in claude: allows bare 'heroku' (no subcommand)" {
  export CLAUDECODE=1
  run "$WRAPPER"
  [ "$status" -eq 0 ]
  [[ "$output" == *"MOCK_CALLED_WITH:"* ]]
}

@test "in claude: allows 'heroku --help'" {
  export CLAUDECODE=1
  run "$WRAPPER" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"MOCK_CALLED_WITH: --help"* ]]
}

@test "in claude: 'allowed' shows allowed commands" {
  export CLAUDECODE=1
  run "$WRAPPER" allowed
  [ "$status" -eq 0 ]
  [[ "$output" == *"Commands allowed"* ]]
  [[ "$output" == *"apps"* ]]
  [[ "$output" == *"ps"* ]]
}

# -----------------------------------------------------------------------------
# Tests: Blocked commands (subcommands not in allowlist)
# -----------------------------------------------------------------------------

@test "in claude: BLOCKS 'config:set'" {
  export CLAUDECODE=1
  run "$WRAPPER" config:set FOO=bar -a myapp
  [ "$status" -eq 1 ]
  [[ "$output" == *"BLOCKED"* ]]
  [[ "$output" == *"config:set"* ]]
  # Ensure mock was NOT called
  [[ "$output" != *"MOCK_CALLED_WITH"* ]]
}

@test "in claude: BLOCKS 'config:unset'" {
  export CLAUDECODE=1
  run "$WRAPPER" config:unset FOO -a myapp
  [ "$status" -eq 1 ]
  [[ "$output" == *"BLOCKED"* ]]
  [[ "$output" != *"MOCK_CALLED_WITH"* ]]
}

@test "in claude: BLOCKS 'ps:scale'" {
  export CLAUDECODE=1
  run "$WRAPPER" ps:scale web=2 -a myapp
  [ "$status" -eq 1 ]
  [[ "$output" == *"BLOCKED"* ]]
  [[ "$output" != *"MOCK_CALLED_WITH"* ]]
}

@test "in claude: BLOCKS 'ps:restart'" {
  export CLAUDECODE=1
  run "$WRAPPER" ps:restart -a myapp
  [ "$status" -eq 1 ]
  [[ "$output" == *"BLOCKED"* ]]
  [[ "$output" != *"MOCK_CALLED_WITH"* ]]
}

@test "in claude: BLOCKS 'pg:reset'" {
  export CLAUDECODE=1
  run "$WRAPPER" pg:reset -a myapp --confirm myapp
  [ "$status" -eq 1 ]
  [[ "$output" == *"BLOCKED"* ]]
  [[ "$output" != *"MOCK_CALLED_WITH"* ]]
}

@test "in claude: BLOCKS 'releases:rollback'" {
  export CLAUDECODE=1
  run "$WRAPPER" releases:rollback v100 -a myapp
  [ "$status" -eq 1 ]
  [[ "$output" == *"BLOCKED"* ]]
  [[ "$output" != *"MOCK_CALLED_WITH"* ]]
}

@test "in claude: BLOCKS 'run'" {
  export CLAUDECODE=1
  run "$WRAPPER" run rails console -a myapp
  [ "$status" -eq 1 ]
  [[ "$output" == *"BLOCKED"* ]]
  [[ "$output" != *"MOCK_CALLED_WITH"* ]]
}

@test "in claude: BLOCKS 'maintenance:on'" {
  export CLAUDECODE=1
  run "$WRAPPER" maintenance:on -a myapp
  [ "$status" -eq 1 ]
  [[ "$output" == *"BLOCKED"* ]]
  [[ "$output" != *"MOCK_CALLED_WITH"* ]]
}

@test "in claude: BLOCKS 'apps:destroy'" {
  export CLAUDECODE=1
  run "$WRAPPER" apps:destroy -a myapp --confirm myapp
  [ "$status" -eq 1 ]
  [[ "$output" == *"BLOCKED"* ]]
  [[ "$output" != *"MOCK_CALLED_WITH"* ]]
}

@test "in claude: BLOCKS 'addons:create'" {
  export CLAUDECODE=1
  run "$WRAPPER" addons:create heroku-postgresql:mini -a myapp
  [ "$status" -eq 1 ]
  [[ "$output" == *"BLOCKED"* ]]
  [[ "$output" != *"MOCK_CALLED_WITH"* ]]
}

@test "in claude: BLOCKS 'buildpacks:add'" {
  export CLAUDECODE=1
  run "$WRAPPER" buildpacks:add heroku/ruby -a myapp
  [ "$status" -eq 1 ]
  [[ "$output" == *"BLOCKED"* ]]
  [[ "$output" != *"MOCK_CALLED_WITH"* ]]
}

# -----------------------------------------------------------------------------
# Tests: Flag parsing (subcommand extraction)
# -----------------------------------------------------------------------------

@test "in claude: subcommand after -a flag" {
  export CLAUDECODE=1
  run "$WRAPPER" -a myapp apps
  [ "$status" -eq 0 ]
  [[ "$output" == *"MOCK_CALLED_WITH: -a myapp apps"* ]]
}

@test "in claude: subcommand after --app flag" {
  export CLAUDECODE=1
  run "$WRAPPER" --app myapp apps
  [ "$status" -eq 0 ]
  [[ "$output" == *"MOCK_CALLED_WITH: --app myapp apps"* ]]
}

@test "in claude: subcommand with --app=value syntax" {
  export CLAUDECODE=1
  run "$WRAPPER" --app=myapp apps
  [ "$status" -eq 0 ]
  [[ "$output" == *"MOCK_CALLED_WITH: --app=myapp apps"* ]]
}

@test "in claude: subcommand after -r flag" {
  export CLAUDECODE=1
  run "$WRAPPER" -r staging ps
  [ "$status" -eq 0 ]
  [[ "$output" == *"MOCK_CALLED_WITH: -r staging ps"* ]]
}

@test "in claude: subcommand after multiple flags" {
  export CLAUDECODE=1
  run "$WRAPPER" -a myapp -r production ps
  [ "$status" -eq 0 ]
  [[ "$output" == *"MOCK_CALLED_WITH: -a myapp -r production ps"* ]]
}

@test "in claude: blocked subcommand after -a flag" {
  export CLAUDECODE=1
  run "$WRAPPER" -a myapp config:set FOO=bar
  [ "$status" -eq 1 ]
  [[ "$output" == *"BLOCKED"* ]]
  [[ "$output" == *"config:set"* ]]
}

@test "in claude: blocked subcommand after --app=value" {
  export CLAUDECODE=1
  run "$WRAPPER" --app=myapp ps:scale web=2
  [ "$status" -eq 1 ]
  [[ "$output" == *"BLOCKED"* ]]
  [[ "$output" == *"ps:scale"* ]]
}

@test "in claude: subcommand before -a flag still works" {
  export CLAUDECODE=1
  run "$WRAPPER" ps -a myapp
  [ "$status" -eq 0 ]
  [[ "$output" == *"MOCK_CALLED_WITH: ps -a myapp"* ]]
}

@test "in claude: subcommand after -t/--team flag" {
  export CLAUDECODE=1
  run "$WRAPPER" -t myteam apps
  [ "$status" -eq 0 ]
  [[ "$output" == *"MOCK_CALLED_WITH: -t myteam apps"* ]]
}

@test "in claude: subcommand after --space flag" {
  export CLAUDECODE=1
  run "$WRAPPER" --space myspace apps
  [ "$status" -eq 0 ]
  [[ "$output" == *"MOCK_CALLED_WITH: --space myspace apps"* ]]
}

@test "in claude: subcommand after --region flag" {
  export CLAUDECODE=1
  run "$WRAPPER" --region us apps
  [ "$status" -eq 0 ]
  [[ "$output" == *"MOCK_CALLED_WITH: --region us apps"* ]]
}

@test "in claude: complex flag combo still finds subcommand" {
  export CLAUDECODE=1
  run "$WRAPPER" --app=myapp -r staging --region eu ps
  [ "$status" -eq 0 ]
  [[ "$output" == *"MOCK_CALLED_WITH: --app=myapp -r staging --region eu ps"* ]]
}
