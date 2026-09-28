# syntax=docker/dockerfile:1.27

# hadolint ignore=DL3006
FROM ubuntu-base AS unity-desktop

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

# hadolint ignore=DL3008,DL3015
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    --mount=type=tmpfs,target=/var/log <<-EOT
    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        ubuntu-minimal ubuntu-standard grub-efi linux-generic
EOT


# hadolint ignore=DL3008,DL3015
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    --mount=type=tmpfs,target=/var/log <<-EOT
    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        wayfire \
        libastal-4-4 libastal-apps0 libastal-auth0 libastal-battery0 \
        libastal-bluetooth0 libastal-brightness0 libastal-greet0 \
        libastal-network0 libastal-notifd0 libastal-power-profiles0 \
        libastal-wireplumber0 \
        libgtk-4-1 libadwaita-1-0 accountsservice libaccountsservice1 \
        libgnome-desktop-4-2t64 gsettings-desktop-schemas libgdk-pixbuf-2.0-0 \
        libjson-glib-1.0-0 libwayland-client0 libgraphene-1.0-0
EOT
