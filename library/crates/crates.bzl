"""
@generated
cargo-raze generated Bazel file.

DO NOT EDIT! Replaced on runs of cargo-raze
"""

load("@bazel_tools//tools/build_defs/repo:git.bzl", "new_git_repository")  # buildifier: disable=load
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")  # buildifier: disable=load
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")  # buildifier: disable=load

def raze_fetch_remote_crates():
    """This function defines a collection of repos and should be called in a WORKSPACE file"""
    maybe(
        http_archive,
        name = "raze__antlr_rust__0_2_0",
        url = "https://crates.io/api/v1/crates/antlr-rust/0.2.0/download",
        type = "tar.gz",
        sha256 = "31cef0bab9c69cb4edd4764cd227b0db357a5634ad5a9200f9fb0a8d32e50947",
        strip_prefix = "antlr-rust-0.2.0",
        build_file = Label("//library/crates/remote:BUILD.antlr-rust-0.2.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__autocfg__1_1_0",
        url = "https://crates.io/api/v1/crates/autocfg/1.1.0/download",
        type = "tar.gz",
        strip_prefix = "autocfg-1.1.0",
        build_file = Label("//library/crates/remote:BUILD.autocfg-1.1.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__base64__0_9_3",
        url = "https://crates.io/api/v1/crates/base64/0.9.3/download",
        type = "tar.gz",
        strip_prefix = "base64-0.9.3",
        build_file = Label("//library/crates/remote:BUILD.base64-0.9.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__better_any__0_1_1",
        url = "https://crates.io/api/v1/crates/better_any/0.1.1/download",
        type = "tar.gz",
        sha256 = "b359aebd937c17c725e19efcb661200883f04c49c53e7132224dac26da39d4a0",
        strip_prefix = "better_any-0.1.1",
        build_file = Label("//library/crates/remote:BUILD.better_any-0.1.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__better_typeid_derive__0_1_1",
        url = "https://crates.io/api/v1/crates/better_typeid_derive/0.1.1/download",
        type = "tar.gz",
        sha256 = "3deeecb812ca5300b7d3f66f730cc2ebd3511c3d36c691dd79c165d5b19a26e3",
        strip_prefix = "better_typeid_derive-0.1.1",
        build_file = Label("//library/crates/remote:BUILD.better_typeid_derive-0.1.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__bindgen__0_59_2",
        url = "https://crates.io/api/v1/crates/bindgen/0.59.2/download",
        type = "tar.gz",
        strip_prefix = "bindgen-0.59.2",
        build_file = Label("//library/crates/remote:BUILD.bindgen-0.59.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__bit_set__0_5_2",
        url = "https://crates.io/api/v1/crates/bit-set/0.5.2/download",
        type = "tar.gz",
        sha256 = "6e11e16035ea35e4e5997b393eacbf6f63983188f7a2ad25bfb13465f5ad59de",
        strip_prefix = "bit-set-0.5.2",
        build_file = Label("//library/crates/remote:BUILD.bit-set-0.5.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__bit_vec__0_6_3",
        url = "https://crates.io/api/v1/crates/bit-vec/0.6.3/download",
        type = "tar.gz",
        sha256 = "349f9b6a179ed607305526ca489b34ad0a41aed5f7980fa90eb03160b69598fb",
        strip_prefix = "bit-vec-0.6.3",
        build_file = Label("//library/crates/remote:BUILD.bit-vec-0.6.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__bitflags__1_3_2",
        url = "https://crates.io/api/v1/crates/bitflags/1.3.2/download",
        type = "tar.gz",
        sha256 = "bef38d45163c2f1dde094a7dfd33ccf595c92905c8f8f4fdc18d06fb1037718a",
        strip_prefix = "bitflags-1.3.2",
        build_file = Label("//library/crates/remote:BUILD.bitflags-1.3.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__byteorder__1_4_3",
        url = "https://crates.io/api/v1/crates/byteorder/1.4.3/download",
        type = "tar.gz",
        sha256 = "14c189c53d098945499cdfa7ecc63567cf3886b3332b312a5b4585d8d3a6a610",
        strip_prefix = "byteorder-1.4.3",
        build_file = Label("//library/crates/remote:BUILD.byteorder-1.4.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__bytes__0_4_12",
        url = "https://crates.io/api/v1/crates/bytes/0.4.12/download",
        type = "tar.gz",
        strip_prefix = "bytes-0.4.12",
        build_file = Label("//library/crates/remote:BUILD.bytes-0.4.12.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__cc__1_0_73",
        url = "https://crates.io/api/v1/crates/cc/1.0.73/download",
        type = "tar.gz",
        strip_prefix = "cc-1.0.73",
        build_file = Label("//library/crates/remote:BUILD.cc-1.0.73.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__cexpr__0_6_0",
        url = "https://crates.io/api/v1/crates/cexpr/0.6.0/download",
        type = "tar.gz",
        strip_prefix = "cexpr-0.6.0",
        build_file = Label("//library/crates/remote:BUILD.cexpr-0.6.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__cfg_if__0_1_10",
        url = "https://crates.io/api/v1/crates/cfg-if/0.1.10/download",
        type = "tar.gz",
        strip_prefix = "cfg-if-0.1.10",
        build_file = Label("//library/crates/remote:BUILD.cfg-if-0.1.10.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__cfg_if__1_0_0",
        url = "https://crates.io/api/v1/crates/cfg-if/1.0.0/download",
        type = "tar.gz",
        sha256 = "baf1de4339761588bc0619e3cbc0120ee582ebb74b53b4efbf79117bd2da40fd",
        strip_prefix = "cfg-if-1.0.0",
        build_file = Label("//library/crates/remote:BUILD.cfg-if-1.0.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__clang_sys__1_3_1",
        url = "https://crates.io/api/v1/crates/clang-sys/1.3.1/download",
        type = "tar.gz",
        strip_prefix = "clang-sys-1.3.1",
        build_file = Label("//library/crates/remote:BUILD.clang-sys-1.3.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__cloudabi__0_0_3",
        url = "https://crates.io/api/v1/crates/cloudabi/0.0.3/download",
        type = "tar.gz",
        strip_prefix = "cloudabi-0.0.3",
        build_file = Label("//library/crates/remote:BUILD.cloudabi-0.0.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__crossbeam_deque__0_7_4",
        url = "https://crates.io/api/v1/crates/crossbeam-deque/0.7.4/download",
        type = "tar.gz",
        strip_prefix = "crossbeam-deque-0.7.4",
        build_file = Label("//library/crates/remote:BUILD.crossbeam-deque-0.7.4.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__crossbeam_epoch__0_8_2",
        url = "https://crates.io/api/v1/crates/crossbeam-epoch/0.8.2/download",
        type = "tar.gz",
        strip_prefix = "crossbeam-epoch-0.8.2",
        build_file = Label("//library/crates/remote:BUILD.crossbeam-epoch-0.8.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__crossbeam_queue__0_2_3",
        url = "https://crates.io/api/v1/crates/crossbeam-queue/0.2.3/download",
        type = "tar.gz",
        strip_prefix = "crossbeam-queue-0.2.3",
        build_file = Label("//library/crates/remote:BUILD.crossbeam-queue-0.2.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__crossbeam_utils__0_7_2",
        url = "https://crates.io/api/v1/crates/crossbeam-utils/0.7.2/download",
        type = "tar.gz",
        strip_prefix = "crossbeam-utils-0.7.2",
        build_file = Label("//library/crates/remote:BUILD.crossbeam-utils-0.7.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__cxx__1_0_65",
        url = "https://crates.io/api/v1/crates/cxx/1.0.65/download",
        type = "tar.gz",
        strip_prefix = "cxx-1.0.65",
        build_file = Label("//library/crates/remote:BUILD.cxx-1.0.65.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__cxxbridge_flags__1_0_65",
        url = "https://crates.io/api/v1/crates/cxxbridge-flags/1.0.65/download",
        type = "tar.gz",
        strip_prefix = "cxxbridge-flags-1.0.65",
        build_file = Label("//library/crates/remote:BUILD.cxxbridge-flags-1.0.65.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__cxxbridge_macro__1_0_65",
        url = "https://crates.io/api/v1/crates/cxxbridge-macro/1.0.65/download",
        type = "tar.gz",
        strip_prefix = "cxxbridge-macro-1.0.65",
        build_file = Label("//library/crates/remote:BUILD.cxxbridge-macro-1.0.65.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__fnv__1_0_7",
        url = "https://crates.io/api/v1/crates/fnv/1.0.7/download",
        type = "tar.gz",
        strip_prefix = "fnv-1.0.7",
        build_file = Label("//library/crates/remote:BUILD.fnv-1.0.7.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__fuchsia_zircon__0_3_3",
        url = "https://crates.io/api/v1/crates/fuchsia-zircon/0.3.3/download",
        type = "tar.gz",
        strip_prefix = "fuchsia-zircon-0.3.3",
        build_file = Label("//library/crates/remote:BUILD.fuchsia-zircon-0.3.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__fuchsia_zircon_sys__0_3_3",
        url = "https://crates.io/api/v1/crates/fuchsia-zircon-sys/0.3.3/download",
        type = "tar.gz",
        strip_prefix = "fuchsia-zircon-sys-0.3.3",
        build_file = Label("//library/crates/remote:BUILD.fuchsia-zircon-sys-0.3.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__futures__0_1_31",
        url = "https://crates.io/api/v1/crates/futures/0.1.31/download",
        type = "tar.gz",
        strip_prefix = "futures-0.1.31",
        build_file = Label("//library/crates/remote:BUILD.futures-0.1.31.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__futures__0_3_21",
        url = "https://crates.io/api/v1/crates/futures/0.3.21/download",
        type = "tar.gz",
        strip_prefix = "futures-0.3.21",
        build_file = Label("//library/crates/remote:BUILD.futures-0.3.21.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__futures_channel__0_3_21",
        url = "https://crates.io/api/v1/crates/futures-channel/0.3.21/download",
        type = "tar.gz",
        strip_prefix = "futures-channel-0.3.21",
        build_file = Label("//library/crates/remote:BUILD.futures-channel-0.3.21.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__futures_core__0_3_21",
        url = "https://crates.io/api/v1/crates/futures-core/0.3.21/download",
        type = "tar.gz",
        strip_prefix = "futures-core-0.3.21",
        build_file = Label("//library/crates/remote:BUILD.futures-core-0.3.21.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__futures_cpupool__0_1_8",
        url = "https://crates.io/api/v1/crates/futures-cpupool/0.1.8/download",
        type = "tar.gz",
        strip_prefix = "futures-cpupool-0.1.8",
        build_file = Label("//library/crates/remote:BUILD.futures-cpupool-0.1.8.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__futures_executor__0_3_21",
        url = "https://crates.io/api/v1/crates/futures-executor/0.3.21/download",
        type = "tar.gz",
        strip_prefix = "futures-executor-0.3.21",
        build_file = Label("//library/crates/remote:BUILD.futures-executor-0.3.21.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__futures_io__0_3_21",
        url = "https://crates.io/api/v1/crates/futures-io/0.3.21/download",
        type = "tar.gz",
        strip_prefix = "futures-io-0.3.21",
        build_file = Label("//library/crates/remote:BUILD.futures-io-0.3.21.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__futures_macro__0_3_21",
        url = "https://crates.io/api/v1/crates/futures-macro/0.3.21/download",
        type = "tar.gz",
        strip_prefix = "futures-macro-0.3.21",
        build_file = Label("//library/crates/remote:BUILD.futures-macro-0.3.21.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__futures_sink__0_3_21",
        url = "https://crates.io/api/v1/crates/futures-sink/0.3.21/download",
        type = "tar.gz",
        strip_prefix = "futures-sink-0.3.21",
        build_file = Label("//library/crates/remote:BUILD.futures-sink-0.3.21.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__futures_task__0_3_21",
        url = "https://crates.io/api/v1/crates/futures-task/0.3.21/download",
        type = "tar.gz",
        strip_prefix = "futures-task-0.3.21",
        build_file = Label("//library/crates/remote:BUILD.futures-task-0.3.21.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__futures_util__0_3_21",
        url = "https://crates.io/api/v1/crates/futures-util/0.3.21/download",
        type = "tar.gz",
        strip_prefix = "futures-util-0.3.21",
        build_file = Label("//library/crates/remote:BUILD.futures-util-0.3.21.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__glob__0_3_0",
        url = "https://crates.io/api/v1/crates/glob/0.3.0/download",
        type = "tar.gz",
        strip_prefix = "glob-0.3.0",
        build_file = Label("//library/crates/remote:BUILD.glob-0.3.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__grpc__0_6_2",
        url = "https://crates.io/api/v1/crates/grpc/0.6.2/download",
        type = "tar.gz",
        strip_prefix = "grpc-0.6.2",
        build_file = Label("//library/crates/remote:BUILD.grpc-0.6.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__grpc_compiler__0_6_2",
        url = "https://crates.io/api/v1/crates/grpc-compiler/0.6.2/download",
        type = "tar.gz",
        strip_prefix = "grpc-compiler-0.6.2",
        build_file = Label("//library/crates/remote:BUILD.grpc-compiler-0.6.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__hermit_abi__0_1_19",
        url = "https://crates.io/api/v1/crates/hermit-abi/0.1.19/download",
        type = "tar.gz",
        strip_prefix = "hermit-abi-0.1.19",
        build_file = Label("//library/crates/remote:BUILD.hermit-abi-0.1.19.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__httpbis__0_7_0",
        url = "https://crates.io/api/v1/crates/httpbis/0.7.0/download",
        type = "tar.gz",
        strip_prefix = "httpbis-0.7.0",
        build_file = Label("//library/crates/remote:BUILD.httpbis-0.7.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__instant__0_1_12",
        url = "https://crates.io/api/v1/crates/instant/0.1.12/download",
        type = "tar.gz",
        sha256 = "7a5bbe824c507c5da5956355e86a746d82e0e1464f65d862cc5e71da70e94b2c",
        strip_prefix = "instant-0.1.12",
        build_file = Label("//library/crates/remote:BUILD.instant-0.1.12.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__iovec__0_1_4",
        url = "https://crates.io/api/v1/crates/iovec/0.1.4/download",
        type = "tar.gz",
        strip_prefix = "iovec-0.1.4",
        build_file = Label("//library/crates/remote:BUILD.iovec-0.1.4.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__jobserver__0_1_24",
        url = "https://crates.io/api/v1/crates/jobserver/0.1.24/download",
        type = "tar.gz",
        strip_prefix = "jobserver-0.1.24",
        build_file = Label("//library/crates/remote:BUILD.jobserver-0.1.24.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__kernel32_sys__0_2_2",
        url = "https://crates.io/api/v1/crates/kernel32-sys/0.2.2/download",
        type = "tar.gz",
        strip_prefix = "kernel32-sys-0.2.2",
        build_file = Label("//library/crates/remote:BUILD.kernel32-sys-0.2.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__lazy_static__1_4_0",
        url = "https://crates.io/api/v1/crates/lazy_static/1.4.0/download",
        type = "tar.gz",
        sha256 = "e2abad23fbc42b3700f2f279844dc832adb2b2eb069b2df918f455c4e18cc646",
        strip_prefix = "lazy_static-1.4.0",
        build_file = Label("//library/crates/remote:BUILD.lazy_static-1.4.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__lazycell__1_3_0",
        url = "https://crates.io/api/v1/crates/lazycell/1.3.0/download",
        type = "tar.gz",
        strip_prefix = "lazycell-1.3.0",
        build_file = Label("//library/crates/remote:BUILD.lazycell-1.3.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__libc__0_2_106",
        url = "https://crates.io/api/v1/crates/libc/0.2.106/download",
        type = "tar.gz",
        sha256 = "a60553f9a9e039a333b4e9b20573b9e9b9c0bb3a11e201ccc48ef4283456d673",
        strip_prefix = "libc-0.2.106",
        build_file = Label("//library/crates/remote:BUILD.libc-0.2.106.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__libloading__0_7_3",
        url = "https://crates.io/api/v1/crates/libloading/0.7.3/download",
        type = "tar.gz",
        strip_prefix = "libloading-0.7.3",
        build_file = Label("//library/crates/remote:BUILD.libloading-0.7.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__librocksdb_sys__6_20_3",
        url = "https://crates.io/api/v1/crates/librocksdb-sys/6.20.3/download",
        type = "tar.gz",
        strip_prefix = "librocksdb-sys-6.20.3",
        build_file = Label("//library/crates/remote:BUILD.librocksdb-sys-6.20.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__link_cplusplus__1_0_6",
        url = "https://crates.io/api/v1/crates/link-cplusplus/1.0.6/download",
        type = "tar.gz",
        strip_prefix = "link-cplusplus-1.0.6",
        build_file = Label("//library/crates/remote:BUILD.link-cplusplus-1.0.6.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__lock_api__0_3_4",
        url = "https://crates.io/api/v1/crates/lock_api/0.3.4/download",
        type = "tar.gz",
        strip_prefix = "lock_api-0.3.4",
        build_file = Label("//library/crates/remote:BUILD.lock_api-0.3.4.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__lock_api__0_4_5",
        url = "https://crates.io/api/v1/crates/lock_api/0.4.5/download",
        type = "tar.gz",
        sha256 = "712a4d093c9976e24e7dbca41db895dabcbac38eb5f4045393d17a95bdfb1109",
        strip_prefix = "lock_api-0.4.5",
        build_file = Label("//library/crates/remote:BUILD.lock_api-0.4.5.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__log__0_3_9",
        url = "https://crates.io/api/v1/crates/log/0.3.9/download",
        type = "tar.gz",
        strip_prefix = "log-0.3.9",
        build_file = Label("//library/crates/remote:BUILD.log-0.3.9.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__log__0_4_6",
        url = "https://crates.io/api/v1/crates/log/0.4.6/download",
        type = "tar.gz",
        strip_prefix = "log-0.4.6",
        build_file = Label("//library/crates/remote:BUILD.log-0.4.6.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__maybe_uninit__2_0_0",
        url = "https://crates.io/api/v1/crates/maybe-uninit/2.0.0/download",
        type = "tar.gz",
        strip_prefix = "maybe-uninit-2.0.0",
        build_file = Label("//library/crates/remote:BUILD.maybe-uninit-2.0.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__memchr__2_4_1",
        url = "https://crates.io/api/v1/crates/memchr/2.4.1/download",
        type = "tar.gz",
        strip_prefix = "memchr-2.4.1",
        build_file = Label("//library/crates/remote:BUILD.memchr-2.4.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__memoffset__0_5_6",
        url = "https://crates.io/api/v1/crates/memoffset/0.5.6/download",
        type = "tar.gz",
        strip_prefix = "memoffset-0.5.6",
        build_file = Label("//library/crates/remote:BUILD.memoffset-0.5.6.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__minimal_lexical__0_2_1",
        url = "https://crates.io/api/v1/crates/minimal-lexical/0.2.1/download",
        type = "tar.gz",
        strip_prefix = "minimal-lexical-0.2.1",
        build_file = Label("//library/crates/remote:BUILD.minimal-lexical-0.2.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__mio__0_6_23",
        url = "https://crates.io/api/v1/crates/mio/0.6.23/download",
        type = "tar.gz",
        strip_prefix = "mio-0.6.23",
        build_file = Label("//library/crates/remote:BUILD.mio-0.6.23.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__mio_uds__0_6_8",
        url = "https://crates.io/api/v1/crates/mio-uds/0.6.8/download",
        type = "tar.gz",
        strip_prefix = "mio-uds-0.6.8",
        build_file = Label("//library/crates/remote:BUILD.mio-uds-0.6.8.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__miow__0_2_2",
        url = "https://crates.io/api/v1/crates/miow/0.2.2/download",
        type = "tar.gz",
        strip_prefix = "miow-0.2.2",
        build_file = Label("//library/crates/remote:BUILD.miow-0.2.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__murmur3__0_4_1",
        url = "https://crates.io/api/v1/crates/murmur3/0.4.1/download",
        type = "tar.gz",
        sha256 = "a198f9589efc03f544388dfc4a19fe8af4323662b62f598b8dcfdac62c14771c",
        strip_prefix = "murmur3-0.4.1",
        build_file = Label("//library/crates/remote:BUILD.murmur3-0.4.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__net2__0_2_37",
        url = "https://crates.io/api/v1/crates/net2/0.2.37/download",
        type = "tar.gz",
        strip_prefix = "net2-0.2.37",
        build_file = Label("//library/crates/remote:BUILD.net2-0.2.37.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__nom__7_1_0",
        url = "https://crates.io/api/v1/crates/nom/7.1.0/download",
        type = "tar.gz",
        strip_prefix = "nom-7.1.0",
        build_file = Label("//library/crates/remote:BUILD.nom-7.1.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__num_cpus__1_13_1",
        url = "https://crates.io/api/v1/crates/num_cpus/1.13.1/download",
        type = "tar.gz",
        strip_prefix = "num_cpus-1.13.1",
        build_file = Label("//library/crates/remote:BUILD.num_cpus-1.13.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__once_cell__1_8_0",
        url = "https://crates.io/api/v1/crates/once_cell/1.8.0/download",
        type = "tar.gz",
        sha256 = "692fcb63b64b1758029e0a96ee63e049ce8c5948587f2f7208df04625e5f6b56",
        strip_prefix = "once_cell-1.8.0",
        build_file = Label("//library/crates/remote:BUILD.once_cell-1.8.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__parking_lot__0_11_2",
        url = "https://crates.io/api/v1/crates/parking_lot/0.11.2/download",
        type = "tar.gz",
        sha256 = "7d17b78036a60663b797adeaee46f5c9dfebb86948d1255007a1d6be0271ff99",
        strip_prefix = "parking_lot-0.11.2",
        build_file = Label("//library/crates/remote:BUILD.parking_lot-0.11.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__parking_lot__0_9_0",
        url = "https://crates.io/api/v1/crates/parking_lot/0.9.0/download",
        type = "tar.gz",
        strip_prefix = "parking_lot-0.9.0",
        build_file = Label("//library/crates/remote:BUILD.parking_lot-0.9.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__parking_lot_core__0_6_2",
        url = "https://crates.io/api/v1/crates/parking_lot_core/0.6.2/download",
        type = "tar.gz",
        strip_prefix = "parking_lot_core-0.6.2",
        build_file = Label("//library/crates/remote:BUILD.parking_lot_core-0.6.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__parking_lot_core__0_8_5",
        url = "https://crates.io/api/v1/crates/parking_lot_core/0.8.5/download",
        type = "tar.gz",
        sha256 = "d76e8e1493bcac0d2766c42737f34458f1c8c50c0d23bcb24ea953affb273216",
        strip_prefix = "parking_lot_core-0.8.5",
        build_file = Label("//library/crates/remote:BUILD.parking_lot_core-0.8.5.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__peeking_take_while__0_1_2",
        url = "https://crates.io/api/v1/crates/peeking_take_while/0.1.2/download",
        type = "tar.gz",
        strip_prefix = "peeking_take_while-0.1.2",
        build_file = Label("//library/crates/remote:BUILD.peeking_take_while-0.1.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__pin_project_lite__0_2_8",
        url = "https://crates.io/api/v1/crates/pin-project-lite/0.2.8/download",
        type = "tar.gz",
        strip_prefix = "pin-project-lite-0.2.8",
        build_file = Label("//library/crates/remote:BUILD.pin-project-lite-0.2.8.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__pin_utils__0_1_0",
        url = "https://crates.io/api/v1/crates/pin-utils/0.1.0/download",
        type = "tar.gz",
        strip_prefix = "pin-utils-0.1.0",
        build_file = Label("//library/crates/remote:BUILD.pin-utils-0.1.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__proc_macro2__1_0_32",
        url = "https://crates.io/api/v1/crates/proc-macro2/1.0.32/download",
        type = "tar.gz",
        sha256 = "ba508cc11742c0dc5c1659771673afbab7a0efab23aa17e854cbab0837ed0b43",
        strip_prefix = "proc-macro2-1.0.32",
        build_file = Label("//library/crates/remote:BUILD.proc-macro2-1.0.32.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__protobuf__2_8_2",
        url = "https://crates.io/api/v1/crates/protobuf/2.8.2/download",
        type = "tar.gz",
        strip_prefix = "protobuf-2.8.2",
        patches = [
            "@rules_rust//proto/raze/patch:protobuf-2.8.2.patch",
        ],
        patch_args = [
            "-p1",
        ],
        build_file = Label("//library/crates/remote:BUILD.protobuf-2.8.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__protobuf_codegen__2_8_2",
        url = "https://crates.io/api/v1/crates/protobuf-codegen/2.8.2/download",
        type = "tar.gz",
        strip_prefix = "protobuf-codegen-2.8.2",
        build_file = Label("//library/crates/remote:BUILD.protobuf-codegen-2.8.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__quote__1_0_10",
        url = "https://crates.io/api/v1/crates/quote/1.0.10/download",
        type = "tar.gz",
        sha256 = "38bc8cc6a5f2e3655e0899c1b848643b2562f853f114bfec7be120678e3ace05",
        strip_prefix = "quote-1.0.10",
        build_file = Label("//library/crates/remote:BUILD.quote-1.0.10.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__redox_syscall__0_1_57",
        url = "https://crates.io/api/v1/crates/redox_syscall/0.1.57/download",
        type = "tar.gz",
        strip_prefix = "redox_syscall-0.1.57",
        build_file = Label("//library/crates/remote:BUILD.redox_syscall-0.1.57.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__redox_syscall__0_2_10",
        url = "https://crates.io/api/v1/crates/redox_syscall/0.2.10/download",
        type = "tar.gz",
        sha256 = "8383f39639269cde97d255a32bdb68c047337295414940c68bdd30c2e13203ff",
        strip_prefix = "redox_syscall-0.2.10",
        build_file = Label("//library/crates/remote:BUILD.redox_syscall-0.2.10.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__regex__1_5_4",
        url = "https://crates.io/api/v1/crates/regex/1.5.4/download",
        type = "tar.gz",
        strip_prefix = "regex-1.5.4",
        build_file = Label("//library/crates/remote:BUILD.regex-1.5.4.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__regex_syntax__0_6_25",
        url = "https://crates.io/api/v1/crates/regex-syntax/0.6.25/download",
        type = "tar.gz",
        strip_prefix = "regex-syntax-0.6.25",
        build_file = Label("//library/crates/remote:BUILD.regex-syntax-0.6.25.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__rocksdb__0_17_0",
        url = "https://crates.io/api/v1/crates/rocksdb/0.17.0/download",
        type = "tar.gz",
        strip_prefix = "rocksdb-0.17.0",
        build_file = Label("//library/crates/remote:BUILD.rocksdb-0.17.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__rustc_hash__1_1_0",
        url = "https://crates.io/api/v1/crates/rustc-hash/1.1.0/download",
        type = "tar.gz",
        strip_prefix = "rustc-hash-1.1.0",
        build_file = Label("//library/crates/remote:BUILD.rustc-hash-1.1.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__rustc_version__0_2_3",
        url = "https://crates.io/api/v1/crates/rustc_version/0.2.3/download",
        type = "tar.gz",
        strip_prefix = "rustc_version-0.2.3",
        build_file = Label("//library/crates/remote:BUILD.rustc_version-0.2.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__safemem__0_3_3",
        url = "https://crates.io/api/v1/crates/safemem/0.3.3/download",
        type = "tar.gz",
        strip_prefix = "safemem-0.3.3",
        build_file = Label("//library/crates/remote:BUILD.safemem-0.3.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__scoped_tls__0_1_2",
        url = "https://crates.io/api/v1/crates/scoped-tls/0.1.2/download",
        type = "tar.gz",
        strip_prefix = "scoped-tls-0.1.2",
        build_file = Label("//library/crates/remote:BUILD.scoped-tls-0.1.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__scopeguard__1_1_0",
        url = "https://crates.io/api/v1/crates/scopeguard/1.1.0/download",
        type = "tar.gz",
        sha256 = "d29ab0c6d3fc0ee92fe66e2d99f700eab17a8d57d1c1d3b748380fb20baa78cd",
        strip_prefix = "scopeguard-1.1.0",
        build_file = Label("//library/crates/remote:BUILD.scopeguard-1.1.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__semver__0_9_0",
        url = "https://crates.io/api/v1/crates/semver/0.9.0/download",
        type = "tar.gz",
        strip_prefix = "semver-0.9.0",
        build_file = Label("//library/crates/remote:BUILD.semver-0.9.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__semver_parser__0_7_0",
        url = "https://crates.io/api/v1/crates/semver-parser/0.7.0/download",
        type = "tar.gz",
        strip_prefix = "semver-parser-0.7.0",
        build_file = Label("//library/crates/remote:BUILD.semver-parser-0.7.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__shlex__1_1_0",
        url = "https://crates.io/api/v1/crates/shlex/1.1.0/download",
        type = "tar.gz",
        strip_prefix = "shlex-1.1.0",
        build_file = Label("//library/crates/remote:BUILD.shlex-1.1.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__slab__0_3_0",
        url = "https://crates.io/api/v1/crates/slab/0.3.0/download",
        type = "tar.gz",
        strip_prefix = "slab-0.3.0",
        build_file = Label("//library/crates/remote:BUILD.slab-0.3.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__slab__0_4_5",
        url = "https://crates.io/api/v1/crates/slab/0.4.5/download",
        type = "tar.gz",
        strip_prefix = "slab-0.4.5",
        build_file = Label("//library/crates/remote:BUILD.slab-0.4.5.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__smallvec__0_6_14",
        url = "https://crates.io/api/v1/crates/smallvec/0.6.14/download",
        type = "tar.gz",
        strip_prefix = "smallvec-0.6.14",
        build_file = Label("//library/crates/remote:BUILD.smallvec-0.6.14.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__smallvec__1_7_0",
        url = "https://crates.io/api/v1/crates/smallvec/1.7.0/download",
        type = "tar.gz",
        sha256 = "1ecab6c735a6bb4139c0caafd0cc3635748bbb3acf4550e8138122099251f309",
        strip_prefix = "smallvec-1.7.0",
        build_file = Label("//library/crates/remote:BUILD.smallvec-1.7.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__syn__1_0_81",
        url = "https://crates.io/api/v1/crates/syn/1.0.81/download",
        type = "tar.gz",
        sha256 = "f2afee18b8beb5a596ecb4a2dce128c719b4ba399d34126b9e4396e3f9860966",
        strip_prefix = "syn-1.0.81",
        build_file = Label("//library/crates/remote:BUILD.syn-1.0.81.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tls_api__0_1_22",
        url = "https://crates.io/api/v1/crates/tls-api/0.1.22/download",
        type = "tar.gz",
        strip_prefix = "tls-api-0.1.22",
        build_file = Label("//library/crates/remote:BUILD.tls-api-0.1.22.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tls_api_stub__0_1_22",
        url = "https://crates.io/api/v1/crates/tls-api-stub/0.1.22/download",
        type = "tar.gz",
        strip_prefix = "tls-api-stub-0.1.22",
        build_file = Label("//library/crates/remote:BUILD.tls-api-stub-0.1.22.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tokio__0_1_22",
        url = "https://crates.io/api/v1/crates/tokio/0.1.22/download",
        type = "tar.gz",
        strip_prefix = "tokio-0.1.22",
        build_file = Label("//library/crates/remote:BUILD.tokio-0.1.22.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tokio_codec__0_1_2",
        url = "https://crates.io/api/v1/crates/tokio-codec/0.1.2/download",
        type = "tar.gz",
        strip_prefix = "tokio-codec-0.1.2",
        build_file = Label("//library/crates/remote:BUILD.tokio-codec-0.1.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tokio_core__0_1_18",
        url = "https://crates.io/api/v1/crates/tokio-core/0.1.18/download",
        type = "tar.gz",
        strip_prefix = "tokio-core-0.1.18",
        build_file = Label("//library/crates/remote:BUILD.tokio-core-0.1.18.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tokio_current_thread__0_1_7",
        url = "https://crates.io/api/v1/crates/tokio-current-thread/0.1.7/download",
        type = "tar.gz",
        strip_prefix = "tokio-current-thread-0.1.7",
        build_file = Label("//library/crates/remote:BUILD.tokio-current-thread-0.1.7.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tokio_executor__0_1_10",
        url = "https://crates.io/api/v1/crates/tokio-executor/0.1.10/download",
        type = "tar.gz",
        strip_prefix = "tokio-executor-0.1.10",
        build_file = Label("//library/crates/remote:BUILD.tokio-executor-0.1.10.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tokio_fs__0_1_7",
        url = "https://crates.io/api/v1/crates/tokio-fs/0.1.7/download",
        type = "tar.gz",
        strip_prefix = "tokio-fs-0.1.7",
        build_file = Label("//library/crates/remote:BUILD.tokio-fs-0.1.7.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tokio_io__0_1_13",
        url = "https://crates.io/api/v1/crates/tokio-io/0.1.13/download",
        type = "tar.gz",
        strip_prefix = "tokio-io-0.1.13",
        build_file = Label("//library/crates/remote:BUILD.tokio-io-0.1.13.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tokio_reactor__0_1_12",
        url = "https://crates.io/api/v1/crates/tokio-reactor/0.1.12/download",
        type = "tar.gz",
        strip_prefix = "tokio-reactor-0.1.12",
        build_file = Label("//library/crates/remote:BUILD.tokio-reactor-0.1.12.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tokio_sync__0_1_8",
        url = "https://crates.io/api/v1/crates/tokio-sync/0.1.8/download",
        type = "tar.gz",
        strip_prefix = "tokio-sync-0.1.8",
        build_file = Label("//library/crates/remote:BUILD.tokio-sync-0.1.8.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tokio_tcp__0_1_4",
        url = "https://crates.io/api/v1/crates/tokio-tcp/0.1.4/download",
        type = "tar.gz",
        strip_prefix = "tokio-tcp-0.1.4",
        build_file = Label("//library/crates/remote:BUILD.tokio-tcp-0.1.4.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tokio_threadpool__0_1_18",
        url = "https://crates.io/api/v1/crates/tokio-threadpool/0.1.18/download",
        type = "tar.gz",
        strip_prefix = "tokio-threadpool-0.1.18",
        build_file = Label("//library/crates/remote:BUILD.tokio-threadpool-0.1.18.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tokio_timer__0_1_2",
        url = "https://crates.io/api/v1/crates/tokio-timer/0.1.2/download",
        type = "tar.gz",
        strip_prefix = "tokio-timer-0.1.2",
        build_file = Label("//library/crates/remote:BUILD.tokio-timer-0.1.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tokio_timer__0_2_13",
        url = "https://crates.io/api/v1/crates/tokio-timer/0.2.13/download",
        type = "tar.gz",
        strip_prefix = "tokio-timer-0.2.13",
        build_file = Label("//library/crates/remote:BUILD.tokio-timer-0.2.13.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tokio_tls_api__0_1_22",
        url = "https://crates.io/api/v1/crates/tokio-tls-api/0.1.22/download",
        type = "tar.gz",
        strip_prefix = "tokio-tls-api-0.1.22",
        build_file = Label("//library/crates/remote:BUILD.tokio-tls-api-0.1.22.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tokio_udp__0_1_6",
        url = "https://crates.io/api/v1/crates/tokio-udp/0.1.6/download",
        type = "tar.gz",
        strip_prefix = "tokio-udp-0.1.6",
        build_file = Label("//library/crates/remote:BUILD.tokio-udp-0.1.6.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tokio_uds__0_1_7",
        url = "https://crates.io/api/v1/crates/tokio-uds/0.1.7/download",
        type = "tar.gz",
        strip_prefix = "tokio-uds-0.1.7",
        build_file = Label("//library/crates/remote:BUILD.tokio-uds-0.1.7.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tokio_uds__0_2_7",
        url = "https://crates.io/api/v1/crates/tokio-uds/0.2.7/download",
        type = "tar.gz",
        strip_prefix = "tokio-uds-0.2.7",
        build_file = Label("//library/crates/remote:BUILD.tokio-uds-0.2.7.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__typed_arena__2_0_1",
        url = "https://crates.io/api/v1/crates/typed-arena/2.0.1/download",
        type = "tar.gz",
        sha256 = "0685c84d5d54d1c26f7d3eb96cd41550adb97baed141a761cf335d3d33bcd0ae",
        strip_prefix = "typed-arena-2.0.1",
        build_file = Label("//library/crates/remote:BUILD.typed-arena-2.0.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__unicode_xid__0_2_2",
        url = "https://crates.io/api/v1/crates/unicode-xid/0.2.2/download",
        type = "tar.gz",
        sha256 = "8ccb82d61f80a663efe1f787a51b16b5a51e3314d6ac365b08639f52387b33f3",
        strip_prefix = "unicode-xid-0.2.2",
        build_file = Label("//library/crates/remote:BUILD.unicode-xid-0.2.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__unix_socket__0_5_0",
        url = "https://crates.io/api/v1/crates/unix_socket/0.5.0/download",
        type = "tar.gz",
        strip_prefix = "unix_socket-0.5.0",
        build_file = Label("//library/crates/remote:BUILD.unix_socket-0.5.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__uuid__0_8_2",
        url = "https://crates.io/api/v1/crates/uuid/0.8.2/download",
        type = "tar.gz",
        sha256 = "bc5cf98d8186244414c848017f0e2676b3fcb46807f6668a97dfe67359a3c4b7",
        strip_prefix = "uuid-0.8.2",
        build_file = Label("//library/crates/remote:BUILD.uuid-0.8.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__version_check__0_9_4",
        url = "https://crates.io/api/v1/crates/version_check/0.9.4/download",
        type = "tar.gz",
        strip_prefix = "version_check-0.9.4",
        build_file = Label("//library/crates/remote:BUILD.version_check-0.9.4.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__void__1_0_2",
        url = "https://crates.io/api/v1/crates/void/1.0.2/download",
        type = "tar.gz",
        strip_prefix = "void-1.0.2",
        build_file = Label("//library/crates/remote:BUILD.void-1.0.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__winapi__0_2_8",
        url = "https://crates.io/api/v1/crates/winapi/0.2.8/download",
        type = "tar.gz",
        strip_prefix = "winapi-0.2.8",
        build_file = Label("//library/crates/remote:BUILD.winapi-0.2.8.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__winapi__0_3_9",
        url = "https://crates.io/api/v1/crates/winapi/0.3.9/download",
        type = "tar.gz",
        sha256 = "5c839a674fcd7a98952e593242ea400abe93992746761e38641405d28b00f419",
        strip_prefix = "winapi-0.3.9",
        build_file = Label("//library/crates/remote:BUILD.winapi-0.3.9.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__winapi_build__0_1_1",
        url = "https://crates.io/api/v1/crates/winapi-build/0.1.1/download",
        type = "tar.gz",
        strip_prefix = "winapi-build-0.1.1",
        build_file = Label("//library/crates/remote:BUILD.winapi-build-0.1.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__winapi_i686_pc_windows_gnu__0_4_0",
        url = "https://crates.io/api/v1/crates/winapi-i686-pc-windows-gnu/0.4.0/download",
        type = "tar.gz",
        sha256 = "ac3b87c63620426dd9b991e5ce0329eff545bccbbb34f3be09ff6fb6ab51b7b6",
        strip_prefix = "winapi-i686-pc-windows-gnu-0.4.0",
        build_file = Label("//library/crates/remote:BUILD.winapi-i686-pc-windows-gnu-0.4.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__winapi_x86_64_pc_windows_gnu__0_4_0",
        url = "https://crates.io/api/v1/crates/winapi-x86_64-pc-windows-gnu/0.4.0/download",
        type = "tar.gz",
        sha256 = "712e227841d057c1ee1cd2fb22fa7e5a5461ae8e48fa2ca79ec42cfc1931183f",
        strip_prefix = "winapi-x86_64-pc-windows-gnu-0.4.0",
        build_file = Label("//library/crates/remote:BUILD.winapi-x86_64-pc-windows-gnu-0.4.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__ws2_32_sys__0_2_1",
        url = "https://crates.io/api/v1/crates/ws2_32-sys/0.2.1/download",
        type = "tar.gz",
        strip_prefix = "ws2_32-sys-0.2.1",
        build_file = Label("//library/crates/remote:BUILD.ws2_32-sys-0.2.1.bazel"),
    )