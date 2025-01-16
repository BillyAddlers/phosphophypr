# Phosphophypr

<p align="center">
  <a href=""><img src="/repo_files/phosphophyllite.jpg" alt="Phosphophyllite"/></a>
</p>

> Phosphophypr is a Hyprland-focused Fedora Atomic Image tailored for your personal needs.

## About

## Features

### Desktop

Common variant available as `phosphophypr`, suitable for desktop computers.

- Automatic updates for the OS, Flatpaks, and all Distrobox containers - powered by [ublue-update](https://github.com/ublue-os/ublue-update) and [topgrade](https://github.com/topgrade-rs/topgrade).

> [!IMPORTANT]  
> **ISOs can be downloaded from our [website](https://phosphophypr.shirovi.my.id).**

Rebase from an existing upstream Fedora Atomic to this image if you want **Open Source GPU Drivers**:
(Please note: Mesa's Open Source option for NVIDIA GPUs, NVK is still prone to errors at the time of writing, for any issues relating to NVK [please submit a report with Mesa](<[url](https://docs.mesa3d.org/bugs.html)>), not Ublue/Bazzite/Phosphophypr)

```bash
rpm-ostree rebase ostree-unverified-registry:ghcr.io/billyaddlers/phosphophypr:stable
```

Nvidia Proprietary Variant coming soon!

**For users with Secure Boot enabled:** Follow Bazzite's [secure boot documentation](#secure-boot) prior to rebasing.

### SteamDeck/Handhelds

coming soon!

## Secure Boot

> [!WARNING]  
> **Steam Deck Users: The Steam Deck does not come with secure boot enabled and does not ship with any keys enrolled by default. Do not enable this unless you absolutely know what you're doing.**

Secure boot is supported with our custom key. The pub key can be found in the root of this repository [here](https://github.com/ublue-os/bazzite/blob/main/secure_boot.der).
If you'd like to enroll this key prior to installation or rebase, download the key and run the following:

```bash
sudo mokutil --timeout -1
sudo mokutil --import secure_boot.der
```

For users already on a Universal Blue image, you may instead run `ujust enroll-secure-boot-key`.

If asked for a password, use `universalblue`.
