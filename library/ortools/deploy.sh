#!/usr/bin/env sh

REPOSITORY_URL=https://repo.grakn.ai/repository/maven
GROUP_ID=com/google/ortools
ARTIFACT_ID=ortools-java
VERSION=8.0.8283

curl --silent --output /dev/stderr --write-out "%{http_code}" -u "$DEPLOY_MAVEN_USERNAME":"$DEPLOY_MAVEN_PASSWORD" --upload-file assemble-maven_pom.xml "$REPOSITORY_URL"/"$GROUP_ID"/"$ARTIFACT_ID"/"$VERSION"/"$ARTIFACT_ID"-"$VERSION".pom
curl --silent --output /dev/stderr --write-out "%{http_code}" -u "$DEPLOY_MAVEN_USERNAME":"$DEPLOY_MAVEN_PASSWORD" --upload-file lib.jar "$REPOSITORY_URL"/"$GROUP_ID"/"$ARTIFACT_ID"/"$VERSION"/"$ARTIFACT_ID"-"$VERSION".jar
curl --silent --output /dev/stderr --write-out "%{http_code}" -u "$DEPLOY_MAVEN_USERNAME":"$DEPLOY_MAVEN_PASSWORD" --upload-file lib.srcjar "$REPOSITORY_URL"/"$GROUP_ID"/"$ARTIFACT_ID"/"$VERSION"/"$ARTIFACT_ID"-"$VERSION"-sources.jar
curl --silent --output /dev/stderr --write-out "%{http_code}" -u "$DEPLOY_MAVEN_USERNAME":"$DEPLOY_MAVEN_PASSWORD" --upload-file lib.srcjar "$REPOSITORY_URL"/"$GROUP_ID"/"$ARTIFACT_ID"/"$VERSION"/"$ARTIFACT_ID"-"$VERSION"-javadoc.jar
