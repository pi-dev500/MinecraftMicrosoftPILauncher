#!/bin/sh -e
function error{
	echo -e "\\e[91m$1\\e[39m"
	exit 1
fi
#determine if host system is 64 bit arm64 or 32 bit armhf
if [ ! -z "$(file "$(readlink -f "/sbin/init")" | grep 64)" ];then
  MACHINE='aarch64'
elif [ ! -z "$(file "$(readlink -f "/sbin/init")" | grep 32)" ];then
  MACHINE='armv7l'
else
  echo "Failed to detect OS CPU architecture! Something is very wrong."
fi
DIR=~/Minecraft

# create folders
echo Setup 1/9
mkdir -p $DIR
cd "$DIR"
pwd

echo Setup 2/9
if [ "$MACHINE" = "aarch64" ]; then
    echo "Raspberry Pi OS (64 bit)"
    if [ ! -d ~/lwjgl3arm64 ]; then
        mkdir ~/lwjgl3arm64
    fi
else
    echo "Raspberry Pi OS (32 bit)"
    if [ ! -d ~/lwjgl3arm32 ]; then
        mkdir ~/lwjgl3arm32
    fi
    if [ ! -d ~/lwjgl2arm32 ]; then
        mkdir ~/lwjgl2arm32
    fi
fi

# download minecraft launcher
echo Setup 3/9
if [ ! -f launcher.jar ]; then
	echo "Downloading launcher..."
    wget -q --show-progress https://github.com/pi-dev500/MinecraftMicrosoftPILauncher/blob/main/ATlauncher.jar?raw=true --output-document launcher.jar || error "Failed to download \"launcher.jar\""
	echo "Done!"
fi
# download java  
echo Setup 4/9
echo Downloading java ...
if [ "$MACHINE" = "aarch64" ]; then
    if [ ! -f jdk-8u251-linux-arm64-vfp-hflt.tar.gz ]; then
        wget -q --show-progress https://github.com/mikehooper/Minecraft/raw/main/jdk-8u251-linux-arm64-vfp-hflt.tar.gz
    fi
else
    if [ ! -f jdk-8u251-linux-arm32-vfp-hflt.tar.gz ]; then
        wget -q --show-progress https://github.com/mikehooper/Minecraft/raw/main/jdk-8u251-linux-arm32-vfp-hflt.tar.gz
    fi
fi

# download lwjgl3arm*
echo Setup 5/9
echo download lwjgl3arm
if [ "$MACHINE" = "aarch64" ]; then
    if [ ! -f lwjgl3arm64.tar.gz ]; then
        wget -q --show-progress https://github.com/mikehooper/Minecraft/raw/main/lwjgl3arm64.tar.gz || exit 1
    fi
else
    if [ ! -f lwjgl3arm32.tar.gz ]; then
        wget -q --show-progress https://github.com/mikehooper/Minecraft/raw/main/lwjgl3arm32.tar.gz || exit 1
    fi
    if [ ! -f lwjgl2arm32.tar.gz ]; then
        wget -q --show-progress https://github.com/mikehooper/Minecraft/raw/main/lwjgl2arm32.tar.gz || exit 1
    fi
fi

echo Setup 6/9
if [ ! -d /opt/jdk ]; then
    sudo mkdir /opt/jdk || exit 1
fi
 
# extract oracle java  8
echo Setup 7/9
echo Extracting java ...
if [ "$MACHINE" = "aarch64" ]; then
    sudo tar -zxf jdk-8u251-linux-arm64-vfp-hflt.tar.gz -C /opt/jdk || exit 1
    # install opnjdk for launcher.jar and optifine install
    sudo apt install openjdk-11-jdk -y || exit 1
else
    sudo tar -zxf jdk-8u251-linux-arm32-vfp-hflt.tar.gz -C /opt/jdk || exit 1
fi

# extract lwjgl*
echo Setup 8/9
echo Extracting lwjgl...
if [ "$MACHINE" = "aarch64" ]; then
    tar -zxf lwjgl3arm64.tar.gz -C ~/lwjgl3arm64 || exit 1
else
    tar -zxf lwjgl3arm32.tar.gz -C ~/lwjgl3arm32 || exit 1
    tar -zxf lwjgl2arm32.tar.gz -C ~/lwjgl2arm32 || exit 1
fi

echo Setup 9/9
echo Configure java
sudo update-alternatives --install /usr/bin/java java /opt/jdk/jdk1.8.0_251/bin/java 0 || exit 1
sudo update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.8.0_251/bin/javac 0 || exit 1
if [ "$MACHINE" = "aarch64" ]; then
    echo Setting Open jdk
    sudo update-alternatives --set java /usr/lib/jvm/java-11-openjdk-arm64/bin/java || exit 1
    sudo update-alternatives --set javac /usr/lib/jvm/java-11-openjdk-arm64/bin/javac || exit 1
else
    echo Setting Oracle jdk
    sudo update-alternatives --set java /opt/jdk/jdk1.8.0_251/bin/java || exit 1
    sudo update-alternatives --set javac /opt/jdk/jdk1.8.0_251/bin/javac || exit 1
fi
 
echo end setupMC
