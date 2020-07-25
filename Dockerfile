ARG JDK_VERSION="15"
FROM openjdk:${JDK_VERSION}-jdk-alpine

ARG PLANTUML_VERSION="1.2020.9"
COPY ./plantuml /usr/local/bin/plantuml

# TIPS: plantuml requires at least one font
RUN apk add --update-cache graphviz ttf-liberation && \
    wget -O /usr/local/bin/plantuml.jar "http://sourceforge.net/projects/plantuml/files/plantuml.${PLANTUML_VERSION}.jar/download" && \
    rm -rf /var/cache/apk/*

WORKDIR /usr/local/bin
