#!/usr/bin/env bash

# script from : https://github.com/go-zen-chu/version_util

set -u

# get_library_ver_dockerfile parse library version from Dockerfile
# version has to be written like `ARG JAVA_VERSION "18"` in Dockerfile
function get_library_ver_dockerfile () {
    # set arg like JAVA
    library_capital_name=$1
    # optional arg. If 2nd arg is not given, use Dockerfile
    docker_file_path="${2-Dockerfile}"
    # TIPS: create regex pattern and use in match
    current_version=$(awk -v pat="ARG ${library_capital_name}_VERSION=\"(.*)\"" 'match($0, pat, m) {
        print m[1];
    }' "${docker_file_path}")
    echo "${current_version}"
}

# increment_simple_version just increment version number of simple format
function increment_simple_version () {
    # ver is string like v10 or 10
    ver=$1
    updated_version=$(awk 'match($0, /(.*)([0-9]+)/, m) {
        printf "%s%d", m[1], (m[2]+1);
    }' <(echo "${ver}"))
    echo "${updated_version}"
}

# increment_semver_major updates major version of semver
function increment_semver_major () {
    # semver supposed to be like 1.32.12 or v2.2.4
    semver=$1
    updated_version=$(awk 'match($0, /(.*)([0-9]+)\.([0-9]+)\.([0-9]+)/, m) {
        printf "%s%d.%d.%d", m[1], (m[2]+1), m[3], m[4];
    }' <(echo "${semver}"))
    echo "${updated_version}"
}

# increment_semver_minor updates minor version of semver
function increment_semver_minor () {
    # semver supposed to be like 1.32.12 or v2.2.4
    semver=$1
    updated_version=$(awk 'match($0, /(.*)([0-9]+)\.([0-9]+)\.([0-9]+)/, m) {
        printf "%s%d.%d.%d", m[1], m[2], (m[3]+1), m[4];
    }' <(echo "${semver}"))
    echo "${updated_version}"
}

# increment_semver_patch updates patch version of semver
function increment_semver_patch () {
    # semver supposed to be like 1.32.12 or v2.2.4
    semver=$1
    updated_version=$(awk 'match($0, /(.*)([0-9]+)\.([0-9]+)\.([0-9]+)/, m) {
        printf "%s%d.%d.%d", m[1], m[2], m[3], (m[4]+1);
    }' <(echo "${semver}"))
    echo "${updated_version}"
}
