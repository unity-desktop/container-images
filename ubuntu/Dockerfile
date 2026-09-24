# syntax=docker/dockerfile:1.27

# hadolint ignore=DL3006
FROM ubuntu-base AS ubuntu

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

# hadolint ignore=DL3008
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    --mount=type=tmpfs,target=/var/log <<-EOT
    apt-get update
    apt-get install -y --no-install-recommends apt-transport-oci ca-certificates tini
EOT

COPY --link unity.asc /etc/apt/keyrings/unity.asc

ARG SUITE

COPY <<-EOT /etc/apt/sources.list.d/unity.sources
	Types: deb
	URIs: oci://ghcr.io/unity-desktop/ubuntu:${SUITE}
	Suites: ${SUITE}
	Components: main
	Signed-By: /etc/apt/keyrings/unity.asc
EOT

FROM scratch AS base

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

COPY --link --from=ubuntu / /

ENTRYPOINT ["tini", "--"]
CMD ["bash"]


FROM base AS builder

# hadolint ignore=DL3008
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    --mount=type=tmpfs,target=/var/log <<-EOT
    apt-get update
    apt-get install -y --no-install-recommends \
        build-essential debhelper devscripts equivs pkgconf \
        lintian eatmydata ca-certificates git \
        apt-transport-oci oras aptly
EOT
