# RocksDB JNI

Grakn makes use of the RocksDB JNI, a protocol that enables interoperability between the Java code of Grakn Core and the
C++ code of RocksDB.

The RocksDB JNI has two modes of operation: "debug mode", which enables code assertions, and "production mode" which
disables them and runs significantly faster. Debug mode should be used in development; the production mode should be
used in production.

## Deploying RocksDB JNI with Bazel

\<TODO\>

## Building RocksDB JNI manually

In case the Bazel target fails to build, here is everything it does. The official documentation for compiling RocksDB JNI can be found in RocksDB's [GitHub wiki page](https://github.com/facebook/rocksdb/wiki/RocksJava-Basics).

0. Clone the [RocksDB repository from GitHub](https://github.com/facebook/rocksdb).

0. Checkout the tag that matches the version that you want. For example, `git checkout v6.8.1`.

0. Check that the `JAVA_HOME` environment variable is set. It should point to the location where the JDK is installed
(which must be Java 1.7+). To set it permanently, go to your `.profile` or `.bash_profile` (if neither exist, create
`.bash_profile`) and add this line:

    ```
    export JAVA_HOME=`/usr/libexec/java_home`
    ```

0. If not already installed, install `cmake` using `brew install cmake`.

0. To clean, run `make clean jclean`.

0. To build the JNI into a JAR, run `make -j8 rocksdbjava`. This will configure `DEBUG_LEVEL` to the default of 1,
which is debug mode enabled. To get a production build, run `DEBUG_LEVEL=0 make -j8 rocksdbjava` instead.

0. The output JAR will be created in `rocksdb/java/target` as (for example) `rocksdbjni-6.8.1-osx.jar` and is now
ready to be used in Grakn Core.
