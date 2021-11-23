# RocksDB JNI

TypeDB makes use of the RocksDB JNI, a protocol that enables interoperability between the Java code of TypeDB and the
C++ code of RocksDB.

The RocksDB JNI has two modes of operation: "debug mode", which enables code assertions, and "production mode" which
disables them and runs significantly faster. Debug mode should be used in development; the production mode should be
used in production.

## Assembling & Deploying with Bazel

**NOTE: Only Mac distributions are currently operational.**


1. Update VERSION file with the version of RocksDB JNI that you wish to assemble & deploy:
```
echo "<rocksdb-jni-version>" > library/rocksdbjni/VERSION
```

2. Assemble the artifact:
```
bazel build //library/rocksdbjni:assemble-maven-mac
```

3. Deploy the artifact:
```
export DEPLOY_MAVEN_USERNAME=...
export DEPLOY_MAVEN_PASSWORD=...
bazel run //library/rocksdbjni:deploy-maven-mac -- release
```

(!) **Important** - When upgrading RocksDB JNI, remember to also update the version specified in `library/maven/artifacts.bzl`.

## The manual RocksDB JNI build process

For reference, the steps to build RocksDB JNI manually are listed here, but `assemble_maven` does all these steps automatically.
The official documentation for compiling RocksDB JNI can be found in RocksDB's [GitHub wiki page](https://github.com/facebook/rocksdb/wiki/RocksJava-Basics).

1. Clone the [RocksDB repository from GitHub](https://github.com/facebook/rocksdb).

2. Checkout the tag that matches the version that you want. For example, `git checkout v6.8.1`.

3. Check that the `JAVA_HOME` environment variable is set. It should point to the location where the JDK is installed
(which must be Java 1.7+). To set it permanently, go to your `.profile` or `.bash_profile` (if neither exist, create
`.bash_profile`) and add this line:

    ```
    export JAVA_HOME=`/usr/libexec/java_home`
    ```

4. If not already installed, install `cmake` using `brew install cmake`.

5. To clean, run `make clean jclean`.

6. To build the JNI into a JAR, run `make -j8 rocksdbjava`. This will configure `DEBUG_LEVEL` to the default of 1,
which is debug mode enabled. To get a production build, run `DEBUG_LEVEL=0 make -j8 rocksdbjava` instead.

7. To build the JNI's source code into a sources JAR, run the following command (with the correct version number):
`cd java/src/main/java;jar -cf ../../../target/rocksdbjni-6.8.1-sources.jar org`

8. The output JARs will be created in `rocksdb/java/target` as (for example) `rocksdbjni-6.8.1-osx.jar` and
`rocksdbjni-6.8.1-sources.jar` and are now ready to be used.
