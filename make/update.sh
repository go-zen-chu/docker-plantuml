#!/usr/bin/env bash

set -eux

source ./make/version_util.sh

current_jdk_version=$(get_library_ver_dockerfile "JDK")
next_jdk_version=$(increment_simple_version "${current_jdk_version}")
## check new image tag exists
next_jdk_tag_url="https://registry.hub.docker.com/v2/repositories/openjdk/openjdk/tags/${next_jdk_version}-jdk-alpine"
if curl -s -H "Accept: application/json" "${next_jdk_tag_url}" | grep "errinfo" >/dev/null ; then
    next_jdk_version=${current_jdk_version}
fi
echo "openjdk : ${current_jdk_version} -> ${next_jdk_version}"

# update plantuml
current_plantuml_version=$(get_library_ver_dockerfile "PLANTUML")
next_plantuml_patch_version=$(increment_semver_patch "${current_plantuml_version}")
next_plantuml_patch_url="http://downloads.sourceforge.net/project/plantuml/${next_plantuml_patch_version}/plantuml.${next_plantuml_patch_version}.jar"
if ! curl --head -s --fail "${next_plantuml_patch_url}" ; then
    next_plantuml_patch_version=${current_plantuml_version}
fi
echo "plantuml : ${current_plantuml_version} -> ${next_plantuml_patch_version}"

# replace to new version
sed -E "s/ARG JDK_VERSION.*/ARG JDK_VERSION=\"${next_jdk_version}\"/" ./Dockerfile > ./Dockerfile.new && mv ./Dockerfile.new ./Dockerfile
sed -E "s/ARG PLANTUML_VERSION.*/ARG PLANTUML_VERSION=\"${next_plantuml_patch_version}\"/" ./Dockerfile > ./Dockerfile.new && mv ./Dockerfile.new ./Dockerfile

exit 0