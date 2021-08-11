load("@vaticle_bazel_distribution//packer:rules.bzl", "deploy_packer")
load("@vaticle_bazel_distribution//gcp:rules.bzl", "assemble_gcp")

assemble_gcp(
    name = "assemble-gcp-elk",
    install = "//tool/elk/images:install-elk.sh",
    project_id = "vaticle-factory-prod",
    disable_default_service_account = True,
    image_name = "elk-{{user `version`}}",
    source_image_family = "ubuntu-2004-lts",
    image_family = "web",
    zone = "europe-west2-b"
)

deploy_packer(
    name = "deploy-gcp-elk",
    target = ":assemble-gcp-elk",
)

