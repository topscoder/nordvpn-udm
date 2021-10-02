#!/bin/sh

# Load environment configuration
. ../config.env

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