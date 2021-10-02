#!/bin/sh

# Load config
curl https://github.com/topscoder/nordvpn-udm/blob/main/config.env --out config.env
. ./config.env

# Install split-vpn
echo " "
echo "🌤    Installing split-vpn"
cd "${DATA_BASEDIR}"
mkdir -p "${SPLITVPN_DIR}" && cd "${SPLITVPN_DIR}"
curl -L https://github.com/peacey/split-vpn/archive/main.zip | unzip - -o
cp -rf split-vpn-main/vpn ./ && rm -rf split-vpn-main
chmod +x vpn/*.sh vpn/hooks/*/*.sh vpn/vpnc-script

# Create a directory for your VPN provider's openvpn configuration files
echo " "
echo "🌤    Creating nordvpn configuration directory"
mkdir -p "${NORDVPN_WORKDIR}"
cd "${NORDVPN_WORKDIR}"

echo " "
read -p "👉     Please enter the full URL (https://....) to the .ovpn file you want to use. See the README how to find it. 
-> " answer

while true
do
  case $answer in
   [http]* ) curl $answer --out ${OVPN_FILE}
           echo "☑️ Okay, just downloaded and saved to ${OVPN_FILE}"
           echo " "
           break;;

   * )     echo "‼️  Dude, just enter the full URL to the .ovpn file starting with http, please.";  exit;;
  esac
done

# We need to replace the line in .ovpn
# from:         auth-user-pass
# to:           /mnt/data/split-vpn/openvpn/nordvpn/username_password.txt
# TODO hardcoded path should be set to NORDVPN_WORKDIR and escape / with \
sed -i 's/auth-user-pass/auth-user-pass \/mnt\/data\/split-vpn\/openvpn\/nordvpn\/username_password.txt/' ${OVPN_FILE}

echo " "
read -p "👉     Enter your VPN username
-> " username
echo "$username" > ${NORDVPN_CREDENTIALS_FILE}

echo " "
read -p "👉     Enter your VPN password
-> " password
echo "$password" >> ${NORDVPN_CREDENTIALS_FILE}

chmod 600 ${NORDVPN_CREDENTIALS_FILE}

echo " "
echo "🌤    Credentials stored and permissions are set"

# Copy vpn.conf from sample file
cp ${SPLITVPN_DIR}/vpn/vpn.conf.sample ${NORDVPN_WORKDIR}/vpn.conf

# Set the default interface to route all traffic through this vpn
echo " "
read -p "🌤    Please enter the source interface you want to route all traffic through. Eg. br0 for default interface or br4 for vlan4 etc.
-> " tunnel_interface
sed -i 's/FORCED_SOURCE_INTERFACE="\b[a-z0-9]\{0,\}\b"/FORCED_SOURCE_INTERFACE="${tunnel_interface}"/' ${NORDVPN_WORKDIR}/vpn.conf

echo " "
read -p "🌤    We are ready to try and connect your VPN. Press any key to continue and press CTRL+C to stop the VPN....
->" ready

openvpn --config ${OVPN_FILE} \
        --route-noexec --redirect-gateway def1 \
        --up ${SPLITVPN_DIR}/vpn/updown.sh \
        --down ${SPLITVPN_DIR}/vpn/updown.sh \
        --auth-user-pass ${NORDVPN_CREDENTIALS_FILE} \
        --script-security 2

echo " "
echo "🌤    Did your VPN connection function successfully? Great! If not, please retry..."

chmod +x ${NORDVPN_WORKDIR}/10-nordvpn.sh
${NORDVPN_WORKDIR}/10-nordvpn.sh

echo " "
echo " "
echo "🌤    Installer done."
echo " "
echo "  Summary "
echo "  -------"
echo "  Split VPN installed from:        https://github.com/peacey/split-vpn"
echo "  Credentials are stored in:       ${NORDVPN_CREDENTIALS_FILE}"
echo "  VPN tunnel config is stored in:  ${NORDVPN_WORKDIR}/vpn.conf"
echo "  OpenVPN config downloaded from:  ${answer}"
echo "  OpenVPN config is stored in:     ${OVPN_FILE}"
echo "  -------"
echo " "