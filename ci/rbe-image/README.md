# Custom Docker image for running RBE builds

## Purpose

We’ve built a custom RBE image that includes `rpmbuild` which will allow executing `pkg_rpm` on RBE.
The goal, however, is to keep as close to upstream as possible, so it's built on a stock 'base' image that is used 
by RBE.

## Finding out the base image

Based on a `platform` target (`//:rbe-ubuntu1604-network-standard`), we can find out the base image:

```
$ bazel query --output=build //:rbe-ubuntu1604-network-standard 2>&1 | grep 'parents'
  parents = ["@bazel_toolchains//configs/ubuntu16_04_clang/1.1:rbe_ubuntu1604"],
$ bazel query --output=build @bazel_toolchains//configs/ubuntu16_04_clang/1.1:rbe_ubuntu1604 2>&1 | grep 'actual'
  actual = "@bazel_toolchains//configs/ubuntu16_04_clang/1.1:rbe_ubuntu1604_r346485",
$ bazel query --output=build @bazel_toolchains//configs/ubuntu16_04_clang/1.1:rbe_ubuntu1604_r346485 2>&1 | grep 'docker://'
  remote_execution_properties = "\n        properties: {\n          name: \"container-image\"\n          value:\"docker://gcr.io/cloud-marketplace/google/rbe-ubuntu16-04@sha256:87fe00c5c4d0e64ab3830f743e686716f49569dadb49f1b1b09966c1b36e153c\"\n        }\n        ",
```

## Building the image

Image should be built and pushed to Google Container Registry:

```
$ docker build -t gcr.io/grakn-dev/rbe_platform:latest .
...
Successfully built 6a93ba0992aa
Successfully tagged gcr.io/grakn-dev/rbe_platform:latest
$ docker push gcr.io/grakn-dev/rbe_platform:latest
The push refers to repository [gcr.io/grakn-dev/rbe_platform]
...
latest: digest: sha256:e45b81a193c7b783c92db389655664d353ffb1fdf219577c5ced7b7d86795246 size: 1584
```


Then, the value in `platform` of `container-image` value should be replaced:

`docker://gcr.io/grakn-dev/rbe_platform@sha256:<sha_digest>`

