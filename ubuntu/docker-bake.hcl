variable "GITHUB_SHA" {
  default = "main"
}

variable "GITHUB_REPOSITORY" {
  default = "unity-desktop/container-images"
}

variable "GITHUB_ACTOR" {
  default = "github-actions[bot]"
}

variable "GITHUB_RUN_ID" {
  default = "local"
}

variable "SOURCE_DATE_EPOCH" {
  default = null
}

variable "REGISTRY" {
  default = "ghcr.io/${lower(split("/", GITHUB_REPOSITORY)[0])}"
}

target "default" {
  name = "${variant}-${release.codename}"
  matrix = {
    variant = ["base", "builder"]
    release = [
      { version = "26.04", codename = "resolute", alias = "lts" },
      { version = "26.10", codename = "stonking", alias = "latest" },
    ]
  }

  dockerfile = "Dockerfile"
  target     = variant
  pull       = true

  platforms = [
    "linux/amd64",
    "linux/arm64",
    "linux/arm/v7",
    "linux/ppc64le",
    "linux/riscv64",
    "linux/s390x",
  ]

  args = {
    SUITE             = release.codename
    SOURCE_DATE_EPOCH = SOURCE_DATE_EPOCH
  }

  contexts = {
    "ubuntu-base" = "docker-image://public.ecr.aws/docker/library/ubuntu:${release.version}"
  }

  output = ["type=image,compression=zstd,compression-level=19,oci-mediatypes=true,force-compression=true,rewrite-timestamp=${SOURCE_DATE_EPOCH != null}"]

  tags = [
    "${REGISTRY}/${variant}:${release.version}",
    "${REGISTRY}/${variant}:${release.codename}",
    "${REGISTRY}/${variant}:${release.alias}",
  ]

  cache-from = ["type=registry,ref=${REGISTRY}/${variant}:buildcache-${release.codename}"]
  cache-to   = ["type=registry,ref=${REGISTRY}/${variant}:buildcache-${release.codename},compression=zstd,compression-level=12,ignore-error=true"]

  attest = [
    "type=provenance,mode=max,builder-id=https://github.com/${GITHUB_REPOSITORY}/actions/runs/${GITHUB_RUN_ID}",
    "type=sbom,generator=docker/buildkit-syft-scanner",
  ]

  labels = {
    "org.opencontainers.image.title"         = variant
    "org.opencontainers.image.version"       = release.version
    "org.opencontainers.image.created"       = SOURCE_DATE_EPOCH == null ? timestamp() : timeadd("1970-01-01T00:00:00Z", "${SOURCE_DATE_EPOCH}s")
    "org.opencontainers.image.authors"       = GITHUB_ACTOR
    "org.opencontainers.image.url"           = "https://github.com/${GITHUB_REPOSITORY}"
    "org.opencontainers.image.source"        = "https://github.com/${GITHUB_REPOSITORY}/tree/${GITHUB_SHA}"
    "org.opencontainers.image.documentation" = "https://github.com/${GITHUB_REPOSITORY}/blob/main/README.md"
    "org.opencontainers.image.revision"      = GITHUB_SHA
    "org.opencontainers.image.vendor"        = "unity-desktop"
    "org.opencontainers.image.licenses"      = "GPL-3.0-or-later"
    "org.opencontainers.image.base.name"     = "public.ecr.aws/docker/library/ubuntu:${release.version}"
  }

  annotations = [
    for k, v in {
      "org.opencontainers.image.title"         = variant
      "org.opencontainers.image.version"       = release.version
      "org.opencontainers.image.created"       = SOURCE_DATE_EPOCH == null ? timestamp() : timeadd("1970-01-01T00:00:00Z", "${SOURCE_DATE_EPOCH}s")
      "org.opencontainers.image.authors"       = GITHUB_ACTOR
      "org.opencontainers.image.url"           = "https://github.com/${GITHUB_REPOSITORY}"
      "org.opencontainers.image.source"        = "https://github.com/${GITHUB_REPOSITORY}/tree/${GITHUB_SHA}"
      "org.opencontainers.image.documentation" = "https://github.com/${GITHUB_REPOSITORY}/blob/main/README.md"
      "org.opencontainers.image.revision"      = GITHUB_SHA
      "org.opencontainers.image.vendor"        = "unity-desktop"
      "org.opencontainers.image.licenses"      = "GPL-3.0-or-later"
      "org.opencontainers.image.base.name"     = "public.ecr.aws/docker/library/ubuntu:${release.version}"
    } : "index,manifest:${k}=${v}"
  ]
}
