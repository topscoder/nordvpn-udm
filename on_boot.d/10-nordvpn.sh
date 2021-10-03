#!/bin/sh

# Load environment configuration
# . ../config.env

DATA_BASEDIR="/mnt/data"
SPLITVPN_DIR="${DATA_BASEDIR}/split-vpn"
ON_BOOT_DIR="${DATA_BASEDIR}/on_boot.d"
NORDVPN_WORKDIR="${SPLITVPN_DIR}/openvpn/nordvpn"
NORDVPN_FLAGS=""
LOG_FILE="${NORDVPN_WORKDIR}/nordvpn.log"
OVPN_FILE="${NORDVPN_WORKDIR}/nordvpn.ovpn"
NORDVPN_CREDENTIALS_FILE="${NORDVPN_WORKDIR}/username_password.txt"


# Load configuration and run openvpn
. "${NORDVPN_WORKDIR}/vpn.conf"
cd "${NORDVPN_WORKDIR}"

# /mnt/data/split-vpn/vpn/updown.sh ${DEV} pre-up >pre-up.log 2>&1
nohup openvpn --config ${OVPN_FILE} \
              --route-noexec --redirect-gateway def1 \
              --up ${SPLITVPN_DIR}/vpn/updown.sh \
              --down ${SPLITVPN_DIR}/vpn/updown.sh \
              --dev-type tun --dev ${DEV} \
              --script-security 2 \
              --ping-restart 15 \
              --mute-replay-warnings > ${LOG_FILE} 2>&1 &
              