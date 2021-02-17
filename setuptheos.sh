#!/bin/sh

#  setuptheos.sh
#  brooklyn
#
#  Created by EthanRDoesMC on 2/13/21.
#  

CLEAR='\033[0m'
RED='\033[0;31m'

function usage() {
  if [ -n "$1" ]; then
    echo -e "${RED}$1${CLEAR}";
  fi
  echo "Platforms (-p): Linux/WSL/macOS"
  exit 1
}

while [[ "$#" > 0 ]]; do case $1 in
  -p|--platform) PLATFORM_NAME="$2"; shift;shift;;
  *) usage "Unknown parameter passed: $1"; shift; shift;;
esac; done

printf "
     \e[38;5;208m____\e[39m
    \e[38;5;202m/ __ ) __  ___  ____  ___  _____\e[39m
  \e[38;5;204m</ __  / _ \/ _ \/ __ \/ _ \/ ___/\e[39m
  \e[38;5;165m/ /_/ /  __/  __/ /_/ /  __/ /\e[39m
\e[38;5;129m</_____/\___/\___/ .___/\___/_/\e[39m
                \e[38;5;57m/_/\e[39m
"

if [ -z "$PLATFORM_NAME" ]; then
echo "What platform are you using?"
select lwm in "Linux" "WSL" "macOS"; do
case $lwm in
Linux ) PLATFORM_NAME="Linux"; break;;
WSL ) PLATFORM_NAME="WSL"; break;;
macOS ) PLATFORM_NAME="macOS"; break;;
esac
done
fi

if [ "$PLATFORM_NAME" != "Linux" ] && [ "$PLATFORM_NAME" != "WSL" ] && [ "$PLATFORM_NAME" != "macOS" ]; then
echo "$PLATFORM_NAME is an unsupported or invalid platform name. What platform are you using?"
select lwm in "Linux" "WSL" "macOS"; do
case $lwm in
Linux ) PLATFORM_NAME="Linux"; break;;
WSL ) PLATFORM_NAME="WSL"; break;;
macOS ) PLATFORM_NAME="macOS"; break;;
esac
done
fi

if [ "$PLATFORM_NAME" = "Linux" ] || [ "$PLATFORM_NAME" = "WSL" ]; then
if [ -z "$THEOS" ]; then
echo "Preparing installation for Linux..."
echo "Downloading LLVM..."
sudo bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"
echo "Updating apt..."
sudo apt-get update
echo "Installing build-related packages..."
sudo apt-get install fakeroot git perl clang-6.0 build-essential unzip zip
if [ "$PLATFORM_NAME" = "WSL" ]; then
echo "Setting WSL flag for fakeroot..."
sudo update-alternatives --set fakeroot /usr/bin/fakeroot-tcp
fi
echo "Adding THEOS to your shell..."
echo "export THEOS=~/theos" >> ~/.profile
THEOS=~/theos
git clone --recursive https://github.com/theos/theos.git $THEOS
curl https://kabiroberai.com/toolchain/download.php?toolchain=ios-linux -Lo toolchain.tar.gz
tar xzf toolchain.tar.gz -C $THEOS/toolchain
rm toolchain.tar.gz
curl -LO https://github.com/theos/sdks/archive/master.zip
TMP=$(mktemp -d)
unzip master.zip -d $TMP
mv $TMP/sdks-master/*.sdk $THEOS/sdks
rm -r master.zip $TMP
fi
curl -LO https://github.com/EthanRDoesMC/sdks/archive/main.zip
TMP=$(mktemp -d)
unzip main.zip -d $TMP
mv $TMP/sdks-main/*.sdk $THEOS/sdks
rm -r main.zip $TMP
echo "Done! Make sure to restart your shell."
fi

if [ "$PLATFORM_NAME" = "macOS" ]; then
echo "Ensure Xcode is installed. Seriously."
if [ -z "$THEOS" ]; then
which -s brew
if [[ $? != 0 ]] ; then
    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    brew update
fi
brew install ldid xz
echo "export THEOS=~/theos" >> ~/.profile
echo "export THEOS=~/theos" >> ~/.zprofile
THEOS=~/theos
curl -LO https://github.com/theos/sdks/archive/master.zip
TMP=$(mktemp -d)
unzip master.zip -d $TMP
mv $TMP/sdks-master/*.sdk $THEOS/sdks
rm -r master.zip $TMP
fi
curl -LO https://github.com/EthanRDoesMC/sdks/archive/main.zip
TMP=$(mktemp -d)
unzip main.zip -d $TMP
mv $TMP/sdks-main/*.sdk $THEOS/sdks
rm -r main.zip $TMP
fi
