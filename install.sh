#!/bin/sh

# Detect Architechture
arch=""
case $(uname -m) in
    x86_64) arch="x86_64" ;;
    arm)    arch="arm" ;;
    aarch64) arch="arm" ;;
esac

#Display Architechture
echo "System Arch: $arch"

# Download Zerotier
if [ "$arch" = "x86_64" ]; then
    echo x86_64 Detected, Downloading
    curl -LJO https://github.com/Dre-OS/BatoZero/releases/latest/download/zerotier-one-x86_64.tar.gz
elif [ "$arch" = "arm" ]; then
    echo arm Detected, Downloading
    curl -LJO https://github.com/Dre-OS/BatoZero/releases/latest/download/zerotier-one-aarch64.tar.gz
else
    echo Unsupported system architecture
    exit 1 # terminate and indicate error
fi

# Unpack downloaded archive
mkdir -p ./bin
if [ "$arch" = "x86_64" ]; then
    echo Extracting x86_64 Binaries
    tar --no-same-owner --transform='s|^.*/||' -xzf zerotier-one-x86_64.tar.gz -C ./bin
elif [ "$arch" = "arm" ]; then
    echo Extracting arm Binaries
    tar --no-same-owner --no-same-permissions --strip-components=1 -xzf zerotier-one-aarch64.tar.gz -C ./bin
else
    echo Unsupported system architecture
    exit 1 # terminate and indicate error
fi

# Install to root bin directory
install bin/* /usr/bin

# Add symlinks and set permissions
ln -s ./bin/zerotier-one /usr/bin/zerotier-one
ln -s ./bin/zerotier-one /usr/bin/zerotier-cli
ln -s ./bin/zerotier-one /usr/bin/zerotier-idtool
chmod +x /usr/bin/zerotier-one /usr/bin/zerotier-cli /usr/bin/zerotier-idtool

# Cleanup after installation
if [ "$arch" = "x86_64" ]; then
    echo Cleaning up x86_64 installation
    rm zerotier-one-x86_64.tar.gz
elif [ "$arch" = "arm" ]; then
    echo Cleaning up arm installation
    rm zerotier-one-aarch64.tar.gz
else
    echo Unsupported system architecture
    exit 1 # terminate and indicate error
fi

# Setup Startup File
curl -LJO https://raw.githubusercontent.com/Dre-OS/BatoZero/main/Zerotier
mv Zerotier /userdata/system/services/

batocera-save-overlay

# Enable Zerotier Service in background (idk how to run it on startup otherwise)
# /usr/bin/zerotier-one -d
