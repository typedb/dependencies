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
        name = "raze__alcoholic_jwt__4091_0_0",
        url = "https://crates.io/api/v1/crates/alcoholic_jwt/4091.0.0/download",
        type = "tar.gz",
        strip_prefix = "alcoholic_jwt-4091.0.0",
        build_file = Label("//library/crates/remote:BUILD.alcoholic_jwt-4091.0.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__android_system_properties__0_1_5",
        url = "https://crates.io/api/v1/crates/android_system_properties/0.1.5/download",
        type = "tar.gz",
        strip_prefix = "android_system_properties-0.1.5",
        build_file = Label("//library/crates/remote:BUILD.android_system_properties-0.1.5.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__antlr_rust__0_3_0_beta",
        url = "https://crates.io/api/v1/crates/antlr-rust/0.3.0-beta/download",
        type = "tar.gz",
        strip_prefix = "antlr-rust-0.3.0-beta",
        build_file = Label("//library/crates/remote:BUILD.antlr-rust-0.3.0-beta.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__anyhow__1_0_62",
        url = "https://crates.io/api/v1/crates/anyhow/1.0.62/download",
        type = "tar.gz",
        sha256 = "1485d4d2cc45e7b201ee3767015c96faa5904387c9d87c6efdd0fb511f12d305",
        strip_prefix = "anyhow-1.0.62",
        build_file = Label("//library/crates/remote:BUILD.anyhow-1.0.62.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__async_stream__0_3_3",
        url = "https://crates.io/api/v1/crates/async-stream/0.3.3/download",
        type = "tar.gz",
        sha256 = "dad5c83079eae9969be7fadefe640a1c566901f05ff91ab221de4b6f68d9507e",
        strip_prefix = "async-stream-0.3.3",
        build_file = Label("//library/crates/remote:BUILD.async-stream-0.3.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__async_stream_impl__0_3_3",
        url = "https://crates.io/api/v1/crates/async-stream-impl/0.3.3/download",
        type = "tar.gz",
        sha256 = "10f203db73a71dfa2fb6dd22763990fa26f3d2625a6da2da900d23b87d26be27",
        strip_prefix = "async-stream-impl-0.3.3",
        build_file = Label("//library/crates/remote:BUILD.async-stream-impl-0.3.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__async_trait__0_1_57",
        url = "https://crates.io/api/v1/crates/async-trait/0.1.57/download",
        type = "tar.gz",
        sha256 = "76464446b8bc32758d7e88ee1a804d9914cd9b1cb264c029899680b0be29826f",
        strip_prefix = "async-trait-0.1.57",
        build_file = Label("//library/crates/remote:BUILD.async-trait-0.1.57.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__autocfg__1_1_0",
        url = "https://crates.io/api/v1/crates/autocfg/1.1.0/download",
        type = "tar.gz",
        sha256 = "d468802bab17cbc0cc575e9b053f41e72aa36bfa6b7f55e3529ffa43161b97fa",
        strip_prefix = "autocfg-1.1.0",
        build_file = Label("//library/crates/remote:BUILD.autocfg-1.1.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__axum__0_5_15",
        url = "https://crates.io/api/v1/crates/axum/0.5.15/download",
        type = "tar.gz",
        sha256 = "9de18bc5f2e9df8f52da03856bf40e29b747de5a84e43aefff90e3dc4a21529b",
        strip_prefix = "axum-0.5.15",
        build_file = Label("//library/crates/remote:BUILD.axum-0.5.15.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__axum_core__0_2_7",
        url = "https://crates.io/api/v1/crates/axum-core/0.2.7/download",
        type = "tar.gz",
        sha256 = "e4f44a0e6200e9d11a1cdc989e4b358f6e3d354fbf48478f345a17f4e43f8635",
        strip_prefix = "axum-core-0.2.7",
        build_file = Label("//library/crates/remote:BUILD.axum-core-0.2.7.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__base64__0_13_0",
        url = "https://crates.io/api/v1/crates/base64/0.13.0/download",
        type = "tar.gz",
        sha256 = "904dfeac50f3cdaba28fc6f57fdcddb75f49ed61346676a78c4ffe55877802fd",
        strip_prefix = "base64-0.13.0",
        build_file = Label("//library/crates/remote:BUILD.base64-0.13.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__base64__0_9_3",
        url = "https://crates.io/api/v1/crates/base64/0.9.3/download",
        type = "tar.gz",
        sha256 = "489d6c0ed21b11d038c31b6ceccca973e65d73ba3bd8ecb9a2babf5546164643",
        strip_prefix = "base64-0.9.3",
        build_file = Label("//library/crates/remote:BUILD.base64-0.9.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__better_any__0_2_0",
        url = "https://crates.io/api/v1/crates/better_any/0.2.0/download",
        type = "tar.gz",
        strip_prefix = "better_any-0.2.0",
        build_file = Label("//library/crates/remote:BUILD.better_any-0.2.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__bindgen__0_59_2",
        url = "https://crates.io/api/v1/crates/bindgen/0.59.2/download",
        type = "tar.gz",
        sha256 = "2bd2a9a458e8f4304c52c43ebb0cfbd520289f8379a52e329a38afda99bf8eb8",
        strip_prefix = "bindgen-0.59.2",
        build_file = Label("//library/crates/remote:BUILD.bindgen-0.59.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__bit_set__0_5_3",
        url = "https://crates.io/api/v1/crates/bit-set/0.5.3/download",
        type = "tar.gz",
        sha256 = "0700ddab506f33b20a03b13996eccd309a48e5ff77d0d95926aa0210fb4e95f1",
        strip_prefix = "bit-set-0.5.3",
        build_file = Label("//library/crates/remote:BUILD.bit-set-0.5.3.bazel"),
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
        name = "raze__block_buffer__0_10_3",
        url = "https://crates.io/api/v1/crates/block-buffer/0.10.3/download",
        type = "tar.gz",
        strip_prefix = "block-buffer-0.10.3",
        build_file = Label("//library/crates/remote:BUILD.block-buffer-0.10.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__bumpalo__3_11_1",
        url = "https://crates.io/api/v1/crates/bumpalo/3.11.1/download",
        type = "tar.gz",
        strip_prefix = "bumpalo-3.11.1",
        build_file = Label("//library/crates/remote:BUILD.bumpalo-3.11.1.bazel"),
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
        name = "raze__bytes__0_5_6",
        url = "https://crates.io/api/v1/crates/bytes/0.5.6/download",
        type = "tar.gz",
        sha256 = "0e4cec68f03f32e44924783795810fa50a7035d8c8ebe78580ad7e6c703fba38",
        strip_prefix = "bytes-0.5.6",
        build_file = Label("//library/crates/remote:BUILD.bytes-0.5.6.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__bytes__1_2_1",
        url = "https://crates.io/api/v1/crates/bytes/1.2.1/download",
        type = "tar.gz",
        sha256 = "ec8a7b6a70fde80372154c65702f00a0f56f3e1c36abbc6c440484be248856db",
        strip_prefix = "bytes-1.2.1",
        build_file = Label("//library/crates/remote:BUILD.bytes-1.2.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__cc__1_0_73",
        url = "https://crates.io/api/v1/crates/cc/1.0.73/download",
        type = "tar.gz",
        sha256 = "2fff2a6927b3bb87f9595d67196a70493f627687a71d87a0d692242c33f58c11",
        strip_prefix = "cc-1.0.73",
        build_file = Label("//library/crates/remote:BUILD.cc-1.0.73.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__cexpr__0_6_0",
        url = "https://crates.io/api/v1/crates/cexpr/0.6.0/download",
        type = "tar.gz",
        sha256 = "6fac387a98bb7c37292057cffc56d62ecb629900026402633ae9160df93a8766",
        strip_prefix = "cexpr-0.6.0",
        build_file = Label("//library/crates/remote:BUILD.cexpr-0.6.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__cfg_if__0_1_10",
        url = "https://crates.io/api/v1/crates/cfg-if/0.1.10/download",
        type = "tar.gz",
        sha256 = "4785bdd1c96b2a846b2bd7cc02e86b6b3dbf14e7e53446c4f54c92a361040822",
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
        name = "raze__chrono__0_4_22",
        url = "https://crates.io/api/v1/crates/chrono/0.4.22/download",
        type = "tar.gz",
        strip_prefix = "chrono-0.4.22",
        build_file = Label("//library/crates/remote:BUILD.chrono-0.4.22.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__clang_sys__1_3_3",
        url = "https://crates.io/api/v1/crates/clang-sys/1.3.3/download",
        type = "tar.gz",
        sha256 = "5a050e2153c5be08febd6734e29298e844fdb0fa21aeddd63b4eb7baa106c69b",
        strip_prefix = "clang-sys-1.3.3",
        build_file = Label("//library/crates/remote:BUILD.clang-sys-1.3.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__cloudabi__0_0_3",
        url = "https://crates.io/api/v1/crates/cloudabi/0.0.3/download",
        type = "tar.gz",
        sha256 = "ddfc5b9aa5d4507acaf872de71051dfd0e309860e88966e1051e462a077aac4f",
        strip_prefix = "cloudabi-0.0.3",
        build_file = Label("//library/crates/remote:BUILD.cloudabi-0.0.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__codespan_reporting__0_11_1",
        url = "https://crates.io/api/v1/crates/codespan-reporting/0.11.1/download",
        type = "tar.gz",
        strip_prefix = "codespan-reporting-0.11.1",
        build_file = Label("//library/crates/remote:BUILD.codespan-reporting-0.11.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__core_foundation__0_9_3",
        url = "https://crates.io/api/v1/crates/core-foundation/0.9.3/download",
        type = "tar.gz",
        strip_prefix = "core-foundation-0.9.3",
        build_file = Label("//library/crates/remote:BUILD.core-foundation-0.9.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__core_foundation_sys__0_8_3",
        url = "https://crates.io/api/v1/crates/core-foundation-sys/0.8.3/download",
        type = "tar.gz",
        strip_prefix = "core-foundation-sys-0.8.3",
        build_file = Label("//library/crates/remote:BUILD.core-foundation-sys-0.8.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__cpufeatures__0_2_5",
        url = "https://crates.io/api/v1/crates/cpufeatures/0.2.5/download",
        type = "tar.gz",
        strip_prefix = "cpufeatures-0.2.5",
        build_file = Label("//library/crates/remote:BUILD.cpufeatures-0.2.5.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__crossbeam__0_8_2",
        url = "https://crates.io/api/v1/crates/crossbeam/0.8.2/download",
        type = "tar.gz",
        strip_prefix = "crossbeam-0.8.2",
        build_file = Label("//library/crates/remote:BUILD.crossbeam-0.8.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__crossbeam_channel__0_5_6",
        url = "https://crates.io/api/v1/crates/crossbeam-channel/0.5.6/download",
        type = "tar.gz",
        strip_prefix = "crossbeam-channel-0.5.6",
        build_file = Label("//library/crates/remote:BUILD.crossbeam-channel-0.5.6.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__crossbeam_deque__0_8_2",
        url = "https://crates.io/api/v1/crates/crossbeam-deque/0.8.2/download",
        type = "tar.gz",
        strip_prefix = "crossbeam-deque-0.8.2",
        build_file = Label("//library/crates/remote:BUILD.crossbeam-deque-0.8.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__crossbeam_epoch__0_9_13",
        url = "https://crates.io/api/v1/crates/crossbeam-epoch/0.9.13/download",
        type = "tar.gz",
        strip_prefix = "crossbeam-epoch-0.9.13",
        build_file = Label("//library/crates/remote:BUILD.crossbeam-epoch-0.9.13.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__crossbeam_queue__0_3_8",
        url = "https://crates.io/api/v1/crates/crossbeam-queue/0.3.8/download",
        type = "tar.gz",
        strip_prefix = "crossbeam-queue-0.3.8",
        build_file = Label("//library/crates/remote:BUILD.crossbeam-queue-0.3.8.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__crossbeam_utils__0_8_14",
        url = "https://crates.io/api/v1/crates/crossbeam-utils/0.8.14/download",
        type = "tar.gz",
        strip_prefix = "crossbeam-utils-0.8.14",
        build_file = Label("//library/crates/remote:BUILD.crossbeam-utils-0.8.14.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__crypto_common__0_1_6",
        url = "https://crates.io/api/v1/crates/crypto-common/0.1.6/download",
        type = "tar.gz",
        strip_prefix = "crypto-common-0.1.6",
        build_file = Label("//library/crates/remote:BUILD.crypto-common-0.1.6.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__cxx__1_0_59",
        url = "https://crates.io/api/v1/crates/cxx/1.0.59/download",
        type = "tar.gz",
        strip_prefix = "cxx-1.0.59",
        build_file = Label("//library/crates/remote:BUILD.cxx-1.0.59.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__cxx_build__1_0_82",
        url = "https://crates.io/api/v1/crates/cxx-build/1.0.82/download",
        type = "tar.gz",
        strip_prefix = "cxx-build-1.0.82",
        build_file = Label("//library/crates/remote:BUILD.cxx-build-1.0.82.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__cxxbridge_flags__1_0_59",
        url = "https://crates.io/api/v1/crates/cxxbridge-flags/1.0.59/download",
        type = "tar.gz",
        strip_prefix = "cxxbridge-flags-1.0.59",
        build_file = Label("//library/crates/remote:BUILD.cxxbridge-flags-1.0.59.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__cxxbridge_macro__1_0_59",
        url = "https://crates.io/api/v1/crates/cxxbridge-macro/1.0.59/download",
        type = "tar.gz",
        strip_prefix = "cxxbridge-macro-1.0.59",
        build_file = Label("//library/crates/remote:BUILD.cxxbridge-macro-1.0.59.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__derivative__2_2_0",
        url = "https://crates.io/api/v1/crates/derivative/2.2.0/download",
        type = "tar.gz",
        sha256 = "fcc3dd5e9e9c0b295d6e1e4d811fb6f157d5ffd784b8d202fc62eac8035a770b",
        strip_prefix = "derivative-2.2.0",
        build_file = Label("//library/crates/remote:BUILD.derivative-2.2.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__digest__0_10_6",
        url = "https://crates.io/api/v1/crates/digest/0.10.6/download",
        type = "tar.gz",
        strip_prefix = "digest-0.10.6",
        build_file = Label("//library/crates/remote:BUILD.digest-0.10.6.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__dotenv__0_15_0",
        url = "https://crates.io/api/v1/crates/dotenv/0.15.0/download",
        type = "tar.gz",
        strip_prefix = "dotenv-0.15.0",
        build_file = Label("//library/crates/remote:BUILD.dotenv-0.15.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__either__1_8_0",
        url = "https://crates.io/api/v1/crates/either/1.8.0/download",
        type = "tar.gz",
        sha256 = "90e5c1c8368803113bf0c9584fc495a58b86dc8a29edbf8fe877d21d9507e797",
        strip_prefix = "either-1.8.0",
        build_file = Label("//library/crates/remote:BUILD.either-1.8.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__encoding_rs__0_8_31",
        url = "https://crates.io/api/v1/crates/encoding_rs/0.8.31/download",
        type = "tar.gz",
        strip_prefix = "encoding_rs-0.8.31",
        build_file = Label("//library/crates/remote:BUILD.encoding_rs-0.8.31.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__enum_dispatch__0_3_8",
        url = "https://crates.io/api/v1/crates/enum_dispatch/0.3.8/download",
        type = "tar.gz",
        sha256 = "0eb359f1476bf611266ac1f5355bc14aeca37b299d0ebccc038ee7058891c9cb",
        strip_prefix = "enum_dispatch-0.3.8",
        build_file = Label("//library/crates/remote:BUILD.enum_dispatch-0.3.8.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__fastrand__1_8_0",
        url = "https://crates.io/api/v1/crates/fastrand/1.8.0/download",
        type = "tar.gz",
        sha256 = "a7a407cfaa3385c4ae6b23e84623d48c2798d06e3e6a1878f7f59f17b3f86499",
        strip_prefix = "fastrand-1.8.0",
        build_file = Label("//library/crates/remote:BUILD.fastrand-1.8.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__fixedbitset__0_4_2",
        url = "https://crates.io/api/v1/crates/fixedbitset/0.4.2/download",
        type = "tar.gz",
        sha256 = "0ce7134b9999ecaf8bcd65542e436736ef32ddca1b3e06094cb6ec5755203b80",
        strip_prefix = "fixedbitset-0.4.2",
        build_file = Label("//library/crates/remote:BUILD.fixedbitset-0.4.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__fnv__1_0_7",
        url = "https://crates.io/api/v1/crates/fnv/1.0.7/download",
        type = "tar.gz",
        sha256 = "3f9eec918d3f24069decb9af1554cad7c880e2da24a9afd88aca000531ab82c1",
        strip_prefix = "fnv-1.0.7",
        build_file = Label("//library/crates/remote:BUILD.fnv-1.0.7.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__foreign_types__0_3_2",
        url = "https://crates.io/api/v1/crates/foreign-types/0.3.2/download",
        type = "tar.gz",
        strip_prefix = "foreign-types-0.3.2",
        build_file = Label("//library/crates/remote:BUILD.foreign-types-0.3.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__foreign_types_shared__0_1_1",
        url = "https://crates.io/api/v1/crates/foreign-types-shared/0.1.1/download",
        type = "tar.gz",
        strip_prefix = "foreign-types-shared-0.1.1",
        build_file = Label("//library/crates/remote:BUILD.foreign-types-shared-0.1.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__form_urlencoded__1_0_1",
        url = "https://crates.io/api/v1/crates/form_urlencoded/1.0.1/download",
        type = "tar.gz",
        strip_prefix = "form_urlencoded-1.0.1",
        build_file = Label("//library/crates/remote:BUILD.form_urlencoded-1.0.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__fuchsia_cprng__0_1_1",
        url = "https://crates.io/api/v1/crates/fuchsia-cprng/0.1.1/download",
        type = "tar.gz",
        sha256 = "a06f77d526c1a601b7c4cdd98f54b5eaabffc14d5f2f0296febdc7f357c6d3ba",
        strip_prefix = "fuchsia-cprng-0.1.1",
        build_file = Label("//library/crates/remote:BUILD.fuchsia-cprng-0.1.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__fuchsia_zircon__0_3_3",
        url = "https://crates.io/api/v1/crates/fuchsia-zircon/0.3.3/download",
        type = "tar.gz",
        sha256 = "2e9763c69ebaae630ba35f74888db465e49e259ba1bc0eda7d06f4a067615d82",
        strip_prefix = "fuchsia-zircon-0.3.3",
        build_file = Label("//library/crates/remote:BUILD.fuchsia-zircon-0.3.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__fuchsia_zircon_sys__0_3_3",
        url = "https://crates.io/api/v1/crates/fuchsia-zircon-sys/0.3.3/download",
        type = "tar.gz",
        sha256 = "3dcaa9ae7725d12cdb85b3ad99a434db70b468c09ded17e012d86b5c1010f7a7",
        strip_prefix = "fuchsia-zircon-sys-0.3.3",
        build_file = Label("//library/crates/remote:BUILD.fuchsia-zircon-sys-0.3.3.bazel"),
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
        name = "raze__futures_channel__0_3_24",
        url = "https://crates.io/api/v1/crates/futures-channel/0.3.24/download",
        type = "tar.gz",
        sha256 = "30bdd20c28fadd505d0fd6712cdfcb0d4b5648baf45faef7f852afb2399bb050",
        strip_prefix = "futures-channel-0.3.24",
        build_file = Label("//library/crates/remote:BUILD.futures-channel-0.3.24.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__futures_core__0_3_24",
        url = "https://crates.io/api/v1/crates/futures-core/0.3.24/download",
        type = "tar.gz",
        sha256 = "4e5aa3de05362c3fb88de6531e6296e85cde7739cccad4b9dfeeb7f6ebce56bf",
        strip_prefix = "futures-core-0.3.24",
        build_file = Label("//library/crates/remote:BUILD.futures-core-0.3.24.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__futures_executor__0_3_24",
        url = "https://crates.io/api/v1/crates/futures-executor/0.3.24/download",
        type = "tar.gz",
        sha256 = "9ff63c23854bee61b6e9cd331d523909f238fc7636290b96826e9cfa5faa00ab",
        strip_prefix = "futures-executor-0.3.24",
        build_file = Label("//library/crates/remote:BUILD.futures-executor-0.3.24.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__futures_io__0_3_24",
        url = "https://crates.io/api/v1/crates/futures-io/0.3.24/download",
        type = "tar.gz",
        sha256 = "bbf4d2a7a308fd4578637c0b17c7e1c7ba127b8f6ba00b29f717e9655d85eb68",
        strip_prefix = "futures-io-0.3.24",
        build_file = Label("//library/crates/remote:BUILD.futures-io-0.3.24.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__futures_macro__0_3_24",
        url = "https://crates.io/api/v1/crates/futures-macro/0.3.24/download",
        type = "tar.gz",
        sha256 = "42cd15d1c7456c04dbdf7e88bcd69760d74f3a798d6444e16974b505b0e62f17",
        strip_prefix = "futures-macro-0.3.24",
        build_file = Label("//library/crates/remote:BUILD.futures-macro-0.3.24.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__futures_sink__0_3_24",
        url = "https://crates.io/api/v1/crates/futures-sink/0.3.24/download",
        type = "tar.gz",
        sha256 = "21b20ba5a92e727ba30e72834706623d94ac93a725410b6a6b6fbc1b07f7ba56",
        strip_prefix = "futures-sink-0.3.24",
        build_file = Label("//library/crates/remote:BUILD.futures-sink-0.3.24.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__futures_task__0_3_24",
        url = "https://crates.io/api/v1/crates/futures-task/0.3.24/download",
        type = "tar.gz",
        sha256 = "a6508c467c73851293f390476d4491cf4d227dbabcd4170f3bb6044959b294f1",
        strip_prefix = "futures-task-0.3.24",
        build_file = Label("//library/crates/remote:BUILD.futures-task-0.3.24.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__futures_util__0_3_24",
        url = "https://crates.io/api/v1/crates/futures-util/0.3.24/download",
        type = "tar.gz",
        sha256 = "44fb6cb1be61cc1d2e43b262516aafcf63b241cffdb1d3fa115f91d9c7b09c90",
        strip_prefix = "futures-util-0.3.24",
        build_file = Label("//library/crates/remote:BUILD.futures-util-0.3.24.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__generic_array__0_14_6",
        url = "https://crates.io/api/v1/crates/generic-array/0.14.6/download",
        type = "tar.gz",
        strip_prefix = "generic-array-0.14.6",
        build_file = Label("//library/crates/remote:BUILD.generic-array-0.14.6.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__getrandom__0_2_7",
        url = "https://crates.io/api/v1/crates/getrandom/0.2.7/download",
        type = "tar.gz",
        sha256 = "4eb1a864a501629691edf6c15a593b7a51eebaa1e8468e9ddc623de7c9b58ec6",
        strip_prefix = "getrandom-0.2.7",
        build_file = Label("//library/crates/remote:BUILD.getrandom-0.2.7.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__glob__0_3_0",
        url = "https://crates.io/api/v1/crates/glob/0.3.0/download",
        type = "tar.gz",
        sha256 = "9b919933a397b79c37e33b77bb2aa3dc8eb6e165ad809e58ff75bc7db2e34574",
        strip_prefix = "glob-0.3.0",
        build_file = Label("//library/crates/remote:BUILD.glob-0.3.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__grpc__0_8_3",
        url = "https://crates.io/api/v1/crates/grpc/0.8.3/download",
        type = "tar.gz",
        sha256 = "efbd563cd51f8b9d3578a8029989b090aca83b8b411bfe1c7577b8b0f92937f8",
        strip_prefix = "grpc-0.8.3",
        build_file = Label("//library/crates/remote:BUILD.grpc-0.8.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__grpc_compiler__0_8_3",
        url = "https://crates.io/api/v1/crates/grpc-compiler/0.8.3/download",
        type = "tar.gz",
        sha256 = "45f971449e16e799ebbf106d2414c115ff46f2849689c61da3a3271be0884a34",
        strip_prefix = "grpc-compiler-0.8.3",
        build_file = Label("//library/crates/remote:BUILD.grpc-compiler-0.8.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__grpc_protobuf__0_8_3",
        url = "https://crates.io/api/v1/crates/grpc-protobuf/0.8.3/download",
        type = "tar.gz",
        sha256 = "2b39e472b8a5bd8344d55473eabda070bc28126cec26ca6a008fa1bbc3d0c4a2",
        strip_prefix = "grpc-protobuf-0.8.3",
        build_file = Label("//library/crates/remote:BUILD.grpc-protobuf-0.8.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__h2__0_3_14",
        url = "https://crates.io/api/v1/crates/h2/0.3.14/download",
        type = "tar.gz",
        sha256 = "5ca32592cf21ac7ccab1825cd87f6c9b3d9022c44d086172ed0966bec8af30be",
        strip_prefix = "h2-0.3.14",
        build_file = Label("//library/crates/remote:BUILD.h2-0.3.14.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__hashbrown__0_12_3",
        url = "https://crates.io/api/v1/crates/hashbrown/0.12.3/download",
        type = "tar.gz",
        sha256 = "8a9ee70c43aaf417c914396645a0fa852624801b24ebb7ae78fe8272889ac888",
        strip_prefix = "hashbrown-0.12.3",
        build_file = Label("//library/crates/remote:BUILD.hashbrown-0.12.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__heck__0_4_0",
        url = "https://crates.io/api/v1/crates/heck/0.4.0/download",
        type = "tar.gz",
        sha256 = "2540771e65fc8cb83cd6e8a237f70c319bd5c29f78ed1084ba5d50eeac86f7f9",
        strip_prefix = "heck-0.4.0",
        build_file = Label("//library/crates/remote:BUILD.heck-0.4.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__hermit_abi__0_1_19",
        url = "https://crates.io/api/v1/crates/hermit-abi/0.1.19/download",
        type = "tar.gz",
        sha256 = "62b467343b94ba476dcb2500d242dadbb39557df889310ac77c5d99100aaac33",
        strip_prefix = "hermit-abi-0.1.19",
        build_file = Label("//library/crates/remote:BUILD.hermit-abi-0.1.19.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__http__0_2_8",
        url = "https://crates.io/api/v1/crates/http/0.2.8/download",
        type = "tar.gz",
        sha256 = "75f43d41e26995c17e71ee126451dd3941010b0514a81a9d11f3b341debc2399",
        strip_prefix = "http-0.2.8",
        build_file = Label("//library/crates/remote:BUILD.http-0.2.8.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__http_body__0_4_5",
        url = "https://crates.io/api/v1/crates/http-body/0.4.5/download",
        type = "tar.gz",
        sha256 = "d5f38f16d184e36f2408a55281cd658ecbd3ca05cce6d6510a176eca393e26d1",
        strip_prefix = "http-body-0.4.5",
        build_file = Label("//library/crates/remote:BUILD.http-body-0.4.5.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__http_range_header__0_3_0",
        url = "https://crates.io/api/v1/crates/http-range-header/0.3.0/download",
        type = "tar.gz",
        sha256 = "0bfe8eed0a9285ef776bb792479ea3834e8b94e13d615c2f66d03dd50a435a29",
        strip_prefix = "http-range-header-0.3.0",
        build_file = Label("//library/crates/remote:BUILD.http-range-header-0.3.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__httparse__1_7_1",
        url = "https://crates.io/api/v1/crates/httparse/1.7.1/download",
        type = "tar.gz",
        sha256 = "496ce29bb5a52785b44e0f7ca2847ae0bb839c9bd28f69acac9b99d461c0c04c",
        strip_prefix = "httparse-1.7.1",
        build_file = Label("//library/crates/remote:BUILD.httparse-1.7.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__httpbis__0_9_1",
        url = "https://crates.io/api/v1/crates/httpbis/0.9.1/download",
        type = "tar.gz",
        sha256 = "3d3e4404f8f87938a2db89336609bde64363f5a556b15af936343e7252c9648d",
        strip_prefix = "httpbis-0.9.1",
        build_file = Label("//library/crates/remote:BUILD.httpbis-0.9.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__httpdate__1_0_2",
        url = "https://crates.io/api/v1/crates/httpdate/1.0.2/download",
        type = "tar.gz",
        sha256 = "c4a1e36c821dbe04574f602848a19f742f4fb3c98d40449f11bcad18d6b17421",
        strip_prefix = "httpdate-1.0.2",
        build_file = Label("//library/crates/remote:BUILD.httpdate-1.0.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__hyper__0_14_20",
        url = "https://crates.io/api/v1/crates/hyper/0.14.20/download",
        type = "tar.gz",
        sha256 = "02c929dc5c39e335a03c405292728118860721b10190d98c2a0f0efd5baafbac",
        strip_prefix = "hyper-0.14.20",
        build_file = Label("//library/crates/remote:BUILD.hyper-0.14.20.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__hyper_timeout__0_4_1",
        url = "https://crates.io/api/v1/crates/hyper-timeout/0.4.1/download",
        type = "tar.gz",
        sha256 = "bbb958482e8c7be4bc3cf272a766a2b0bf1a6755e7a6ae777f017a31d11b13b1",
        strip_prefix = "hyper-timeout-0.4.1",
        build_file = Label("//library/crates/remote:BUILD.hyper-timeout-0.4.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__hyper_tls__0_5_0",
        url = "https://crates.io/api/v1/crates/hyper-tls/0.5.0/download",
        type = "tar.gz",
        strip_prefix = "hyper-tls-0.5.0",
        build_file = Label("//library/crates/remote:BUILD.hyper-tls-0.5.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__iana_time_zone__0_1_53",
        url = "https://crates.io/api/v1/crates/iana-time-zone/0.1.53/download",
        type = "tar.gz",
        strip_prefix = "iana-time-zone-0.1.53",
        build_file = Label("//library/crates/remote:BUILD.iana-time-zone-0.1.53.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__iana_time_zone_haiku__0_1_1",
        url = "https://crates.io/api/v1/crates/iana-time-zone-haiku/0.1.1/download",
        type = "tar.gz",
        strip_prefix = "iana-time-zone-haiku-0.1.1",
        build_file = Label("//library/crates/remote:BUILD.iana-time-zone-haiku-0.1.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__idna__0_2_3",
        url = "https://crates.io/api/v1/crates/idna/0.2.3/download",
        type = "tar.gz",
        strip_prefix = "idna-0.2.3",
        build_file = Label("//library/crates/remote:BUILD.idna-0.2.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__indexmap__1_9_1",
        url = "https://crates.io/api/v1/crates/indexmap/1.9.1/download",
        type = "tar.gz",
        sha256 = "10a35a97730320ffe8e2d410b5d3b69279b98d2c14bdb8b70ea89ecf7888d41e",
        strip_prefix = "indexmap-1.9.1",
        build_file = Label("//library/crates/remote:BUILD.indexmap-1.9.1.bazel"),
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
        sha256 = "b2b3ea6ff95e175473f8ffe6a7eb7c00d054240321b84c57051175fe3c1e075e",
        strip_prefix = "iovec-0.1.4",
        build_file = Label("//library/crates/remote:BUILD.iovec-0.1.4.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__ipnet__2_5_1",
        url = "https://crates.io/api/v1/crates/ipnet/2.5.1/download",
        type = "tar.gz",
        strip_prefix = "ipnet-2.5.1",
        build_file = Label("//library/crates/remote:BUILD.ipnet-2.5.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__itertools__0_10_3",
        url = "https://crates.io/api/v1/crates/itertools/0.10.3/download",
        type = "tar.gz",
        sha256 = "a9a9d19fa1e79b6215ff29b9d6880b706147f16e9b1dbb1e4e5947b5b02bc5e3",
        strip_prefix = "itertools-0.10.3",
        build_file = Label("//library/crates/remote:BUILD.itertools-0.10.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__itoa__1_0_3",
        url = "https://crates.io/api/v1/crates/itoa/1.0.3/download",
        type = "tar.gz",
        sha256 = "6c8af84674fe1f223a982c933a0ee1086ac4d4052aa0fb8060c12c6ad838e754",
        strip_prefix = "itoa-1.0.3",
        build_file = Label("//library/crates/remote:BUILD.itoa-1.0.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__jobserver__0_1_24",
        url = "https://crates.io/api/v1/crates/jobserver/0.1.24/download",
        type = "tar.gz",
        sha256 = "af25a77299a7f711a01975c35a6a424eb6862092cc2d6c72c4ed6cbc56dfc1fa",
        strip_prefix = "jobserver-0.1.24",
        build_file = Label("//library/crates/remote:BUILD.jobserver-0.1.24.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__js_sys__0_3_60",
        url = "https://crates.io/api/v1/crates/js-sys/0.3.60/download",
        type = "tar.gz",
        strip_prefix = "js-sys-0.3.60",
        build_file = Label("//library/crates/remote:BUILD.js-sys-0.3.60.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__kernel32_sys__0_2_2",
        url = "https://crates.io/api/v1/crates/kernel32-sys/0.2.2/download",
        type = "tar.gz",
        sha256 = "7507624b29483431c0ba2d82aece8ca6cdba9382bff4ddd0f7490560c056098d",
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
        sha256 = "830d08ce1d1d941e6b30645f1a0eb5643013d835ce3779a5fc208261dbe10f55",
        strip_prefix = "lazycell-1.3.0",
        build_file = Label("//library/crates/remote:BUILD.lazycell-1.3.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__libc__0_2_132",
        url = "https://crates.io/api/v1/crates/libc/0.2.132/download",
        type = "tar.gz",
        sha256 = "8371e4e5341c3a96db127eb2465ac681ced4c433e01dd0e938adbef26ba93ba5",
        strip_prefix = "libc-0.2.132",
        build_file = Label("//library/crates/remote:BUILD.libc-0.2.132.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__libloading__0_7_3",
        url = "https://crates.io/api/v1/crates/libloading/0.7.3/download",
        type = "tar.gz",
        sha256 = "efbc0f03f9a775e9f6aed295c6a1ba2253c5757a9e03d55c6caa46a681abcddd",
        strip_prefix = "libloading-0.7.3",
        build_file = Label("//library/crates/remote:BUILD.libloading-0.7.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__librocksdb_sys__6_20_3",
        url = "https://crates.io/api/v1/crates/librocksdb-sys/6.20.3/download",
        type = "tar.gz",
        sha256 = "c309a9d2470844aceb9a4a098cf5286154d20596868b75a6b36357d2bb9ca25d",
        strip_prefix = "librocksdb-sys-6.20.3",
        build_file = Label("//library/crates/remote:BUILD.librocksdb-sys-6.20.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__link_cplusplus__1_0_7",
        url = "https://crates.io/api/v1/crates/link-cplusplus/1.0.7/download",
        type = "tar.gz",
        sha256 = "9272ab7b96c9046fbc5bc56c06c117cb639fe2d509df0c421cad82d2915cf369",
        strip_prefix = "link-cplusplus-1.0.7",
        build_file = Label("//library/crates/remote:BUILD.link-cplusplus-1.0.7.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__lock_api__0_4_8",
        url = "https://crates.io/api/v1/crates/lock_api/0.4.8/download",
        type = "tar.gz",
        sha256 = "9f80bf5aacaf25cbfc8210d1cfb718f2bf3b11c4c54e5afe36c236853a8ec390",
        strip_prefix = "lock_api-0.4.8",
        build_file = Label("//library/crates/remote:BUILD.lock_api-0.4.8.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__log__0_4_8",
        url = "https://crates.io/api/v1/crates/log/0.4.8/download",
        type = "tar.gz",
        strip_prefix = "log-0.4.8",
        build_file = Label("//library/crates/remote:BUILD.log-0.4.8.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__log_ndc__0_2_0",
        url = "https://crates.io/api/v1/crates/log-ndc/0.2.0/download",
        type = "tar.gz",
        sha256 = "edb09057c7b58b7d27498b528eaee9a1e661b2974a733fcabbbc3350360bc8bd",
        strip_prefix = "log-ndc-0.2.0",
        build_file = Label("//library/crates/remote:BUILD.log-ndc-0.2.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__matches__0_1_9",
        url = "https://crates.io/api/v1/crates/matches/0.1.9/download",
        type = "tar.gz",
        strip_prefix = "matches-0.1.9",
        build_file = Label("//library/crates/remote:BUILD.matches-0.1.9.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__matchit__0_5_0",
        url = "https://crates.io/api/v1/crates/matchit/0.5.0/download",
        type = "tar.gz",
        sha256 = "73cbba799671b762df5a175adf59ce145165747bb891505c43d09aefbbf38beb",
        strip_prefix = "matchit-0.5.0",
        build_file = Label("//library/crates/remote:BUILD.matchit-0.5.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__memchr__2_5_0",
        url = "https://crates.io/api/v1/crates/memchr/2.5.0/download",
        type = "tar.gz",
        sha256 = "2dffe52ecf27772e601905b7522cb4ef790d2cc203488bbd0e2fe85fcb74566d",
        strip_prefix = "memchr-2.5.0",
        build_file = Label("//library/crates/remote:BUILD.memchr-2.5.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__memoffset__0_7_1",
        url = "https://crates.io/api/v1/crates/memoffset/0.7.1/download",
        type = "tar.gz",
        strip_prefix = "memoffset-0.7.1",
        build_file = Label("//library/crates/remote:BUILD.memoffset-0.7.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__mime__0_3_16",
        url = "https://crates.io/api/v1/crates/mime/0.3.16/download",
        type = "tar.gz",
        sha256 = "2a60c7ce501c71e03a9c9c0d35b861413ae925bd979cc7a4e30d060069aaac8d",
        strip_prefix = "mime-0.3.16",
        build_file = Label("//library/crates/remote:BUILD.mime-0.3.16.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__minimal_lexical__0_2_1",
        url = "https://crates.io/api/v1/crates/minimal-lexical/0.2.1/download",
        type = "tar.gz",
        sha256 = "68354c5c6bd36d73ff3feceb05efa59b6acb7626617f4962be322a825e61f79a",
        strip_prefix = "minimal-lexical-0.2.1",
        build_file = Label("//library/crates/remote:BUILD.minimal-lexical-0.2.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__mio__0_6_23",
        url = "https://crates.io/api/v1/crates/mio/0.6.23/download",
        type = "tar.gz",
        sha256 = "4afd66f5b91bf2a3bc13fad0e21caedac168ca4c707504e75585648ae80e4cc4",
        strip_prefix = "mio-0.6.23",
        build_file = Label("//library/crates/remote:BUILD.mio-0.6.23.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__mio__0_8_4",
        url = "https://crates.io/api/v1/crates/mio/0.8.4/download",
        type = "tar.gz",
        sha256 = "57ee1c23c7c63b0c9250c339ffdc69255f110b298b901b9f6c82547b7b87caaf",
        strip_prefix = "mio-0.8.4",
        build_file = Label("//library/crates/remote:BUILD.mio-0.8.4.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__mio_uds__0_6_8",
        url = "https://crates.io/api/v1/crates/mio-uds/0.6.8/download",
        type = "tar.gz",
        sha256 = "afcb699eb26d4332647cc848492bbc15eafb26f08d0304550d5aa1f612e066f0",
        strip_prefix = "mio-uds-0.6.8",
        build_file = Label("//library/crates/remote:BUILD.mio-uds-0.6.8.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__miow__0_2_2",
        url = "https://crates.io/api/v1/crates/miow/0.2.2/download",
        type = "tar.gz",
        sha256 = "ebd808424166322d4a38da87083bfddd3ac4c131334ed55856112eb06d46944d",
        strip_prefix = "miow-0.2.2",
        build_file = Label("//library/crates/remote:BUILD.miow-0.2.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__multimap__0_8_3",
        url = "https://crates.io/api/v1/crates/multimap/0.8.3/download",
        type = "tar.gz",
        sha256 = "e5ce46fe64a9d73be07dcbe690a38ce1b293be448fd8ce1e6c1b8062c9f72c6a",
        strip_prefix = "multimap-0.8.3",
        build_file = Label("//library/crates/remote:BUILD.multimap-0.8.3.bazel"),
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
        name = "raze__native_tls__0_2_11",
        url = "https://crates.io/api/v1/crates/native-tls/0.2.11/download",
        type = "tar.gz",
        strip_prefix = "native-tls-0.2.11",
        build_file = Label("//library/crates/remote:BUILD.native-tls-0.2.11.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__net2__0_2_37",
        url = "https://crates.io/api/v1/crates/net2/0.2.37/download",
        type = "tar.gz",
        sha256 = "391630d12b68002ae1e25e8f974306474966550ad82dac6886fb8910c19568ae",
        strip_prefix = "net2-0.2.37",
        build_file = Label("//library/crates/remote:BUILD.net2-0.2.37.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__nom__7_1_1",
        url = "https://crates.io/api/v1/crates/nom/7.1.1/download",
        type = "tar.gz",
        sha256 = "a8903e5a29a317527874d0402f867152a3d21c908bb0b933e416c65e301d4c36",
        strip_prefix = "nom-7.1.1",
        build_file = Label("//library/crates/remote:BUILD.nom-7.1.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__num_integer__0_1_45",
        url = "https://crates.io/api/v1/crates/num-integer/0.1.45/download",
        type = "tar.gz",
        strip_prefix = "num-integer-0.1.45",
        build_file = Label("//library/crates/remote:BUILD.num-integer-0.1.45.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__num_traits__0_2_15",
        url = "https://crates.io/api/v1/crates/num-traits/0.2.15/download",
        type = "tar.gz",
        strip_prefix = "num-traits-0.2.15",
        build_file = Label("//library/crates/remote:BUILD.num-traits-0.2.15.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__num_cpus__1_13_1",
        url = "https://crates.io/api/v1/crates/num_cpus/1.13.1/download",
        type = "tar.gz",
        sha256 = "19e64526ebdee182341572e50e9ad03965aa510cd94427a4549448f285e957a1",
        strip_prefix = "num_cpus-1.13.1",
        build_file = Label("//library/crates/remote:BUILD.num_cpus-1.13.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__once_cell__1_13_1",
        url = "https://crates.io/api/v1/crates/once_cell/1.13.1/download",
        type = "tar.gz",
        sha256 = "074864da206b4973b84eb91683020dbefd6a8c3f0f38e054d93954e891935e4e",
        strip_prefix = "once_cell-1.13.1",
        build_file = Label("//library/crates/remote:BUILD.once_cell-1.13.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__openssl__0_10_42",
        url = "https://crates.io/api/v1/crates/openssl/0.10.42/download",
        type = "tar.gz",
        strip_prefix = "openssl-0.10.42",
        build_file = Label("//library/crates/remote:BUILD.openssl-0.10.42.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__openssl_macros__0_1_0",
        url = "https://crates.io/api/v1/crates/openssl-macros/0.1.0/download",
        type = "tar.gz",
        strip_prefix = "openssl-macros-0.1.0",
        build_file = Label("//library/crates/remote:BUILD.openssl-macros-0.1.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__openssl_probe__0_1_5",
        url = "https://crates.io/api/v1/crates/openssl-probe/0.1.5/download",
        type = "tar.gz",
        strip_prefix = "openssl-probe-0.1.5",
        build_file = Label("//library/crates/remote:BUILD.openssl-probe-0.1.5.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__openssl_sys__0_9_77",
        url = "https://crates.io/api/v1/crates/openssl-sys/0.9.77/download",
        type = "tar.gz",
        strip_prefix = "openssl-sys-0.9.77",
        build_file = Label("//library/crates/remote:BUILD.openssl-sys-0.9.77.bazel"),
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
        sha256 = "19b17cddbe7ec3f8bc800887bab5e717348c95ea2ca0b1bf0837fb964dc67099",
        strip_prefix = "peeking_take_while-0.1.2",
        build_file = Label("//library/crates/remote:BUILD.peeking_take_while-0.1.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__percent_encoding__2_1_0",
        url = "https://crates.io/api/v1/crates/percent-encoding/2.1.0/download",
        type = "tar.gz",
        sha256 = "d4fd5641d01c8f18a23da7b6fe29298ff4b55afcccdf78973b24cf3175fee32e",
        strip_prefix = "percent-encoding-2.1.0",
        build_file = Label("//library/crates/remote:BUILD.percent-encoding-2.1.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__petgraph__0_6_2",
        url = "https://crates.io/api/v1/crates/petgraph/0.6.2/download",
        type = "tar.gz",
        sha256 = "e6d5014253a1331579ce62aa67443b4a658c5e7dd03d4bc6d302b94474888143",
        strip_prefix = "petgraph-0.6.2",
        build_file = Label("//library/crates/remote:BUILD.petgraph-0.6.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__pin_project__1_0_12",
        url = "https://crates.io/api/v1/crates/pin-project/1.0.12/download",
        type = "tar.gz",
        sha256 = "ad29a609b6bcd67fee905812e544992d216af9d755757c05ed2d0e15a74c6ecc",
        strip_prefix = "pin-project-1.0.12",
        build_file = Label("//library/crates/remote:BUILD.pin-project-1.0.12.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__pin_project_internal__1_0_12",
        url = "https://crates.io/api/v1/crates/pin-project-internal/1.0.12/download",
        type = "tar.gz",
        sha256 = "069bdb1e05adc7a8990dce9cc75370895fbe4e3d58b9b73bf1aee56359344a55",
        strip_prefix = "pin-project-internal-1.0.12",
        build_file = Label("//library/crates/remote:BUILD.pin-project-internal-1.0.12.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__pin_project_lite__0_1_12",
        url = "https://crates.io/api/v1/crates/pin-project-lite/0.1.12/download",
        type = "tar.gz",
        sha256 = "257b64915a082f7811703966789728173279bdebb956b143dbcd23f6f970a777",
        strip_prefix = "pin-project-lite-0.1.12",
        build_file = Label("//library/crates/remote:BUILD.pin-project-lite-0.1.12.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__pin_project_lite__0_2_9",
        url = "https://crates.io/api/v1/crates/pin-project-lite/0.2.9/download",
        type = "tar.gz",
        sha256 = "e0a7ae3ac2f1173085d398531c705756c94a4c56843785df85a60c1a0afac116",
        strip_prefix = "pin-project-lite-0.2.9",
        build_file = Label("//library/crates/remote:BUILD.pin-project-lite-0.2.9.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__pin_utils__0_1_0",
        url = "https://crates.io/api/v1/crates/pin-utils/0.1.0/download",
        type = "tar.gz",
        sha256 = "8b870d8c151b6f2fb93e84a13146138f05d02ed11c7e7c54f8826aaaf7c9f184",
        strip_prefix = "pin-utils-0.1.0",
        build_file = Label("//library/crates/remote:BUILD.pin-utils-0.1.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__pkg_config__0_3_26",
        url = "https://crates.io/api/v1/crates/pkg-config/0.3.26/download",
        type = "tar.gz",
        strip_prefix = "pkg-config-0.3.26",
        build_file = Label("//library/crates/remote:BUILD.pkg-config-0.3.26.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__ppv_lite86__0_2_16",
        url = "https://crates.io/api/v1/crates/ppv-lite86/0.2.16/download",
        type = "tar.gz",
        sha256 = "eb9f9e6e233e5c4a35559a617bf40a4ec447db2e84c20b55a6f83167b7e57872",
        strip_prefix = "ppv-lite86-0.2.16",
        build_file = Label("//library/crates/remote:BUILD.ppv-lite86-0.2.16.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__prettyplease__0_1_18",
        url = "https://crates.io/api/v1/crates/prettyplease/0.1.18/download",
        type = "tar.gz",
        sha256 = "697ae720ee02011f439e0701db107ffe2916d83f718342d65d7f8bf7b8a5fee9",
        strip_prefix = "prettyplease-0.1.18",
        build_file = Label("//library/crates/remote:BUILD.prettyplease-0.1.18.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__proc_macro2__1_0_43",
        url = "https://crates.io/api/v1/crates/proc-macro2/1.0.43/download",
        type = "tar.gz",
        sha256 = "0a2ca2c61bc9f3d74d2886294ab7b9853abd9c1ad903a3ac7815c58989bb7bab",
        strip_prefix = "proc-macro2-1.0.43",
        build_file = Label("//library/crates/remote:BUILD.proc-macro2-1.0.43.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__prost__0_11_0",
        url = "https://crates.io/api/v1/crates/prost/0.11.0/download",
        type = "tar.gz",
        sha256 = "399c3c31cdec40583bb68f0b18403400d01ec4289c383aa047560439952c4dd7",
        strip_prefix = "prost-0.11.0",
        build_file = Label("//library/crates/remote:BUILD.prost-0.11.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__prost_build__0_11_1",
        url = "https://crates.io/api/v1/crates/prost-build/0.11.1/download",
        type = "tar.gz",
        sha256 = "7f835c582e6bd972ba8347313300219fed5bfa52caf175298d860b61ff6069bb",
        strip_prefix = "prost-build-0.11.1",
        build_file = Label("//library/crates/remote:BUILD.prost-build-0.11.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__prost_derive__0_11_0",
        url = "https://crates.io/api/v1/crates/prost-derive/0.11.0/download",
        type = "tar.gz",
        sha256 = "7345d5f0e08c0536d7ac7229952590239e77abf0a0100a1b1d890add6ea96364",
        strip_prefix = "prost-derive-0.11.0",
        build_file = Label("//library/crates/remote:BUILD.prost-derive-0.11.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__prost_types__0_11_1",
        url = "https://crates.io/api/v1/crates/prost-types/0.11.1/download",
        type = "tar.gz",
        sha256 = "4dfaa718ad76a44b3415e6c4d53b17c8f99160dcb3a99b10470fce8ad43f6e3e",
        strip_prefix = "prost-types-0.11.1",
        build_file = Label("//library/crates/remote:BUILD.prost-types-0.11.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__protobuf__2_18_2",
        url = "https://crates.io/api/v1/crates/protobuf/2.18.2/download",
        type = "tar.gz",
        sha256 = "fe8e18df92889779cfe50ccf640173141ff73c5b2817e553d6d35230f798a036",
        strip_prefix = "protobuf-2.18.2",
        build_file = Label("//library/crates/remote:BUILD.protobuf-2.18.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__protobuf_codegen__2_18_2",
        url = "https://crates.io/api/v1/crates/protobuf-codegen/2.18.2/download",
        type = "tar.gz",
        sha256 = "f49782fe28b5ff7d5d51cbfbe8985f3ff863acea663c515ed369c53f72e1d628",
        strip_prefix = "protobuf-codegen-2.18.2",
        build_file = Label("//library/crates/remote:BUILD.protobuf-codegen-2.18.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__protoc__2_18_2",
        url = "https://crates.io/api/v1/crates/protoc/2.18.2/download",
        type = "tar.gz",
        sha256 = "d4c6edf525f5fa5a304eb9d64cd3d0c4656fd33755b49fcea145a49d131cc291",
        strip_prefix = "protoc-2.18.2",
        build_file = Label("//library/crates/remote:BUILD.protoc-2.18.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__protoc_rust__2_18_2",
        url = "https://crates.io/api/v1/crates/protoc-rust/2.18.2/download",
        type = "tar.gz",
        sha256 = "1463636fc5884879f810dfe1fa8e07c71fc90369553e9a572213839f175163a4",
        strip_prefix = "protoc-rust-2.18.2",
        build_file = Label("//library/crates/remote:BUILD.protoc-rust-2.18.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__protoc_rust_grpc__0_8_3",
        url = "https://crates.io/api/v1/crates/protoc-rust-grpc/0.8.3/download",
        type = "tar.gz",
        sha256 = "41e2bf99ec0d82b0446a9bce1e0e69806dfff6112415c195f997e55a7afbdb6c",
        strip_prefix = "protoc-rust-grpc-0.8.3",
        build_file = Label("//library/crates/remote:BUILD.protoc-rust-grpc-0.8.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__quote__1_0_21",
        url = "https://crates.io/api/v1/crates/quote/1.0.21/download",
        type = "tar.gz",
        sha256 = "bbe448f377a7d6961e30f5955f9b8d106c3f5e449d493ee1b125c1d43c2b5179",
        strip_prefix = "quote-1.0.21",
        build_file = Label("//library/crates/remote:BUILD.quote-1.0.21.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__rand__0_4_6",
        url = "https://crates.io/api/v1/crates/rand/0.4.6/download",
        type = "tar.gz",
        sha256 = "552840b97013b1a26992c11eac34bdd778e464601a4c2054b5f0bff7c6761293",
        strip_prefix = "rand-0.4.6",
        build_file = Label("//library/crates/remote:BUILD.rand-0.4.6.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__rand__0_5_6",
        url = "https://crates.io/api/v1/crates/rand/0.5.6/download",
        type = "tar.gz",
        sha256 = "c618c47cd3ebd209790115ab837de41425723956ad3ce2e6a7f09890947cacb9",
        strip_prefix = "rand-0.5.6",
        build_file = Label("//library/crates/remote:BUILD.rand-0.5.6.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__rand__0_8_5",
        url = "https://crates.io/api/v1/crates/rand/0.8.5/download",
        type = "tar.gz",
        sha256 = "34af8d1a0e25924bc5b7c43c079c942339d8f0a8b57c39049bef581b46327404",
        strip_prefix = "rand-0.8.5",
        build_file = Label("//library/crates/remote:BUILD.rand-0.8.5.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__rand_chacha__0_3_1",
        url = "https://crates.io/api/v1/crates/rand_chacha/0.3.1/download",
        type = "tar.gz",
        sha256 = "e6c10a63a0fa32252be49d21e7709d4d4baf8d231c2dbce1eaa8141b9b127d88",
        strip_prefix = "rand_chacha-0.3.1",
        build_file = Label("//library/crates/remote:BUILD.rand_chacha-0.3.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__rand_core__0_3_1",
        url = "https://crates.io/api/v1/crates/rand_core/0.3.1/download",
        type = "tar.gz",
        sha256 = "7a6fdeb83b075e8266dcc8762c22776f6877a63111121f5f8c7411e5be7eed4b",
        strip_prefix = "rand_core-0.3.1",
        build_file = Label("//library/crates/remote:BUILD.rand_core-0.3.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__rand_core__0_4_2",
        url = "https://crates.io/api/v1/crates/rand_core/0.4.2/download",
        type = "tar.gz",
        sha256 = "9c33a3c44ca05fa6f1807d8e6743f3824e8509beca625669633be0acbdf509dc",
        strip_prefix = "rand_core-0.4.2",
        build_file = Label("//library/crates/remote:BUILD.rand_core-0.4.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__rand_core__0_6_3",
        url = "https://crates.io/api/v1/crates/rand_core/0.6.3/download",
        type = "tar.gz",
        sha256 = "d34f1408f55294453790c48b2f1ebbb1c5b4b7563eb1f418bcfcfdbb06ebb4e7",
        strip_prefix = "rand_core-0.6.3",
        build_file = Label("//library/crates/remote:BUILD.rand_core-0.6.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__rdrand__0_4_0",
        url = "https://crates.io/api/v1/crates/rdrand/0.4.0/download",
        type = "tar.gz",
        sha256 = "678054eb77286b51581ba43620cc911abf02758c91f93f479767aed0f90458b2",
        strip_prefix = "rdrand-0.4.0",
        build_file = Label("//library/crates/remote:BUILD.rdrand-0.4.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__redox_syscall__0_2_16",
        url = "https://crates.io/api/v1/crates/redox_syscall/0.2.16/download",
        type = "tar.gz",
        sha256 = "fb5a58c1855b4b6819d59012155603f0b22ad30cad752600aadfcb695265519a",
        strip_prefix = "redox_syscall-0.2.16",
        build_file = Label("//library/crates/remote:BUILD.redox_syscall-0.2.16.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__regex__1_6_0",
        url = "https://crates.io/api/v1/crates/regex/1.6.0/download",
        type = "tar.gz",
        sha256 = "4c4eb3267174b8c6c2f654116623910a0fef09c4753f8dd83db29c48a0df988b",
        strip_prefix = "regex-1.6.0",
        build_file = Label("//library/crates/remote:BUILD.regex-1.6.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__regex_syntax__0_6_27",
        url = "https://crates.io/api/v1/crates/regex-syntax/0.6.27/download",
        type = "tar.gz",
        sha256 = "a3f87b73ce11b1619a3c6332f45341e0047173771e8b8b73f87bfeefb7b56244",
        strip_prefix = "regex-syntax-0.6.27",
        build_file = Label("//library/crates/remote:BUILD.regex-syntax-0.6.27.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__remove_dir_all__0_5_3",
        url = "https://crates.io/api/v1/crates/remove_dir_all/0.5.3/download",
        type = "tar.gz",
        sha256 = "3acd125665422973a33ac9d3dd2df85edad0f4ae9b00dafb1a05e43a9f5ef8e7",
        strip_prefix = "remove_dir_all-0.5.3",
        build_file = Label("//library/crates/remote:BUILD.remove_dir_all-0.5.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__reqwest__0_11_12",
        url = "https://crates.io/api/v1/crates/reqwest/0.11.12/download",
        type = "tar.gz",
        strip_prefix = "reqwest-0.11.12",
        build_file = Label("//library/crates/remote:BUILD.reqwest-0.11.12.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__rocksdb__0_17_0",
        url = "https://crates.io/api/v1/crates/rocksdb/0.17.0/download",
        type = "tar.gz",
        sha256 = "7a62eca5cacf2c8261128631bed9f045598d40bfbe4b29f5163f0f802f8f44a7",
        strip_prefix = "rocksdb-0.17.0",
        build_file = Label("//library/crates/remote:BUILD.rocksdb-0.17.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__rustc_hash__1_1_0",
        url = "https://crates.io/api/v1/crates/rustc-hash/1.1.0/download",
        type = "tar.gz",
        sha256 = "08d43f7aa6b08d49f382cde6a7982047c3426db949b1424bc4b7ec9ae12c6ce2",
        strip_prefix = "rustc-hash-1.1.0",
        build_file = Label("//library/crates/remote:BUILD.rustc-hash-1.1.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__ryu__1_0_11",
        url = "https://crates.io/api/v1/crates/ryu/1.0.11/download",
        type = "tar.gz",
        strip_prefix = "ryu-1.0.11",
        build_file = Label("//library/crates/remote:BUILD.ryu-1.0.11.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__safemem__0_3_3",
        url = "https://crates.io/api/v1/crates/safemem/0.3.3/download",
        type = "tar.gz",
        sha256 = "ef703b7cb59335eae2eb93ceb664c0eb7ea6bf567079d843e09420219668e072",
        strip_prefix = "safemem-0.3.3",
        build_file = Label("//library/crates/remote:BUILD.safemem-0.3.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__schannel__0_1_20",
        url = "https://crates.io/api/v1/crates/schannel/0.1.20/download",
        type = "tar.gz",
        strip_prefix = "schannel-0.1.20",
        build_file = Label("//library/crates/remote:BUILD.schannel-0.1.20.bazel"),
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
        name = "raze__scratch__1_0_2",
        url = "https://crates.io/api/v1/crates/scratch/1.0.2/download",
        type = "tar.gz",
        strip_prefix = "scratch-1.0.2",
        build_file = Label("//library/crates/remote:BUILD.scratch-1.0.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__security_framework__2_7_0",
        url = "https://crates.io/api/v1/crates/security-framework/2.7.0/download",
        type = "tar.gz",
        strip_prefix = "security-framework-2.7.0",
        build_file = Label("//library/crates/remote:BUILD.security-framework-2.7.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__security_framework_sys__2_6_1",
        url = "https://crates.io/api/v1/crates/security-framework-sys/2.6.1/download",
        type = "tar.gz",
        strip_prefix = "security-framework-sys-2.6.1",
        build_file = Label("//library/crates/remote:BUILD.security-framework-sys-2.6.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__serde__1_0_145",
        url = "https://crates.io/api/v1/crates/serde/1.0.145/download",
        type = "tar.gz",
        strip_prefix = "serde-1.0.145",
        build_file = Label("//library/crates/remote:BUILD.serde-1.0.145.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__serde_derive__1_0_147",
        url = "https://crates.io/api/v1/crates/serde_derive/1.0.147/download",
        type = "tar.gz",
        strip_prefix = "serde_derive-1.0.147",
        build_file = Label("//library/crates/remote:BUILD.serde_derive-1.0.147.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__serde_json__1_0_89",
        url = "https://crates.io/api/v1/crates/serde_json/1.0.89/download",
        type = "tar.gz",
        strip_prefix = "serde_json-1.0.89",
        build_file = Label("//library/crates/remote:BUILD.serde_json-1.0.89.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__serde_urlencoded__0_7_1",
        url = "https://crates.io/api/v1/crates/serde_urlencoded/0.7.1/download",
        type = "tar.gz",
        strip_prefix = "serde_urlencoded-0.7.1",
        build_file = Label("//library/crates/remote:BUILD.serde_urlencoded-0.7.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__sha_1__0_10_0",
        url = "https://crates.io/api/v1/crates/sha-1/0.10.0/download",
        type = "tar.gz",
        strip_prefix = "sha-1-0.10.0",
        build_file = Label("//library/crates/remote:BUILD.sha-1-0.10.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__sha2__0_10_6",
        url = "https://crates.io/api/v1/crates/sha2/0.10.6/download",
        type = "tar.gz",
        strip_prefix = "sha2-0.10.6",
        build_file = Label("//library/crates/remote:BUILD.sha2-0.10.6.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__shlex__1_1_0",
        url = "https://crates.io/api/v1/crates/shlex/1.1.0/download",
        type = "tar.gz",
        sha256 = "43b2853a4d09f215c24cc5489c992ce46052d359b5109343cbafbf26bc62f8a3",
        strip_prefix = "shlex-1.1.0",
        build_file = Label("//library/crates/remote:BUILD.shlex-1.1.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__slab__0_4_7",
        url = "https://crates.io/api/v1/crates/slab/0.4.7/download",
        type = "tar.gz",
        sha256 = "4614a76b2a8be0058caa9dbbaf66d988527d86d003c11a94fbd335d7661edcef",
        strip_prefix = "slab-0.4.7",
        build_file = Label("//library/crates/remote:BUILD.slab-0.4.7.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__smallvec__1_9_0",
        url = "https://crates.io/api/v1/crates/smallvec/1.9.0/download",
        type = "tar.gz",
        sha256 = "2fd0db749597d91ff862fd1d55ea87f7855a744a8425a64695b6fca237d1dad1",
        strip_prefix = "smallvec-1.9.0",
        build_file = Label("//library/crates/remote:BUILD.smallvec-1.9.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__socket2__0_4_6",
        url = "https://crates.io/api/v1/crates/socket2/0.4.6/download",
        type = "tar.gz",
        sha256 = "10c98bba371b9b22a71a9414e420f92ddeb2369239af08200816169d5e2dd7aa",
        strip_prefix = "socket2-0.4.6",
        build_file = Label("//library/crates/remote:BUILD.socket2-0.4.6.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__syn__1_0_99",
        url = "https://crates.io/api/v1/crates/syn/1.0.99/download",
        type = "tar.gz",
        sha256 = "58dbef6ec655055e20b86b15a8cc6d439cca19b667537ac6a1369572d151ab13",
        strip_prefix = "syn-1.0.99",
        build_file = Label("//library/crates/remote:BUILD.syn-1.0.99.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__sync_wrapper__0_1_1",
        url = "https://crates.io/api/v1/crates/sync_wrapper/0.1.1/download",
        type = "tar.gz",
        sha256 = "20518fe4a4c9acf048008599e464deb21beeae3d3578418951a189c235a7a9a8",
        strip_prefix = "sync_wrapper-0.1.1",
        build_file = Label("//library/crates/remote:BUILD.sync_wrapper-0.1.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tempdir__0_3_7",
        url = "https://crates.io/api/v1/crates/tempdir/0.3.7/download",
        type = "tar.gz",
        sha256 = "15f2b5fb00ccdf689e0149d1b1b3c03fead81c2b37735d812fa8bddbbf41b6d8",
        strip_prefix = "tempdir-0.3.7",
        build_file = Label("//library/crates/remote:BUILD.tempdir-0.3.7.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tempfile__3_3_0",
        url = "https://crates.io/api/v1/crates/tempfile/3.3.0/download",
        type = "tar.gz",
        sha256 = "5cdb1ef4eaeeaddc8fbd371e5017057064af0911902ef36b39801f67cc6d79e4",
        strip_prefix = "tempfile-3.3.0",
        build_file = Label("//library/crates/remote:BUILD.tempfile-3.3.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__termcolor__1_1_3",
        url = "https://crates.io/api/v1/crates/termcolor/1.1.3/download",
        type = "tar.gz",
        strip_prefix = "termcolor-1.1.3",
        build_file = Label("//library/crates/remote:BUILD.termcolor-1.1.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__thiserror__1_0_37",
        url = "https://crates.io/api/v1/crates/thiserror/1.0.37/download",
        type = "tar.gz",
        strip_prefix = "thiserror-1.0.37",
        build_file = Label("//library/crates/remote:BUILD.thiserror-1.0.37.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__thiserror_impl__1_0_37",
        url = "https://crates.io/api/v1/crates/thiserror-impl/1.0.37/download",
        type = "tar.gz",
        strip_prefix = "thiserror-impl-1.0.37",
        build_file = Label("//library/crates/remote:BUILD.thiserror-impl-1.0.37.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__time__0_1_44",
        url = "https://crates.io/api/v1/crates/time/0.1.44/download",
        type = "tar.gz",
        strip_prefix = "time-0.1.44",
        build_file = Label("//library/crates/remote:BUILD.time-0.1.44.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tinyvec__1_6_0",
        url = "https://crates.io/api/v1/crates/tinyvec/1.6.0/download",
        type = "tar.gz",
        strip_prefix = "tinyvec-1.6.0",
        build_file = Label("//library/crates/remote:BUILD.tinyvec-1.6.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tinyvec_macros__0_1_0",
        url = "https://crates.io/api/v1/crates/tinyvec_macros/0.1.0/download",
        type = "tar.gz",
        strip_prefix = "tinyvec_macros-0.1.0",
        build_file = Label("//library/crates/remote:BUILD.tinyvec_macros-0.1.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tls_api__0_4_0",
        url = "https://crates.io/api/v1/crates/tls-api/0.4.0/download",
        type = "tar.gz",
        sha256 = "4ebb4107c167a4087349fcf08aea4debc358fe69d60fe1df991781842cfe98a3",
        strip_prefix = "tls-api-0.4.0",
        build_file = Label("//library/crates/remote:BUILD.tls-api-0.4.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tls_api_stub__0_4_0",
        url = "https://crates.io/api/v1/crates/tls-api-stub/0.4.0/download",
        type = "tar.gz",
        sha256 = "6f8ff269def04f25ae84b9aac156a400b92c97018a184036548c91cedaafd783",
        strip_prefix = "tls-api-stub-0.4.0",
        build_file = Label("//library/crates/remote:BUILD.tls-api-stub-0.4.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tokio__0_2_25",
        url = "https://crates.io/api/v1/crates/tokio/0.2.25/download",
        type = "tar.gz",
        sha256 = "6703a273949a90131b290be1fe7b039d0fc884aa1935860dfcbe056f28cd8092",
        strip_prefix = "tokio-0.2.25",
        build_file = Label("//library/crates/remote:BUILD.tokio-0.2.25.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tokio__1_20_1",
        url = "https://crates.io/api/v1/crates/tokio/1.20.1/download",
        type = "tar.gz",
        sha256 = "7a8325f63a7d4774dd041e363b2409ed1c5cbbd0f867795e661df066b2b0a581",
        strip_prefix = "tokio-1.20.1",
        build_file = Label("//library/crates/remote:BUILD.tokio-1.20.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tokio_io_timeout__1_2_0",
        url = "https://crates.io/api/v1/crates/tokio-io-timeout/1.2.0/download",
        type = "tar.gz",
        sha256 = "30b74022ada614a1b4834de765f9bb43877f910cc8ce4be40e89042c9223a8bf",
        strip_prefix = "tokio-io-timeout-1.2.0",
        build_file = Label("//library/crates/remote:BUILD.tokio-io-timeout-1.2.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tokio_macros__1_8_0",
        url = "https://crates.io/api/v1/crates/tokio-macros/1.8.0/download",
        type = "tar.gz",
        sha256 = "9724f9a975fb987ef7a3cd9be0350edcbe130698af5b8f7a631e23d42d052484",
        strip_prefix = "tokio-macros-1.8.0",
        build_file = Label("//library/crates/remote:BUILD.tokio-macros-1.8.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tokio_native_tls__0_3_0",
        url = "https://crates.io/api/v1/crates/tokio-native-tls/0.3.0/download",
        type = "tar.gz",
        strip_prefix = "tokio-native-tls-0.3.0",
        build_file = Label("//library/crates/remote:BUILD.tokio-native-tls-0.3.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tokio_stream__0_1_9",
        url = "https://crates.io/api/v1/crates/tokio-stream/0.1.9/download",
        type = "tar.gz",
        sha256 = "df54d54117d6fdc4e4fea40fe1e4e566b3505700e148a6827e59b34b0d2600d9",
        strip_prefix = "tokio-stream-0.1.9",
        build_file = Label("//library/crates/remote:BUILD.tokio-stream-0.1.9.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tokio_tungstenite__0_17_2",
        url = "https://crates.io/api/v1/crates/tokio-tungstenite/0.17.2/download",
        type = "tar.gz",
        strip_prefix = "tokio-tungstenite-0.17.2",
        build_file = Label("//library/crates/remote:BUILD.tokio-tungstenite-0.17.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tokio_util__0_7_3",
        url = "https://crates.io/api/v1/crates/tokio-util/0.7.3/download",
        type = "tar.gz",
        sha256 = "cc463cd8deddc3770d20f9852143d50bf6094e640b485cb2e189a2099085ff45",
        strip_prefix = "tokio-util-0.7.3",
        build_file = Label("//library/crates/remote:BUILD.tokio-util-0.7.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tonic__0_8_0",
        url = "https://crates.io/api/v1/crates/tonic/0.8.0/download",
        type = "tar.gz",
        sha256 = "498f271adc46acce75d66f639e4d35b31b2394c295c82496727dafa16d465dd2",
        strip_prefix = "tonic-0.8.0",
        build_file = Label("//library/crates/remote:BUILD.tonic-0.8.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tonic_build__0_8_0",
        url = "https://crates.io/api/v1/crates/tonic-build/0.8.0/download",
        type = "tar.gz",
        sha256 = "2fbcd2800e34e743b9ae795867d5f77b535d3a3be69fd731e39145719752df8c",
        strip_prefix = "tonic-build-0.8.0",
        build_file = Label("//library/crates/remote:BUILD.tonic-build-0.8.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tower__0_4_13",
        url = "https://crates.io/api/v1/crates/tower/0.4.13/download",
        type = "tar.gz",
        sha256 = "b8fa9be0de6cf49e536ce1851f987bd21a43b771b09473c3549a6c853db37c1c",
        strip_prefix = "tower-0.4.13",
        build_file = Label("//library/crates/remote:BUILD.tower-0.4.13.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tower_http__0_3_4",
        url = "https://crates.io/api/v1/crates/tower-http/0.3.4/download",
        type = "tar.gz",
        sha256 = "3c530c8675c1dbf98facee631536fa116b5fb6382d7dd6dc1b118d970eafe3ba",
        strip_prefix = "tower-http-0.3.4",
        build_file = Label("//library/crates/remote:BUILD.tower-http-0.3.4.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tower_layer__0_3_1",
        url = "https://crates.io/api/v1/crates/tower-layer/0.3.1/download",
        type = "tar.gz",
        sha256 = "343bc9466d3fe6b0f960ef45960509f84480bf4fd96f92901afe7ff3df9d3a62",
        strip_prefix = "tower-layer-0.3.1",
        build_file = Label("//library/crates/remote:BUILD.tower-layer-0.3.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tower_service__0_3_2",
        url = "https://crates.io/api/v1/crates/tower-service/0.3.2/download",
        type = "tar.gz",
        sha256 = "b6bc1c9ce2b5135ac7f93c72918fc37feb872bdc6a5533a8b85eb4b86bfdae52",
        strip_prefix = "tower-service-0.3.2",
        build_file = Label("//library/crates/remote:BUILD.tower-service-0.3.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tracing__0_1_35",
        url = "https://crates.io/api/v1/crates/tracing/0.1.35/download",
        type = "tar.gz",
        strip_prefix = "tracing-0.1.35",
        build_file = Label("//library/crates/remote:BUILD.tracing-0.1.35.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tracing_attributes__0_1_22",
        url = "https://crates.io/api/v1/crates/tracing-attributes/0.1.22/download",
        type = "tar.gz",
        sha256 = "11c75893af559bc8e10716548bdef5cb2b983f8e637db9d0e15126b61b484ee2",
        strip_prefix = "tracing-attributes-0.1.22",
        build_file = Label("//library/crates/remote:BUILD.tracing-attributes-0.1.22.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tracing_core__0_1_29",
        url = "https://crates.io/api/v1/crates/tracing-core/0.1.29/download",
        type = "tar.gz",
        sha256 = "5aeea4303076558a00714b823f9ad67d58a3bbda1df83d8827d21193156e22f7",
        strip_prefix = "tracing-core-0.1.29",
        build_file = Label("//library/crates/remote:BUILD.tracing-core-0.1.29.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tracing_futures__0_2_5",
        url = "https://crates.io/api/v1/crates/tracing-futures/0.2.5/download",
        type = "tar.gz",
        sha256 = "97d095ae15e245a057c8e8451bab9b3ee1e1f68e9ba2b4fbc18d0ac5237835f2",
        strip_prefix = "tracing-futures-0.2.5",
        build_file = Label("//library/crates/remote:BUILD.tracing-futures-0.2.5.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__try_lock__0_2_3",
        url = "https://crates.io/api/v1/crates/try-lock/0.2.3/download",
        type = "tar.gz",
        sha256 = "59547bce71d9c38b83d9c0e92b6066c4253371f15005def0c30d9657f50c7642",
        strip_prefix = "try-lock-0.2.3",
        build_file = Label("//library/crates/remote:BUILD.try-lock-0.2.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__tungstenite__0_17_3",
        url = "https://crates.io/api/v1/crates/tungstenite/0.17.3/download",
        type = "tar.gz",
        strip_prefix = "tungstenite-0.17.3",
        build_file = Label("//library/crates/remote:BUILD.tungstenite-0.17.3.bazel"),
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
        name = "raze__typenum__1_15_0",
        url = "https://crates.io/api/v1/crates/typenum/1.15.0/download",
        type = "tar.gz",
        strip_prefix = "typenum-1.15.0",
        build_file = Label("//library/crates/remote:BUILD.typenum-1.15.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__unicode_bidi__0_3_8",
        url = "https://crates.io/api/v1/crates/unicode-bidi/0.3.8/download",
        type = "tar.gz",
        strip_prefix = "unicode-bidi-0.3.8",
        build_file = Label("//library/crates/remote:BUILD.unicode-bidi-0.3.8.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__unicode_ident__1_0_3",
        url = "https://crates.io/api/v1/crates/unicode-ident/1.0.3/download",
        type = "tar.gz",
        sha256 = "c4f5b37a154999a8f3f98cc23a628d850e154479cd94decf3414696e12e31aaf",
        strip_prefix = "unicode-ident-1.0.3",
        build_file = Label("//library/crates/remote:BUILD.unicode-ident-1.0.3.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__unicode_normalization__0_1_22",
        url = "https://crates.io/api/v1/crates/unicode-normalization/0.1.22/download",
        type = "tar.gz",
        strip_prefix = "unicode-normalization-0.1.22",
        build_file = Label("//library/crates/remote:BUILD.unicode-normalization-0.1.22.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__unicode_width__0_1_10",
        url = "https://crates.io/api/v1/crates/unicode-width/0.1.10/download",
        type = "tar.gz",
        strip_prefix = "unicode-width-0.1.10",
        build_file = Label("//library/crates/remote:BUILD.unicode-width-0.1.10.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__unix_socket__0_5_0",
        url = "https://crates.io/api/v1/crates/unix_socket/0.5.0/download",
        type = "tar.gz",
        sha256 = "6aa2700417c405c38f5e6902d699345241c28c0b7ade4abaad71e35a87eb1564",
        strip_prefix = "unix_socket-0.5.0",
        build_file = Label("//library/crates/remote:BUILD.unix_socket-0.5.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__url__2_3_0",
        url = "https://crates.io/api/v1/crates/url/2.3.0/download",
        type = "tar.gz",
        strip_prefix = "url-2.3.0",
        build_file = Label("//library/crates/remote:BUILD.url-2.3.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__utf_8__0_7_6",
        url = "https://crates.io/api/v1/crates/utf-8/0.7.6/download",
        type = "tar.gz",
        strip_prefix = "utf-8-0.7.6",
        build_file = Label("//library/crates/remote:BUILD.utf-8-0.7.6.bazel"),
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
        name = "raze__uuid__1_1_2",
        url = "https://crates.io/api/v1/crates/uuid/1.1.2/download",
        type = "tar.gz",
        sha256 = "dd6469f4314d5f1ffec476e05f17cc9a78bc7a27a6a857842170bdf8d6f98d2f",
        strip_prefix = "uuid-1.1.2",
        build_file = Label("//library/crates/remote:BUILD.uuid-1.1.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__vcpkg__0_2_15",
        url = "https://crates.io/api/v1/crates/vcpkg/0.2.15/download",
        type = "tar.gz",
        strip_prefix = "vcpkg-0.2.15",
        build_file = Label("//library/crates/remote:BUILD.vcpkg-0.2.15.bazel"),
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
        sha256 = "6a02e4885ed3bc0f2de90ea6dd45ebcbb66dacffe03547fadbb0eeae2770887d",
        strip_prefix = "void-1.0.2",
        build_file = Label("//library/crates/remote:BUILD.void-1.0.2.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__want__0_3_0",
        url = "https://crates.io/api/v1/crates/want/0.3.0/download",
        type = "tar.gz",
        sha256 = "1ce8a968cb1cd110d136ff8b819a556d6fb6d919363c61534f6860c7eb172ba0",
        strip_prefix = "want-0.3.0",
        build_file = Label("//library/crates/remote:BUILD.want-0.3.0.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__wasi__0_10_0_wasi_snapshot_preview1",
        url = "https://crates.io/api/v1/crates/wasi/0.10.0+wasi-snapshot-preview1/download",
        type = "tar.gz",
        strip_prefix = "wasi-0.10.0+wasi-snapshot-preview1",
        build_file = Label("//library/crates/remote:BUILD.wasi-0.10.0+wasi-snapshot-preview1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__wasi__0_11_0_wasi_snapshot_preview1",
        url = "https://crates.io/api/v1/crates/wasi/0.11.0+wasi-snapshot-preview1/download",
        type = "tar.gz",
        sha256 = "9c8d87e72b64a3b4db28d11ce29237c246188f4f51057d65a7eab63b7987e423",
        strip_prefix = "wasi-0.11.0+wasi-snapshot-preview1",
        build_file = Label("//library/crates/remote:BUILD.wasi-0.11.0+wasi-snapshot-preview1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__wasm_bindgen__0_2_83",
        url = "https://crates.io/api/v1/crates/wasm-bindgen/0.2.83/download",
        type = "tar.gz",
        strip_prefix = "wasm-bindgen-0.2.83",
        build_file = Label("//library/crates/remote:BUILD.wasm-bindgen-0.2.83.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__wasm_bindgen_backend__0_2_83",
        url = "https://crates.io/api/v1/crates/wasm-bindgen-backend/0.2.83/download",
        type = "tar.gz",
        strip_prefix = "wasm-bindgen-backend-0.2.83",
        build_file = Label("//library/crates/remote:BUILD.wasm-bindgen-backend-0.2.83.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__wasm_bindgen_futures__0_4_33",
        url = "https://crates.io/api/v1/crates/wasm-bindgen-futures/0.4.33/download",
        type = "tar.gz",
        strip_prefix = "wasm-bindgen-futures-0.4.33",
        build_file = Label("//library/crates/remote:BUILD.wasm-bindgen-futures-0.4.33.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__wasm_bindgen_macro__0_2_83",
        url = "https://crates.io/api/v1/crates/wasm-bindgen-macro/0.2.83/download",
        type = "tar.gz",
        strip_prefix = "wasm-bindgen-macro-0.2.83",
        build_file = Label("//library/crates/remote:BUILD.wasm-bindgen-macro-0.2.83.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__wasm_bindgen_macro_support__0_2_83",
        url = "https://crates.io/api/v1/crates/wasm-bindgen-macro-support/0.2.83/download",
        type = "tar.gz",
        strip_prefix = "wasm-bindgen-macro-support-0.2.83",
        build_file = Label("//library/crates/remote:BUILD.wasm-bindgen-macro-support-0.2.83.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__wasm_bindgen_shared__0_2_83",
        url = "https://crates.io/api/v1/crates/wasm-bindgen-shared/0.2.83/download",
        type = "tar.gz",
        strip_prefix = "wasm-bindgen-shared-0.2.83",
        build_file = Label("//library/crates/remote:BUILD.wasm-bindgen-shared-0.2.83.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__web_sys__0_3_60",
        url = "https://crates.io/api/v1/crates/web-sys/0.3.60/download",
        type = "tar.gz",
        strip_prefix = "web-sys-0.3.60",
        build_file = Label("//library/crates/remote:BUILD.web-sys-0.3.60.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__which__4_2_5",
        url = "https://crates.io/api/v1/crates/which/4.2.5/download",
        type = "tar.gz",
        sha256 = "5c4fb54e6113b6a8772ee41c3404fb0301ac79604489467e0a9ce1f3e97c24ae",
        strip_prefix = "which-4.2.5",
        build_file = Label("//library/crates/remote:BUILD.which-4.2.5.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__winapi__0_2_8",
        url = "https://crates.io/api/v1/crates/winapi/0.2.8/download",
        type = "tar.gz",
        sha256 = "167dc9d6949a9b857f3451275e911c3f44255842c1f7a76f33c55103a909087a",
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
        sha256 = "2d315eee3b34aca4797b2da6b13ed88266e6d612562a0c46390af8299fc699bc",
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
        name = "raze__winapi_util__0_1_5",
        url = "https://crates.io/api/v1/crates/winapi-util/0.1.5/download",
        type = "tar.gz",
        strip_prefix = "winapi-util-0.1.5",
        build_file = Label("//library/crates/remote:BUILD.winapi-util-0.1.5.bazel"),
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
        name = "raze__windows_sys__0_36_1",
        url = "https://crates.io/api/v1/crates/windows-sys/0.36.1/download",
        type = "tar.gz",
        sha256 = "ea04155a16a59f9eab786fe12a4a450e75cdb175f9e0d80da1e17db09f55b8d2",
        strip_prefix = "windows-sys-0.36.1",
        build_file = Label("//library/crates/remote:BUILD.windows-sys-0.36.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__windows_aarch64_msvc__0_36_1",
        url = "https://crates.io/api/v1/crates/windows_aarch64_msvc/0.36.1/download",
        type = "tar.gz",
        sha256 = "9bb8c3fd39ade2d67e9874ac4f3db21f0d710bee00fe7cab16949ec184eeaa47",
        strip_prefix = "windows_aarch64_msvc-0.36.1",
        build_file = Label("//library/crates/remote:BUILD.windows_aarch64_msvc-0.36.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__windows_i686_gnu__0_36_1",
        url = "https://crates.io/api/v1/crates/windows_i686_gnu/0.36.1/download",
        type = "tar.gz",
        sha256 = "180e6ccf01daf4c426b846dfc66db1fc518f074baa793aa7d9b9aaeffad6a3b6",
        strip_prefix = "windows_i686_gnu-0.36.1",
        build_file = Label("//library/crates/remote:BUILD.windows_i686_gnu-0.36.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__windows_i686_msvc__0_36_1",
        url = "https://crates.io/api/v1/crates/windows_i686_msvc/0.36.1/download",
        type = "tar.gz",
        sha256 = "e2e7917148b2812d1eeafaeb22a97e4813dfa60a3f8f78ebe204bcc88f12f024",
        strip_prefix = "windows_i686_msvc-0.36.1",
        build_file = Label("//library/crates/remote:BUILD.windows_i686_msvc-0.36.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__windows_x86_64_gnu__0_36_1",
        url = "https://crates.io/api/v1/crates/windows_x86_64_gnu/0.36.1/download",
        type = "tar.gz",
        sha256 = "4dcd171b8776c41b97521e5da127a2d86ad280114807d0b2ab1e462bc764d9e1",
        strip_prefix = "windows_x86_64_gnu-0.36.1",
        build_file = Label("//library/crates/remote:BUILD.windows_x86_64_gnu-0.36.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__windows_x86_64_msvc__0_36_1",
        url = "https://crates.io/api/v1/crates/windows_x86_64_msvc/0.36.1/download",
        type = "tar.gz",
        sha256 = "c811ca4a8c853ef420abd8592ba53ddbbac90410fab6903b3e79972a631f7680",
        strip_prefix = "windows_x86_64_msvc-0.36.1",
        build_file = Label("//library/crates/remote:BUILD.windows_x86_64_msvc-0.36.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__winreg__0_10_1",
        url = "https://crates.io/api/v1/crates/winreg/0.10.1/download",
        type = "tar.gz",
        strip_prefix = "winreg-0.10.1",
        build_file = Label("//library/crates/remote:BUILD.winreg-0.10.1.bazel"),
    )

    maybe(
        http_archive,
        name = "raze__ws2_32_sys__0_2_1",
        url = "https://crates.io/api/v1/crates/ws2_32-sys/0.2.1/download",
        type = "tar.gz",
        sha256 = "d59cefebd0c892fa2dd6de581e937301d8552cb44489cdff035c6187cb63fa5e",
        strip_prefix = "ws2_32-sys-0.2.1",
        build_file = Label("//library/crates/remote:BUILD.ws2_32-sys-0.2.1.bazel"),
    )
