variable "GITHUB_SHA" {
  default = "main"
}

variable "GITHUB_REPOSITORY" {
  default = "unity-desktop/container-images"
}

variable "GITHUB_ACTOR" {
  default = "unity-desktop"
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
  dockerfile = "Dockerfile"
  pull       = true
  args = {SOURCE_DATE_EPOCH = SOURCE_DATE_EPOCH}
  contexts = {"ubuntu-base" = "docker-image://ghcr.io/unity-desktop/base:latest"}
  output = ["type=image,compression=zstd,compression-level=19,oci-mediatypes=true,force-compression=true,rewrite-timestamp=${SOURCE_DATE_EPOCH != null}"]

  tags = ["${REGISTRY}/unity-desktop:latest","${REGISTRY}/unity-desktop:main"]

  cache-from = ["type=registry,ref=${REGISTRY}/unity-desktop:buildcache"]
  cache-to = ["type=registry,ref=${REGISTRY}/unity-desktop:buildcache,mode=max,compression=zstd,compression-level=12,ignore-error=true"]

  attest = [
    "type=provenance,mode=max,builder-id=https://github.com/${GITHUB_REPOSITORY}/actions/runs/${GITHUB_RUN_ID}",
  ]

  labels = {
    "org.opencontainers.image.title"         = "unity-desktop"
    "org.opencontainers.image.version"       = "latest"
    "org.opencontainers.image.created"       = SOURCE_DATE_EPOCH == null ? timestamp() : timeadd("1970-01-01T00:00:00Z", "${SOURCE_DATE_EPOCH}s")
    "org.opencontainers.image.authors"       = GITHUB_ACTOR
    "org.opencontainers.image.url"           = "https://github.com/${GITHUB_REPOSITORY}"
    "org.opencontainers.image.source"        = "https://github.com/${GITHUB_REPOSITORY}/tree/${GITHUB_SHA}"
    "org.opencontainers.image.documentation" = "https://github.com/${GITHUB_REPOSITORY}/blob/main/README.md"
    "org.opencontainers.image.revision"      = GITHUB_SHA
    "org.opencontainers.image.vendor"        = "unity-desktop"
    "org.opencontainers.image.licenses"      = "GPL-3.0-or-later"
    "org.opencontainers.image.base.name"     = "ghcr.io/unity-desktop/base:latest"
  }

  annotations = [
    for k, v in {
      "org.opencontainers.image.title"         = "unity-desktop"
      "org.opencontainers.image.version"       = "latest"
      "org.opencontainers.image.created"       = SOURCE_DATE_EPOCH == null ? timestamp() : timeadd("1970-01-01T00:00:00Z", "${SOURCE_DATE_EPOCH}s")
      "org.opencontainers.image.authors"       = GITHUB_ACTOR
      "org.opencontainers.image.url"           = "https://github.com/${GITHUB_REPOSITORY}"
      "org.opencontainers.image.source"        = "https://github.com/${GITHUB_REPOSITORY}/tree/${GITHUB_SHA}"
      "org.opencontainers.image.documentation" = "https://github.com/${GITHUB_REPOSITORY}/blob/main/README.md"
      "org.opencontainers.image.revision"      = GITHUB_SHA
      "org.opencontainers.image.vendor"        = "unity-desktop"
      "org.opencontainers.image.licenses"      = "GPL-3.0-or-later"
      "org.opencontainers.image.base.name"     = "ghcr.io/unity-desktop/base:latest"
    } : "index,manifest:${k}=${v}"
  ]
}
