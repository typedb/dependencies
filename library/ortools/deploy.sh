#!/usr/bin/env sh

set -ex

if [[ -z "$DEPLOY_MAVEN_USERNAME" ]]; then
    echo "username should be passed via \$DEPLOY_MAVEN_USERNAME env variable";
    exit 1;
fi
if [[ -z "$DEPLOY_MAVEN_PASSWORD" ]]; then
    echo "password should be passed via \$DEPLOY_MAVEN_PASSWORD env variable";
    exit 1;
fi

REPOSITORY_URL=https://repo.grakn.ai/repository/maven
GROUP_ID=com/google/ortools
VERSION=8.0.8283

curl --write-out '%{http_code}' -u ganesh:smrH91hRXX47xTnBkWez --upload-file external/ortools_osx/pom-runtime.xml https://repo.grakn.ai/repository/maven/com/google/ortools/ortools-darwin-test-4/8.0.8283/ortools-darwin-test-4-8.0.8283.txt

##################
# ortools-darwin #
##################
ORTOOLS_DARWIN_ARTIFACT_ID=ortools-darwin
ORTOOLS_DARWIN_POM_PATH=external/ortools_osx/pom-runtime.xml
ORTOOLS_DARWIN_JAR_PATH=external/ortools_osx/$ORTOOLS_DARWIN_ARTIFACT_ID-$VERSION.jar
ORTOOLS_DARWIN_SRCJAR_PATH=external/ortools_osx/$ORTOOLS_DARWIN_ARTIFACT_ID-$VERSION-sources.jar

curl --write-out "%{http_code}" -u "$DEPLOY_MAVEN_USERNAME":"$DEPLOY_MAVEN_PASSWORD" --upload-file "$ORTOOLS_DARWIN_POM_PATH"           "$REPOSITORY_URL"/                    "$GROUP_ID"/        "$ORTOOLS_DARWIN_ARTIFACT_ID"/"$VERSION"/"$ORTOOLS_DARWIN_ARTIFACT_ID"-"$VERSION".pom
curl --write-out "%{http_code}" -u ganesh:smrH91hRXX47xTnBkWez --upload-file external/ortools_osx/pom-runtime.xml https://repo.grakn.ai/repository/maven/com/google/ortools/ortools-darwin-test-3/8.0.8283/ortools-darwin-test-3-8.0.8283.pom

curl --write-out "%{http_code}" -u "$DEPLOY_MAVEN_USERNAME":"$DEPLOY_MAVEN_PASSWORD" --upload-file "$ORTOOLS_DARWIN_POM_PATH" "$REPOSITORY_URL"/"$GROUP_ID"/"$ORTOOLS_DARWIN_ARTIFACT_ID"/"$VERSION"/"$ORTOOLS_DARWIN_ARTIFACT_ID"-"$VERSION".pom.md5
curl --write-out "%{http_code}" -u "$DEPLOY_MAVEN_USERNAME":"$DEPLOY_MAVEN_PASSWORD" --upload-file "$ORTOOLS_DARWIN_POM_PATH" "$REPOSITORY_URL"/"$GROUP_ID"/"$ORTOOLS_DARWIN_ARTIFACT_ID"/"$VERSION"/"$ORTOOLS_DARWIN_ARTIFACT_ID"-"$VERSION".pom.sha1

curl --write-out "%{http_code}" -u "$DEPLOY_MAVEN_USERNAME":"$DEPLOY_MAVEN_PASSWORD" --upload-file "$ORTOOLS_DARWIN_JAR_PATH" "$REPOSITORY_URL"/"$GROUP_ID"/"$ORTOOLS_DARWIN_ARTIFACT_ID"/"$VERSION"/"$ORTOOLS_DARWIN_ARTIFACT_ID"-"$VERSION".jar
curl --write-out "%{http_code}" -u "$DEPLOY_MAVEN_USERNAME":"$DEPLOY_MAVEN_PASSWORD" --upload-file "$ORTOOLS_DARWIN_JAR_PATH" "$REPOSITORY_URL"/"$GROUP_ID"/"$ORTOOLS_DARWIN_ARTIFACT_ID"/"$VERSION"/"$ORTOOLS_DARWIN_ARTIFACT_ID"-"$VERSION".jar.md5
curl --write-out "%{http_code}" -u "$DEPLOY_MAVEN_USERNAME":"$DEPLOY_MAVEN_PASSWORD" --upload-file "$ORTOOLS_DARWIN_JAR_PATH" "$REPOSITORY_URL"/"$GROUP_ID"/"$ORTOOLS_DARWIN_ARTIFACT_ID"/"$VERSION"/"$ORTOOLS_DARWIN_ARTIFACT_ID"-"$VERSION".jar.sha1

curl --write-out "%{http_code}" -u "$DEPLOY_MAVEN_USERNAME":"$DEPLOY_MAVEN_PASSWORD" --upload-file "$ORTOOLS_DARWIN_SRCJAR_PATH" "$REPOSITORY_URL"/"$GROUP_ID"/"$ORTOOLS_DARWIN_ARTIFACT_ID"/"$VERSION"/"$ORTOOLS_DARWIN_ARTIFACT_ID"-"$VERSION"-sources.jar
curl --write-out "%{http_code}" -u "$DEPLOY_MAVEN_USERNAME":"$DEPLOY_MAVEN_PASSWORD" --upload-file "$ORTOOLS_DARWIN_SRCJAR_PATH" "$REPOSITORY_URL"/"$GROUP_ID"/"$ORTOOLS_DARWIN_ARTIFACT_ID"/"$VERSION"/"$ORTOOLS_DARWIN_ARTIFACT_ID"-"$VERSION"-sources.jar.md5
curl --write-out "%{http_code}" -u "$DEPLOY_MAVEN_USERNAME":"$DEPLOY_MAVEN_PASSWORD" --upload-file "$ORTOOLS_DARWIN_SRCJAR_PATH" "$REPOSITORY_URL"/"$GROUP_ID"/"$ORTOOLS_DARWIN_ARTIFACT_ID"/"$VERSION"/"$ORTOOLS_DARWIN_ARTIFACT_ID"-"$VERSION"-sources.jar.sha1

##################
#  ortools-java  #
##################
ORTOOLS_JAVA_ARTIFACT_ID=ortools-java-darwin
ORTOOLS_JAVA_POM_PATH=external/ortools_osx/pom-local.xml
ORTOOLS_JAVA_JAR_PATH=external/ortools_osx/ortools-java-$VERSION.jar
ORTOOLS_JAVA_SRCJAR_PATH=external/ortools_osx/ortools-java-$VERSION-sources.jar
ORTOOLS_JAVA_JAVADOC_PATH=external/ortools_osx/ortools-java-$VERSION-javadoc.jar

curl --write-out "%{http_code}" -u "$DEPLOY_MAVEN_USERNAME":"$DEPLOY_MAVEN_PASSWORD" --upload-file "$ORTOOLS_JAVA_POM_PATH" "$REPOSITORY_URL"/"$GROUP_ID"/"$ORTOOLS_JAVA_ARTIFACT_ID"/"$VERSION"/"$ORTOOLS_JAVA_ARTIFACT_ID"-"$VERSION".pom
curl --write-out "%{http_code}" -u "$DEPLOY_MAVEN_USERNAME":"$DEPLOY_MAVEN_PASSWORD" --upload-file "$ORTOOLS_JAVA_JAR_PATH" "$REPOSITORY_URL"/"$GROUP_ID"/"$ORTOOLS_JAVA_ARTIFACT_ID"/"$VERSION"/"$ORTOOLS_JAVA_ARTIFACT_ID"-"$VERSION".jar
curl --write-out "%{http_code}" -u "$DEPLOY_MAVEN_USERNAME":"$DEPLOY_MAVEN_PASSWORD" --upload-file "$ORTOOLS_JAVA_SRCJAR_PATH" "$REPOSITORY_URL"/"$GROUP_ID"/"$ORTOOLS_JAVA_ARTIFACT_ID"/"$VERSION"/"$ORTOOLS_JAVA_ARTIFACT_ID"-"$VERSION"-sources.jar
curl --write-out "%{http_code}" -u "$DEPLOY_MAVEN_USERNAME":"$DEPLOY_MAVEN_PASSWORD" --upload-file "$ORTOOLS_JAVA_JAVADOC_PATH" "$REPOSITORY_URL"/"$GROUP_ID"/"$ORTOOLS_JAVA_ARTIFACT_ID"/"$VERSION"/"$ORTOOLS_JAVA_ARTIFACT_ID"-"$VERSION"-javadoc.jar
