#!/usr/bin/env bash

set -eux

source ./make/version_util.sh

current_jdk_version=$(get_library_ver_dockerfile "JDK")
next_jdk_version=$(increment_simple_version "${current_jdk_version}")
## check new image tag exists
next_jdk_tag_url="https://registry.hub.docker.com/v2/repositories/openjdk/openjdk/tags/${next_jdk_version}-jdk-alpine"
if curl -s -H "Accept: application/json" "${next_jdk_tag_url}" | grep "errinfo" >/dev/null ; then
    echo "found new JDK version: ${next_jdk_version}"
else
    echo "could not find new JDK version"
    next_jdk_version=${current_jdk_version}
fi
echo -e "\033[32mopenjdk : ${current_jdk_version} -> ${next_jdk_version}\033[m"

# update plantuml
current_plantuml_version=$(get_library_ver_dockerfile "PLANTUML")
# TODO: updating major version
major_version=$(echo "${current_plantuml_version}" | awk -F'.' '{print $1}')
# TIPS: plantuml has unique versioning using Year for minor version
current_year=$(date +"%Y")
next_patch_version=$(echo "${current_plantuml_version}" | awk -F'.' '{printf "%d", ($3+1)}')
next_plantuml_version="${major_version}.${current_year}.${next_patch_version}"
next_plantuml_patch_url="http://downloads.sourceforge.net/project/plantuml/${next_plantuml_version}/plantuml.${next_plantuml_version}.jar"
if curl --head -s --fail "${next_plantuml_patch_url}" ; then
    echo "found new plantuml version: ${next_plantuml_version}"
else
    echo "could not find new plantuml version"
    next_plantuml_version=${current_plantuml_version}
fi
echo -e "\033[32mplantuml : ${current_plantuml_version} -> ${next_plantuml_version}\033[m"

# replace to new version
sed -E "s/ARG JDK_VERSION.*/ARG JDK_VERSION=\"${next_jdk_version}\"/" ./Dockerfile > ./Dockerfile.new && mv ./Dockerfile.new ./Dockerfile
sed -E "s/ARG PLANTUML_VERSION.*/ARG PLANTUML_VERSION=\"${next_plantuml_version}\"/" ./Dockerfile > ./Dockerfile.new && mv ./Dockerfile.new ./Dockerfile

git --no-pager diff Dockerfile

exit 0