# NordVPN on Unifi Dream Machine (Pro)

## Foreword

This repo is forked from [SierraSoftworks/tailscale-udm](https://github.com/SierraSoftworks/tailscale-udm) which allows to use a Tailscale instance on your UDM / UDM Pro. What's cool also is his approach persists even after a reboot of your UDM.

## What is this?

This repo contains the scripts necessary to setup a [NordVPN](https://www.nordvpn.com/) connection on your [Unifi Dream Machine](https://unifi-network.ui.com/dreammachine) (UDM / UDM Pro).
It does so by piggy-backing on the excellent [boostchicken/udm-utilities](https://github.com/boostchicken/udm-utilities)
to provide a persistent service and runs using the OpenVPN service.

## Instructions

### Prerequisites

- You need to be able to connect to your UDM / UDM Pro via SSH in order to run this installer.
- You need an OpenVPN configuration file (.ovpn) from NordVPN. <br>
   You can do so by downloading a configuration file at the [NordVPN Server Tools](https://nordvpn.com/servers/tools/) page.

### Install NordVPN

1. Connect to your UDM using SSH 
   ```sh
   ssh root@<INTERNAL_IP_OF_UDM>
   ```
1. Follow the steps to install the boostchicken `on-boot-script` [here](https://github.com/boostchicken/udm-utilities/tree/master/on-boot-script).

1. Run the installer script to install `nordvpn` and the startup script on your UDM.
   
   ```sh
   curl -sSL https://raw.githubusercontent.com/topscoder/nordvpn-udm/main/installer.sh | sh
   ```
1. Follow the on-screen steps to configure `nordvpn` and connect it to your network.

1. How to run on boot

   ```sh
   https://github.com/peacey/split-vpn#how-do-i-run-this-at-boot
   ```

<!-- 4. Confirm that `tailscale` is working by running `/mnt/data/tailscale/tailscale status` -->

<!-- ### Upgrade Tailscale
Upgrading can be done by running the upgrade script below.

```sh
/mnt/data/tailscale/upgrade.sh 1.12.3
```

### Remove Tailscale
To remove Tailscale, you can run the following command, or run the steps below manually.
   
```sh
curl -sSL https://raw.githubusercontent.com/topscoder/nordvpn-udm/main/uninstall.sh | sh
```

1. Kill the `tailscaled` daemon.
   
   ```sh
   ps | grep tailscaled
   kill <PID>
   ```
2. Remove the boot script using `rm /mnt/data/on_boot.d/10-tailscaled.sh`
3. Have tailscale cleanup after itself using `/mnt/data/tailscale/tailscaled --cleanup`.
4. Remove the tailscale binaries and state using `rm -Rf /mnt/data/tailscale`.

-->

## Advanced configuration(s)

You want to be in full control of your network packets, bits and bytes? Sure you can. Find the split-vpn config file at `on_boot.d/10-nordvpn.conf` to go crazy ;-)

## Contributing

There are clearly lots of folks who are interested in running an OpenVPN connection on their Unifi gear. If
you're one of those people and have an idea for how this can be improved, please create a
PR and we'll be more than happy to incorporate the changes.
