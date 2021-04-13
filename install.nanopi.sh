#!/bin/bash
clear

echo EiaB \(Echolink in a Box by ZS6JPG\):: Installation Script for NanoPi
echo ---------------------------------------------------------------------

source /etc/lsb-release
ARCH=$(uname -m)

if [ "$DISTRIB_ID" != "Ubuntu" ]
then
    echo FAILURE: Expected Ubuntu as OS, got $DISTRIB_ID
    exit 1
fi

if [ "$ARCH" != "armv7l" ]
then
    echo FAILURE: Expected armv7l as architecture, got $ARCH
    exit 1
fi
 
function installDependency() {
    PKG_GIT_OK=$(dpkg-query -W --showformat='${Status}\n' $1|grep "install ok installed")
    echo Checking for Package: $1: $PKG_GIT_OK
    if [ "" = "$PKG_GIT_OK" ]; then
    echo "No $1. Setting up $1."
    sudo apt-get --yes install $1 
    fi
    echo
}

#Install dependencies
installDependency git
installDependency pdmenu
installDependency lnav

echo Checking for Package: $REQUIRED_PKG_GIT: $PKG_GIT_OK
if [ "" = "$PKG_GIT_OK" ]; then
  echo "No $REQUIRED_PKG_GIT. Setting up $REQUIRED_PKG_GIT."
  sudo apt-get --yes install $REQUIRED_PKG_GIT 
fi

if [ -d "/usr/share/eiab" ]; then
    echo
    echo Removing old version of EiaB
    echo ----------------------------
    rm -fr /usr/share/eiab/
    echo Done
    echo
fi

echo Downloading Echolink in a Box
echo -----------------------------
git clone https://github.com/JGPorteous/Echolink-In-A-Box.git /usr/share/eiab/
echo

cd /usr/share/eiab/
chmod +x ./scripts/*.sh
#./scripts/setup.sh

bash -c 'pdmenu --color /usr/share/eiab/scripts/pdsetup'

