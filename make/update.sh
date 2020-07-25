#!/usr/bin/env bash

# update openjdk image
current_jdk_version=$(awk '/ARG JDK_VERSION.*/ {
    match($0, /"(.+)"/);
    print substr($0, RSTART+1, RLENGTH-2);
}' ./Dockerfile)
next_jdk_version=$((current_jdk_version+1))
## check new image tag exists
next_jdk_tag_url="https://registry.hub.docker.com/v2/repositories/openjdk/openjdk/tags/${next_jdk_version}-jdk-alpine"
if curl -s -H "Accept: application/json" ${next_jdk_tag_url} | grep "errinfo" >/dev/null ; then
    next_jdk_version=${current_jdk_version}
    echo "found new JDK version: ${next_jdk_version}"
else
    echo "could not find new JDK version"
fi
echo "openjdk : ${current_jdk_version} -> ${next_jdk_version}"

# update plantuml
current_plantuml_version=$(awk '/ARG PLANTUML_VERSION.*/ {
    match($0, /"(.+)"/);
    print substr($0, RSTART+1, RLENGTH-2);
}' ./Dockerfile)
# TODO: updating major version
major_version=$(echo "${current_plantuml_version}" | awk -F'.' '{print $1}')
current_year=$(date +"%Y")
next_patch_version=$(echo "${current_plantuml_version}" | awk -F'.' '{printf "%d", ($3+1)}')
next_plantuml_version="${major_version}.${current_year}.${next_patch_version}"
next_plantuml_version_url="http://downloads.sourceforge.net/project/plantuml/${next_plantuml_version}/plantuml.${next_plantuml_version}.jar"
if curl --head -s --fail "${next_plantuml_version_url}" ; then
    echo "found new plantuml version: ${next_plantuml_version}"
else
    echo "could not find new plantuml version"
    next_plantuml_version=${current_plantuml_version}
fi
echo "plantuml : ${current_plantuml_version} -> ${next_plantuml_version}"

sed -E "s/ARG JDK_VERSION.*/ARG JDK_VERSION=\"${next_jdk_version}\"/" ./Dockerfile > ./Dockerfile.new && mv ./Dockerfile.new ./Dockerfile
sed -E "s/ARG PLANTUML_VERSION.*/ARG PLANTUML_VERSION=\"${next_plantuml_version}\"/" ./Dockerfile > ./Dockerfile.new && mv ./Dockerfile.new ./Dockerfile

git --no-pager diff

exit 0