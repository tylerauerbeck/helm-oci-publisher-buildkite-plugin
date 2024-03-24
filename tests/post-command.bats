#!/usr/bin/env bats

setup() {
  
  load "$BATS_PLUGIN_PATH/load.bash"
  # Uncomment to enable stub debugging
  # export GIT_STUB_DEBUG=/dev/tty
}

#@test "default chart path" {
#
#  run $PWD/hooks/post-command
#  #echo $status >&3
#  [ $status -eq 1 ]
#  assert_output --partial "Using chart path: charts/"
#
#}

#@test "user chart path (add trailing slash)" {
#  export BUILDKITE_PLUGIN_HELM_OCI_PUBLISHER_CHART_PATH="."
#  run $PWD/hooks/post-command
#  [ $status -eq 1 ]
#  assert_output --partial "Using chart path: ./"
#}

#@test "user chart path (provided trailing slash)" {
#    export BUILDKITE_PLUGIN_HELM_OCI_PUBLISHER_CHART_PATH="my-charts-dir/"
#    run $PWD/hooks/post-command
#    [ $status -eq 1 ]
#    assert_output --partial "Using chart path: my-charts-dir/"
#}

@test "find name from default charts path" {
    export BUILDKITE_REPO="git@github.com:acme-inc/my-project.git"
    cd tests/data/charts-dir/
    run $PWD/../../../hooks/post-command
    [ $status -ne 0 ]
    assert_output --partial "Using name: my-project"
    assert_output --partial "chart version: 0.2.0"
    assert_output --partial "app version: 2.16.0"
}

@test "find name from provided charts path" {
    cd tests/data/root-chart
    export BUILDKITE_PLUGIN_HELM_OCI_PUBLISHER_CHART_PATH="."
    run $PWD/../../../hooks/post-command
    [ $status -ne 0 ]
    assert_output --partial "Using name: dummy-chart"
    assert_output --partial "chart version: 0.1.0"
    assert_output --partial "app version: 1.16.0"
}



