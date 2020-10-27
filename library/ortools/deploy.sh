#!/usr/bin/env sh

POM_PATH=
JAR_PATH=
SRCJAR_PATH=

REPOSITORY_URL=https://repo.grakn.ai/repository/maven
GROUP_ID=com/google/ortools
ARTIFACT_ID=ortools-java
VERSION=8.0.8283

curl --silent --output /dev/stderr --write-out "%{http_code}" -u "$DEPLOY_MAVEN_USERNAME":"$DEPLOY_MAVEN_PASSWORD" --upload-file "$POM_PATH" "$REPOSITORY_URL"/"$GROUP_ID"/"$ARTIFACT_ID"/"$VERSION"/"$ARTIFACT_ID"-"$VERSION".pom
curl --silent --output /dev/stderr --write-out "%{http_code}" -u "$DEPLOY_MAVEN_USERNAME":"$DEPLOY_MAVEN_PASSWORD" --upload-file "$JAR_PATH" "$REPOSITORY_URL"/"$GROUP_ID"/"$ARTIFACT_ID"/"$VERSION"/"$ARTIFACT_ID"-"$VERSION".jar
curl --silent --output /dev/stderr --write-out "%{http_code}" -u "$DEPLOY_MAVEN_USERNAME":"$DEPLOY_MAVEN_PASSWORD" --upload-file "$SRCJAR_PATH" "$REPOSITORY_URL"/"$GROUP_ID"/"$ARTIFACT_ID"/"$VERSION"/"$ARTIFACT_ID"-"$VERSION"-sources.jar
#curl --silent --output /dev/stderr --write-out "%{http_code}" -u "$DEPLOY_MAVEN_USERNAME":"$DEPLOY_MAVEN_PASSWORD" --upload-file lib.srcjar "$REPOSITORY_URL"/"$GROUP_ID"/"$ARTIFACT_ID"/"$VERSION"/"$ARTIFACT_ID"-"$VERSION"-javadoc.jar
