ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-41}"
ARG BASE_IMAGE="ghcr.io/ublue-os/bazzite-gnome"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} as phosphophypr

ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-41}"

## Other possible base images include:
# FROM ghcr.io/ublue-os/bazzite:stable
# FROM ghcr.io/ublue-os/bluefin-nvidia:stable
# 
# ... and so on, here are more base images
# Universal Blue Images: https://github.com/orgs/ublue-os/packages
# Fedora base image: quay.io/fedora/fedora-bootc:41
# CentOS base images: quay.io/centos-bootc/centos-bootc:stream10

COPY system_files/desktop/shared system_files/desktop/hyprland /

# # Removes basic Gnome implementation
# RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
#     rpm-ostree override remove gnome-shell && \
#     /usr/libexec/containerbuild/cleanup.sh && \
#     ostree container commit

# Setup Copr repos
RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
    curl -Lo /etc/yum.repos.d/_copr_kylegospo-bazzite.repo https://copr.fedorainfracloud.org/coprs/kylegospo/bazzite/repo/fedora-"${FEDORA_MAJOR_VERSION}"/kylegospo-bazzite-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_kylegospo-bazzite-multilib.repo https://copr.fedorainfracloud.org/coprs/kylegospo/bazzite-multilib/repo/fedora-"${FEDORA_MAJOR_VERSION}"/kylegospo-bazzite-multilib-fedora-"${FEDORA_MAJOR_VERSION}".repo?arch=x86_64 && \
    curl -Lo /etc/yum.repos.d/_copr_ublue-os-staging.repo https://copr.fedorainfracloud.org/coprs/ublue-os/staging/repo/fedora-"${FEDORA_MAJOR_VERSION}"/ublue-os-staging-fedora-"${FEDORA_MAJOR_VERSION}".repo?arch=x86_64 && \
    curl -Lo /etc/yum.repos.d/_copr_kylegospo-latencyflex.repo https://copr.fedorainfracloud.org/coprs/kylegospo/LatencyFleX/repo/fedora-"${FEDORA_MAJOR_VERSION}"/kylegospo-LatencyFleX-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_kylegospo-obs-vkcapture.repo https://copr.fedorainfracloud.org/coprs/kylegospo/obs-vkcapture/repo/fedora-"${FEDORA_MAJOR_VERSION}"/kylegospo-obs-vkcapture-fedora-"${FEDORA_MAJOR_VERSION}".repo?arch=x86_64 && \
    curl -Lo /etc/yum.repos.d/_copr_kylegospo-wallpaper-engine-kde-plugin.repo https://copr.fedorainfracloud.org/coprs/kylegospo/wallpaper-engine-kde-plugin/repo/fedora-"${FEDORA_MAJOR_VERSION}"/kylegospo-wallpaper-engine-kde-plugin-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_ycollet-audinux.repo https://copr.fedorainfracloud.org/coprs/ycollet/audinux/repo/fedora-"${FEDORA_MAJOR_VERSION}"/ycollet-audinux-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_kylegospo-rom-properties.repo https://copr.fedorainfracloud.org/coprs/kylegospo/rom-properties/repo/fedora-"${FEDORA_MAJOR_VERSION}"/kylegospo-rom-properties-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_kylegospo-webapp-manager.repo https://copr.fedorainfracloud.org/coprs/kylegospo/webapp-manager/repo/fedora-"${FEDORA_MAJOR_VERSION}"/kylegospo-webapp-manager-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_hhd-dev-hhd.repo https://copr.fedorainfracloud.org/coprs/hhd-dev/hhd/repo/fedora-"${FEDORA_MAJOR_VERSION}"/hhd-dev-hhd-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_che-nerd-fonts.repo https://copr.fedorainfracloud.org/coprs/che/nerd-fonts/repo/fedora-"${FEDORA_MAJOR_VERSION}"/che-nerd-fonts-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_sentry-switcheroo-control_discrete.repo https://copr.fedorainfracloud.org/coprs/sentry/switcheroo-control_discrete/repo/fedora-"${FEDORA_MAJOR_VERSION}"/sentry-switcheroo-control_discrete-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_hikariknight-looking-glass-kvmfr.repo https://copr.fedorainfracloud.org/coprs/hikariknight/looking-glass-kvmfr/repo/fedora-"${FEDORA_MAJOR_VERSION}"/hikariknight-looking-glass-kvmfr-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_mavit-discover-overlay.repo https://copr.fedorainfracloud.org/coprs/mavit/discover-overlay/repo/fedora-"${FEDORA_MAJOR_VERSION}"/mavit-discover-overlay-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_lizardbyte-beta.repo https://copr.fedorainfracloud.org/coprs/lizardbyte/beta/repo/fedora-"${FEDORA_MAJOR_VERSION}"/lizardbyte-beta-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_rok-cdemu.repo https://copr.fedorainfracloud.org/coprs/rok/cdemu/repo/fedora-"${FEDORA_MAJOR_VERSION}"/rok-cdemu-fedora-"${FEDORA_MAJOR_VERSION}".rep && \
    curl -Lo /etc/yum.repos.d/_copr_rodoma92-kde-cdemu-manager.repo https://copr.fedorainfracloud.org/coprs/rodoma92/kde-cdemu-manager/repo/fedora-"${FEDORA_MAJOR_VERSION}"/rodoma92-kde-cdemu-manager-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_rodoma92-rmlint.repo https://copr.fedorainfracloud.org/coprs/rodoma92/rmlint/repo/fedora-"${FEDORA_MAJOR_VERSION}"/rodoma92-rmlint-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_ilyaz-lact.repo https://copr.fedorainfracloud.org/coprs/ilyaz/LACT/repo/fedora-"${FEDORA_MAJOR_VERSION}"/ilyaz-LACT-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_atim-starship.repo https://copr.fedorainfracloud.org/coprs/atim/starship/repo/fedora-"${FEDORA_MAJOR_VERSION}"/atim-starship-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_sneexy-zen-browser.repo https://copr.fedorainfracloud.org/coprs/sneexy/zen-browser/repo/fedora-"${FEDORA_MAJOR_VERSION}"/sneexy-zen-browser-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_pgdev-ghostty.repo https://copr.fedorainfracloud.org/coprs/pgdev/ghostty/repo/fedora-"${FEDORA_MAJOR_VERSION}"/pgdev-ghostty-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_solopasha-hyprland.repo https://copr.fedorainfracloud.org/coprs/solopasha/hyprland/repo/fedora-"${FEDORA_MAJOR_VERSION}"/solopasha-hyprland-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_trs-sod-swaylock-effects.repo https://copr.fedorainfracloud.org/coprs/trs-sod/swaylock-effects/repo/fedora-"${FEDORA_MAJOR_VERSION}"/trs-sod-swaylock-effects-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_alebastr-sway-extras.repo https://copr.fedorainfracloud.org/coprs/alebastr/sway-extras/repo/fedora-"${FEDORA_MAJOR_VERSION}"/alebastr-sway-extras-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_aeiro-nwg-shell.repo https://copr.fedorainfracloud.org/coprs/aeiro/nwg-shell/repo/fedora-"${FEDORA_MAJOR_VERSION}"/aeiro-nwg-shell-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/zsh-autosuggest.repo https://download.opensuse.org/repositories/shells:zsh-users:zsh-autosuggestions/Fedora_Rawhide/shells:zsh-users:zsh-autosuggestions.repo && \
    curl -Lo /etc/yum.repos.d/cloudflare-warp.repo https://pkg.cloudflareclient.com/cloudflare-warp-ascii.repo && \
    curl -Lo /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo && \
    rpm-ostree install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
    sed -i 's@gpgcheck=1@gpgcheck=0@g' /etc/yum.repos.d/tailscale.repo && \
    sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/negativo17-fedora-multimedia.repo && \
    curl -Lo /etc/yum.repos.d/negativo17-fedora-steam.repo https://negativo17.org/repos/fedora-steam.repo && \
    curl -Lo /etc/yum.repos.d/negativo17-fedora-rar.repo https://negativo17.org/repos/fedora-rar.repo && \
    /usr/libexec/containerbuild/cleanup.sh && \
    ostree container commit

# Configure Hyprland
RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
    rpm-ostree install \
    pavucontrol \
    pamixer \
    network-manager-applet \
    python3 \
    python3-pip \
    python3-cairo \
    python3-gobject \
    blueman \
    brightnessctl \
    qt5-qtquickcontrols \
    qt5-qtquickcontrols2 \
    qt5-qtgraphicaleffects \
    hyprland \
    dunst \
    rofi-wayland \
    waybar \
    swww \
    swaylock-effects \
    wlogout \
    slurp \
    swappy \
    cliphist \
    hyprpaper \
    ghostty \
    parallel \
    jq \
    ImageMagick \
    qt5-qtimageformats \
    ffmpegthumbs \
    kde-cli-tools \
    nwg-look \
    qt5ct \
    qt6ct \
    kvantum \
    qt5-qtwayland \
    qt6-qtwayland \
    xdg-desktop-portal-hyprland \
    polkit-kde && \
    /usr/libexec/containerbuild/cleanup.sh && \
    ostree container commit

# Install Cloudflare WARP
RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
    rpm-ostree install cloudflare-warp && \
    /usr/libexec/containerbuild/cleanup.sh && \
    ostree container commit

# Install Zen Browser as Firefox replacement
RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
    rpm-ostree install zen-browser && \
    /usr/libexec/containerbuild/cleanup.sh && \
    ostree container commit

# Cleanup and Finalize
RUN /usr/libexec/containerbuild/image-info && \
    systemctl disable gdm.service && \
    systemctl enable sddm.service \
    /usr/libexec/containerbuild/cleanup.sh && \
    mkdir -p /var/tmp && chmod 1777 /var/tmp && \
    ostree container commit

