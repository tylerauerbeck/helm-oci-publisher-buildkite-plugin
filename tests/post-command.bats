#!/usr/bin/env bats

setup() {
  
  load "$BATS_PLUGIN_PATH/load.bash"
  # Uncomment to enable stub debugging
  # export GIT_STUB_DEBUG=/dev/tty
}

@test "default chart path" {
  export BUILDKITE_REPO="git@github.com:acme-inc/my-project.git"
  cd tests/data/charts-dir/
  run $PWD/../../../hooks/post-command
  #echo $status >&3
  [ $status -eq 1 ]
  assert_output --partial "Using chart path: charts/"

}

@test "user chart path (add trailing slash)" {
  export BUILDKITE_PLUGIN_HELM_OCI_PUBLISHER_CHART_PATH="."
  cd tests/data/root-chart/
  run $PWD/../../../hooks/post-command
  [ $status -eq 1 ]
  assert_output --partial "Using chart path: ./"
}

@test "user chart path (provided trailing slash)" {
  export BUILDKITE_PLUGIN_HELM_OCI_PUBLISHER_CHART_PATH="./"
  cd tests/data/root-chart/
  run $PWD/../../../hooks/post-command
  [ $status -eq 1 ]
  assert_output --partial "Using chart path: ./"
}

@test "chart path doesn't exist" {
  export BUILDKITE_PLUGIN_HELM_OCI_PUBLISHER_CHART_PATH="this-path/does-not-exist/"
  run $PWD/hooks/post-command
  [ $status -eq 1 ]
  assert_output --partial "Chart.yaml not found"
}

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

@test "use provided name" {
  cd tests/data/root-chart
  export BUILDKITE_PLUGIN_HELM_OCI_PUBLISHER_NAME="my-chart"
  export BUILDKITE_PLUGIN_HELM_OCI_PUBLISHER_CHART_PATH="."
  run $PWD/../../../hooks/post-command
  [ $status -ne 0 ]
  assert_output --partial "Using name: my-chart"
}

@test "name not provided and missing name in Chart.yaml" {
  cd tests/data/missing-name
  export BUILDKITE_PLUGIN_HELM_OCI_PUBLISHER_CHART_PATH="."
  run $PWD/../../../hooks/post-command
  [ $status -eq 1 ]
  assert_output --partial "NAME is not set and Chart.yaml does not contain a name field"
}

@test "missing credentials" {
  cd tests/data/root-chart
  export BUILDKITE_PLUGIN_HELM_OCI_PUBLISHER_CHART_PATH="."
  run $PWD/../../../hooks/post-command
  [ $status -eq 1 ]
  assert_output --partial 'helm registry login" requires at least 1 argument'
}

@test "unable to login to registry" {
  cd tests/data/root-chart
  export BUILDKITE_PLUGIN_HELM_OCI_PUBLISHER_CHART_PATH="."
  export REGISTRY_PASSWORD="somethingverynotreal"
  export REGISTRY_USERNAME="averyfakeuser"
  export REGISTRY="dummyregistry.example.com"
  run $PWD/../../../hooks/post-command
  [ $status -eq 1 ]
  assert_output --partial "Failed to login to registry"
}

# TODO: figure out why we're getting a connection refused in the bats test, but login is fine
#       when run manually
#@test "login to test registry" {
#  cd tests/data/root-chart
#  export BUILDKITE_PLUGIN_HELM_OCI_PUBLISHER_CHART_PATH="."
#  export REGISTRY_PASSWORD="zot"
#  export REGISTRY_USERNAME="zot"
#  export REGISTRY="127.0.0.1:4999"
#  run $PWD/../../../hooks/post-command
#  [ $status -eq 1 ]
#  assert_output --partial "Successfully logged in to registry"
#}