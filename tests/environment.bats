#!/usr/bin/env bats

setup() {
  
  load "$BATS_PLUGIN_PATH/load.bash"
  # Uncomment to enable stub debugging
  # export GIT_STUB_DEBUG=/dev/tty
}

@test "unset registry" {

  run $PWD/hooks/environment
  #echo $status >&3
  [ $status -eq 1 ]

  assert_output --partial "REGISTRY is not set"

}

@test "registry set" {
    export BUILDKITE_PLUGIN_HELM_OCI_PUBLISHER_REGISTRY="dummy.registry.io"
    run $PWD/hooks/environment
    [ $status -eq 1 ]
    refute_output --partial  "REGISTRY is not set"
}

@test "unset registry user" {

  run $PWD/hooks/environment
  #echo $status >&3
  [ $status -eq 1 ]

  assert_output --partial "REGISTRY_USERNAME is not set"

}

@test "set registry user" {
    export BUILDKITE_PLUGIN_HELM_OCI_PUBLISHER_REGISTRY_USERNAME="my-fake-user"
    run $PWD/hooks/environment
    [ $status -eq 1 ]
    refute_output --partial "REGISTRY_USERNAME is not set"
}

@test "unset registry password" {
    run $PWD/hooks/environment
    [ $status -eq 1 ]
    assert_output --partial "REGISTRY_PASSWORD is not set"
}

@test "set registry password" {
    export BUILDKITE_PLUGIN_HELM_OCI_PUBLISHER_REGISTRY_PASSWORD="fake-password"
    run $PWD/hooks/environment
    [ $status -eq 1 ]
    refute_output --partial "REGISTRY_PASSWORD is not set"
}

@test "all registry variables set" {
    export BUILDKITE_PLUGIN_HELM_OCI_PUBLISHER_REGISTRY="dummy.registry.io"
    export BUILDKITE_PLUGIN_HELM_OCI_PUBLISHER_REGISTRY_USERNAME="dummy-user"
    export BUILDKITE_PLUGIN_HELM_OCI_PUBLISHER_REGISTRY_PASSWORD="fake-password"
    run $PWD/hooks/environment
    [ $status -eq 0 ]
    refute_output
}