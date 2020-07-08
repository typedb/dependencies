artifacts = {
  "ch.qos.logback:logback-classic": "1.2.3",
  "ch.qos.logback:logback-core": "1.2.3",
  "com.jcraft:jsch": "0.1.55",
  "com.datastax.oss:java-driver-core": {
    "version": "4.3.0",
    "exclude": [
      "com.github.jnr:jnr-ffi",
    ],
  },
  "com.datastax.oss:java-driver-query-builder": {
    "version": "4.3.0",
    "exclude": [
      "com.github.jnr:jnr-ffi",
    ],
  },
  "com.fasterxml.jackson.core:jackson-core": "2.9.10",
  "com.fasterxml.jackson.core:jackson-databind": "2.9.10.1",
  "com.fasterxml.jackson.dataformat:jackson-dataformat-yaml": "2.9.9",
  "com.fasterxml.jackson.module:jackson-module-scala_2.11": "2.9.9",
  "com.google.code.findbugs:annotations": "3.0.1",
  "com.google.code.findbugs:jsr305": "2.0.2",
  "com.google.code.gson:gson": "2.8.5",
  "com.google.guava:guava": "23.0",
  "com.google.protobuf:protobuf-java": "3.5.1",
  "com.univocity:univocity-parsers": "2.8.1",
  "commons-cli:commons-cli": "1.4",
  "commons-collections:commons-collections": "3.2.1",
  "commons-configuration:commons-configuration": "1.10",
  "commons-io:commons-io": "2.3",
  "commons-lang:commons-lang": "2.6",
  "info.picocli:picocli": "4.3.2",
  "io.cucumber:cucumber-java": "5.1.3",
  "io.cucumber:cucumber-junit": "5.1.3",
  "io.grpc:grpc-api": "1.24.1",
  "io.grpc:grpc-core": "1.24.1",
  "io.grpc:grpc-context": "1.24.1",
  "io.grpc:grpc-netty": "1.24.1",
  "io.grpc:grpc-protobuf": "1.24.1",
  "io.grpc:grpc-stub": "1.24.1",
  "io.grpc:grpc-testing": "1.24.1",
  "io.netty:netty-all": "4.1.38.Final",
  "io.netty:netty-codec-http2": "4.1.38.Final",
  "io.netty:netty-handler": "4.1.38.Final",
  "io.netty:netty-handler-proxy": "4.1.38.Final",
  "io.netty:netty-tcnative-boringssl-static": "2.0.25.Final",
  "io.vavr:vavr": "0.9.0",
  "javax.annotation:javax.annotation-api": "1.3.2",
  "javax.servlet:javax.servlet-api": "3.1.0",
  "javax.xml.stream:stax-api": "1.0-2",
  "jline:jline": "2.12",
  "junit:junit": "4.12",
  "org.antlr:antlr4-runtime": "4.7.1",
  "org.apache.cassandra:cassandra-all": {
    "version": "3.11.3",
    "exclude": [
      "ch.qos.logback:logback-classic",
      "ch.qos.logback:logback-core",
      "it.unimi.dsi:fastutil",
      "com.addthis.metrics:reporter-config3", # include this if we need to debug cassandra
      "org.eclipse.jdt.core.compiler:ecj",
    ]
  },
  "org.apache.cassandra:cassandra-thrift": {
    "version": "3.11.3",
    "exclude": [
      "ch.qos.logback:logback-classic",
      "ch.qos.logback:logback-core",
      "it.unimi.dsi:fastutil",
    ]
  },
  "org.apache.commons:commons-csv": "1.7",
  "org.apache.commons:commons-lang3": "3.9",
  "org.apache.commons:commons-math3": "3.6.1",
  "org.apache.hadoop:hadoop-annotations": "2.7.2",
  "org.apache.hadoop:hadoop-common": {
    "version": "2.7.2",
    "exclude": [
      "javax.servlet:servlet-api",
      "org.slf4j:slf4j-log4j12",
      "io.netty:netty",
    ]
  },
  "org.apache.hadoop:hadoop-mapreduce-client-core": {
    "version": "2.7.2",
    "exclude": [
      "javax.servlet:servlet-api",
      "org.slf4j:slf4j-log4j12",
      "io.netty:netty",
    ]
  },
  "org.apache.spark:spark-core_2.11": {
    "version": "2.2.0",
    "exclude": [
      "com.fasterxml.jackson.module:jackson-module-scala_2.10",
      "io.netty:netty",
      "javax.servlet:ja,vax.servlet-api",
      "log4j:log4j",
      "org.scala-lang.modules:scala-xml_2.11",
      "org.slf4j:jcl-over-slf4j",
      "org.slf4j:slf4j-api",
      "org.slf4j:slf4j-log4j12"
    ]
  },
  "org.apache.spark:spark-launcher_2.11": {
    "version": "2.2.0",
    "exclude": [
      "com.fasterxml.jackson.module:jackson-module-scala_2.10",
      "io.netty:netty",
      "javax.servlet:ja,vax.servlet-api",
      "log4j:log4j",
      "org.scala-lang.modules:scala-xml_2.11",
      "org.slf4j:jcl-over-slf4j",
      "org.slf4j:slf4j-api",
      "org.slf4j:slf4j-log4j12"
    ]
  },
  "org.apache.thrift:libthrift": "0.9.2",
  "org.apache.tinkerpop:gremlin-core": {
    "version": "3.4.1",
    "exclude": [
      "org.slf4j:jcl-over-slf4j",
      "org.slf4j:slf4j-log4j12"
    ],
  },
  "org.apache.tinkerpop:hadoop-gremlin": {
    "version": "3.4.1",
    "exclude": [
      "com.fasterxml.jackson.core:jackson-core",
      "com.fasterxml.jackson.core:jackson-databind",
      "com.sun.jersey:jersey-client",
      "commons-logging:commons-logging",
      "io.netty:netty",
      "javax.servlet:javax.servlet-api",
      "log4j:log4j",
      "org.mortbay.jetty:jetty-util",
      "org.slf4j:jcl-over-slf4j",
      "org.slf4j:slf4j-log4j12",
      "org.slf4j:slf4j-nop"
    ]
  },
  "org.apache.tinkerpop:spark-gremlin": {
    "version": "3.4.1",
    "exclude": [
      "com.fasterxml.jackson.core:jackson-annotations",
      "com.fasterxml.jackson.core:jackson-core",
      "com.fasterxml.jackson.core:jackson-databind",
      "com.fasterxml.jackson.module:jackson-module-scala_2.10",
      "io.netty:netty",
      "javax.servlet:javax.servlet-api"
    ]
  },
  "org.apache.tinkerpop:tinkergraph-gremlin": {
    "version": "3.4.1",
    "exclude": [
      "org.slf4j:slf4j-log4j12",
    ],
  },
  "org.hamcrest:hamcrest": "2.2",
  "org.hamcrest:hamcrest-all": "1.3",
  "org.hamcrest:hamcrest-core": "1.3",
  "org.hamcrest:hamcrest-library": "1.3",
  "org.javatuples:javatuples": "1.2",
  "org.mockito:mockito-core": "2.6.4",
  "org.scala-lang:scala-library": "2.11.8",
  "org.sharegov:mjson": "1.4.1",
  "org.slf4j:jcl-over-slf4j": "1.7.20",
  "org.slf4j:log4j-over-slf4j": "1.7.20",
  "org.slf4j:slf4j-api": "1.7.28",
  "org.slf4j:slf4j-simple": "1.7.20",
  "org.yaml:snakeyaml": "1.25",
  "org.rocksdb:rocksdbjni": "6.8.1",
  "org.zeroturnaround:zt-exec": {
    "version": "1.10",
    "exclude": [
      "commons-io:commons-io",
    ],
  },
  "com.google.inject:guice": 	"4.2.2",
  "com.github.rholder:guava-retrying": 	"2.0.0",
  "org.eclipse.jetty.websocket:websocket-api": 	"9.4.18.v20190429",
  "com.google.http-client:google-http-client": 	"1.34.2",
  "org.bouncycastle:bcprov-jdk16": 	"1.46",
  "com.eclipsesource.minimal-json:minimal-json": 	"0.9.5",
  "com.auth0:java-jwt": 	"3.8.3",
  "io.opencensus:opencensus-api": 	"0.24.0",
  "io.opencensus:opencensus-contrib-grpc-metrics": 	"0.24.0",
  "org.kohsuke:github-api": 	"1.101",
  "com.typesafe:config": 	"1.4.0",
  "com.typesafe.akka:akka-actor_2.12": 	"2.6.3",
  "com.typesafe.akka:akka-actor-testkit-typed_2.12": 	"2.6.3",
  "com.typesafe.akka:akka-actor-typed_2.12": 	"2.6.3",
  "com.typesafe.akka:akka-stream_2.12": 	"2.6.3",
  "com.typesafe.play:build-link": 	"2.8.1",
  "com.typesafe.play:filters-helpers_2.12": 	"2.8.1",
  "com.typesafe.play:play_2.12": 	"2.8.1",
  "com.typesafe.play:play-akka-http-server_2.12": 	"2.8.1",
  "com.typesafe.play:play-guice_2.12": 	"2.8.1",
  "com.typesafe.play:play-java_2.12": 	"2.8.1",
  "com.typesafe.play:play-netty-server_2.12": 	"2.8.1",
  "com.typesafe.play:play-server_2.12": 	"2.8.1",
  "com.typesafe.play:play-streams_2.12": 	"2.8.1",
  "com.typesafe.play:play-ws_2.12": 	"2.8.1",
  "com.typesafe.play:twirl-api_2.12": 	"1.5.0",
  "javax.inject:javax.inject": 	"1",
  "com.microsoft.rest:client-runtime": 	"1.7.4",
  "com.microsoft.azure:azure": 	"1.33.1",
  "com.microsoft.azure:azure-mgmt-resources": 	"1.33.1",
  "com.microsoft.azure:azure-mgmt-compute": 	"1.33.1",
  "com.microsoft.azure:azure-client-runtime": 	"1.7.4",
  "com.microsoft.azure:azure-mgmt-network": 	"1.33.1",
  "com.microsoft.azure:azure-client-authentication": 	"1.7.4",
  "com.azure:azure-core": 	"1.5.0",
  "com.azure:azure-storage-blob": 	"12.6.0",
  "com.azure:azure-storage-common": 	"12.6.0",
  "com.azure:azure-identity": 	"1.0.6",
}

