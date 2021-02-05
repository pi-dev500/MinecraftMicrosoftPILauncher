#!/bin/bash
GREEN='\033[0;32m'
NC='\033[0m'
echo -e "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@#         @@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@*               @@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@               /@@@@@     /@@@@@@@@@@@@@@@@
@@@@@@@@@@@@&               &@@@@#              @@@@@@@@@@@@
@@@@@@@@(               @@@@@@@@@@@@(               @@@@@@@@
@@@@@@%            /@@@@@@@@@@@@@@@@@@@@@             @@@@@@
@@@@@@%        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         @@@@@@
@@@@@@%       /\033[0;32m(((\033[0m@@@@@@@@@@@@@@@@@@@@@@@@@\033[0;32m###\033[0m        @@@@@@
@@@@@@%       /\033[0;32m(((((((\033[0m&@@@@@@@@@@@@@@@%\033[0;32m#######\033[0m        @@@@@@
@@@@@@%       /\033[0;32m((((((((((((\033[0m@@@@@@@\033[0;32m########\033[0m@@@@        @@@@@@
@@@@@@%       /\033[0;32m((((\033[0m@@@@\033[0;32m(((((((\033[0;32m##########\033[0m&@@@@@        @@@@@@
@@@@@@%       /\033[0;32m((((\033[0m#@@@@@%\033[0;32m((((\033[0;32m###\033[0m&@@&\033[0;32m###\033[0m&@@@@@        @@@@@@
@@@@@@%       /\033[0;32m(((((((((\033[0m@%\033[0;32m((((\033[0m&@@@@@&\033[0;32m###\033[0m&@@@@@        @@@@@@
@@@@@@%       /\033[0;32m((((\033[0m@@&\033[0;32m((((((((\033[0m&@@@@@&\033[0;32m###\033[0m&@@@@@        @@@@@@
@@@@@@%         \033[0;32m(((\033[0m@@@@@@%\033[0;32m((((\033[0m&@@@@@&\033[0;32m###\033[0m&@@@@         @@@@@@
@@@@@@%             &@@@@%\033[0;32m((((\033[0m&@@@@@&\033[0;32m###\033[0m(             @@@@@@
@@@@@@@@@               /%\033[0;32m((((\033[0m&@@@@@               /@@@@@@@@
@@@@@@@@@@@@@                (&@               %@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@(                         @@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@                 @@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@        /@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
function error {
  echo -e "\\e[91m$1\\e[39m"
  exit 1
}

#use the error function often!
#If a certain command is necessary for installation to continue, then add this to the end of it:
# || error 'reason'
#example below:

mkdir -p ~/ATlauncher && cd ~/ATlauncher

#determine if host system is 64 bit arm64 or 32 bit armhf
if [ ! -z "$(file "$(readlink -f "/sbin/init")" | grep 64)" ];then
  MACHINE='aarch64'
elif [ ! -z "$(file "$(readlink -f "/sbin/init")" | grep 32)" ];then
  MACHINE='armv7l'
else
  echo "Failed to detect OS CPU architecture! Something is very wrong."
  exit 1
fi
#install zip for updater
sudo apt install zip || echo "\\e[91mFailed to install zip\! You can't use updater\!\\e[39m"
DIR=~/ATlauncher

# create folders
mkdir -p $DIR
cd "$DIR"

echo Setup 1/8 "(creating folders)"
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
echo Setup 2/8
rm -f launcher.jar
echo "Downloading launcher..."
wget -q --show-progress https://atlauncher.com/download/jar --output-document launcher.jar || error "failed to download \"launcher.jar\""
if [ -f /usr/bin/zip ];then
	rm -rf launcher && mkdir -p launcher && mv launcher.jar launcher && cd launcher && unzip * >/dev/null && rm launcher.jar && wget -q https://raw.githubusercontent.com/pi-dev500/MinecraftMicrosoftPILauncher/main/SplashScreen.png && mv SplashScreen.png assets/image/SplashScreen.png && zip -ru ../launcher.jar * >/dev/null && cd $DIR && rm -rf launcher
fi
cd $DIR
echo "Done!"

# download java  
echo Setup 3/8
echo Downloading java ...
if [ "$MACHINE" = "aarch64" ]; then
    if [ ! -f jdk-8u251-linux-arm64-vfp-hflt.tar.gz ]; then
        wget -q --show-progress https://github.com/mikehooper/Minecraft/raw/main/jdk-8u251-linux-arm64-vfp-hflt.tar.gz || error "failed to download java"
    fi
else
    if [ ! -f jdk-8u251-linux-arm32-vfp-hflt.tar.gz ]; then
        wget -q --show-progress https://github.com/mikehooper/Minecraft/raw/main/jdk-8u251-linux-arm32-vfp-hflt.tar.gz || error "failed to download java"
    fi
fi

# download lwjgl3arm*
echo Setup 4/7
echo downloading lwjgl3arm...
if [ "$MACHINE" = "aarch64" ]; then
    if [ ! -f lwjgl3arm64.tar.gz ]; then
        wget -q --show-progress https://github.com/mikehooper/Minecraft/raw/main/lwjgl3arm64.tar.gz || error "failed to download lwjgl3arm64"
    fi
else
    if [ ! -f lwjgl3arm32.tar.gz ]; then
        wget -q --show-progress https://github.com/mikehooper/Minecraft/raw/main/lwjgl3arm32.tar.gz || error "failed to download lwjgl3arm32"
    fi
    if [ ! -f lwjgl2arm32.tar.gz ]; then
        wget -q --show-progress https://github.com/mikehooper/Minecraft/raw/main/lwjgl2arm32.tar.gz || error "failed to download lwjgl2arm32"
    fi
fi
echo Done!
echo Setup 5/7
if [ ! -d /opt/jdk ]; then
    sudo mkdir -p /opt/jdk || error "Do you have administrator rights?"
fi
 
# extract oracle java  8
echo Extracting java ...
if [ "$MACHINE" = "aarch64" ]; then
    sudo tar -zxf jdk-8u251-linux-arm64-vfp-hflt.tar.gz -C /opt/jdk || error "Error to extract java" 
    # install opnjdk for launcher.jar and optifine install
    sudo apt install openjdk-11-jdk -y || error "Error to install openjdk"
else
    sudo tar -zxf jdk-8u251-linux-arm32-vfp-hflt.tar.gz -C /opt/jdk || error "Error to extract java"
fi

# extract lwjgl*
echo Setup 6/7
echo Extracting lwjgl...
if [ "$MACHINE" = "aarch64" ]; then
    tar -zxf lwjgl3arm64.tar.gz -C ~/lwjgl3arm64 || exit 1
else
    tar -zxf lwjgl3arm32.tar.gz -C ~/lwjgl3arm32 || exit 1
    tar -zxf lwjgl2arm32.tar.gz -C ~/lwjgl2arm32 || exit 1
fi

echo Setup 7/7
echo Configure java ...
sudo update-alternatives --install /usr/bin/java java /opt/jdk/jdk1.8.0_251/bin/java 0 || error "Error to configure java!"
sudo update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.8.0_251/bin/javac 0 || error "Error to configure java!"
if [ "$MACHINE" = "aarch64" ]; then
    echo Setting Open jdk
    sudo update-alternatives --set java /usr/lib/jvm/java-11-openjdk-arm64/bin/java || error "Error to configure java!"
    sudo update-alternatives --set javac /usr/lib/jvm/java-11-openjdk-arm64/bin/javac || error "Error to configure java!"
else
    echo Setting Oracle jdk
    sudo update-alternatives --set java /opt/jdk/jdk1.8.0_251/bin/java || error "Error to configure java!"
    sudo update-alternatives --set javac /opt/jdk/jdk1.8.0_251/bin/javac || error "Error to configure java!"
fi
 
echo done \!


#Move launcher to /usr/share/
cd $DIR
mkdir -p $HOME/.local/share/ATlauncher/jarfile && mv launcher.jar ~/.local/share/ATlauncher/jarfile/launcher.jar

#Create desktop shortcut
echo Creating desktop shortcut ...
wget https://github.com/pi-dev500/MinecraftMicrosoftPILauncher/raw/main/ATlauncherPI/icon-64.png && cp icon-64.png ~/.local/share/icons/ATlauncher.png
cd ~/.local/share/applications/
echo "[Desktop Entry]
Version=1.0
Type=Application
Name=ATlauncher
Comment=3D block based sandbox game
Icon=ATlauncher
Exec=java -jar $HOME/.local/share/ATlauncher/jarfile/launcher.jar
Categories=Game;
" >ATlauncher.desktop
cd $HOME/.local/share/ATlauncher
if [ -f /usr/bin/zip ];then
	wget -q --show-progress https://raw.githubusercontent.com/pi-dev500/MinecraftMicrosoftPILauncher/main/update
	mkdir -p ~/.local/share/ATlauncher/webpage
	cd ~/.local/share/ATlauncher/webpage
	wget -q https://github.com/ATLauncher/ATLauncher/releases/latest
	mkdir -p ~/.local/share/ATlauncher/webpage/old/
	mv latest old/latest
	mkdir -p ~/.config/autostart/ && cd ~/.config/autostart/
	echo "[Desktop Entry]
Version=1.0
Type=Application
Name=ATlauncher
Comment=3D block based sandbox game
Icon=ATlauncher
Exec=$HOME/.local/share/ATlauncher/update
Categories=Game;
" >ATlauncher.desktop
fi
echo Creating configuration file...
chmod +x ATlauncher.desktop
cd
mkdir -p $HOME/.local/share/ATlauncher/jarfile/configs && cd $HOME/.local/share/ATlauncher/jarfile/configs
if [  "$MACHINE" == "armv7l" ];then
  wget -q --show-progress https://raw.githubusercontent.com/pi-dev500/MinecraftMicrosoftPILauncher/main/ATconfigs/jarfilepath/configs/ATLauncher_armv7l.json --output-document ATLauncher.json
  echo '{
  "usingCustomJavaPath": false,
  "hideOldJavaWarning": false,
  "firstTimeRun": false,
  "hideJava9Warning": true,
  "addedPacks": [],
  "ignoreOneDriveWarning": false,
  "ignoreProgramFilesWarning": false,
  "rememberWindowSizePosition": false,
  "consoleSize": {
    "width": 650,
    "height": 400
  },
  "consolePosition": {
    "x": 0,
    "y": 0
  },
  "launcherSize": {
    "width": 1200,
    "height": 700
  },
  "language": "anglais",
  "theme": "com.atlauncher.themes.Vuesion",
  "dateFormat": "dd/MM/yyyy",
  "selectedTabOnStartup": 0,
  "sortPacksAlphabetically": false,
  "showPackNameAndVersion": true,
  "keepLauncherOpen": true,
  "enableConsole": true,
  "enableTrayMenu": true,
  "enableDiscordIntegration": true,
  "enableFeralGamemode": true,
  "disableAddModRestrictions": false,
  "disableCustomFonts": false,
  "useNativeFilePicker": false,
  "initialMemory": 512,
  "maximumMemory": 2048,
  "metaspace": 256,
  "windowWidth": 854,
  "windowHeight": 480,
  "javaPath": "/opt/jdk/jdk1.8.0_251/bin/java",
  "javaParameters": "-Dorg.lwjgl.librarypath='$HOME'/lwjgl3arm32 -Xmx1G -XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -XX:-UseAdaptiveSizePolicy -Xmn128M",
  "maximiseMinecraft": false,
  "ignoreJavaOnInstanceLaunch": false,
  "concurrentConnections": 8,
  "connectionTimeout": 30,
  "enableProxy": false,
  "proxyHost": "",
  "proxyPort": 8080,
  "proxyType": "HTTP",
  "forgeLoggingLevel": "INFO",
  "enableLogs": true,
  "enableAnalytics": true,
  "analyticsClientId": "30662333-d88f-4e21-8d77-95739af9bf78",
  "enableOpenEyeReporting": true,
  "enableServerChecker": false,
  "serverCheckerWait": 5,
  "enableModsBackups": false,
  "enableAutomaticBackupAfterLaunch": false
}' >ATLauncher.json
else
  wget -q --show-progress https://raw.githubusercontent.com/pi-dev500/MinecraftMicrosoftPILauncher/main/ATconfigs/jarfilepath/configs/ATLauncher_arm64.json --output-document ATLauncher.json
  echo '{
  "usingCustomJavaPath": false,
  "hideOldJavaWarning": false,
  "firstTimeRun": false,
  "hideJava9Warning": true,
  "addedPacks": [],
  "ignoreOneDriveWarning": false,
  "ignoreProgramFilesWarning": false,
  "rememberWindowSizePosition": false,
  "consoleSize": {
    "width": 650,
    "height": 400
  },
  "consolePosition": {
    "x": 0,
    "y": 0
  },
  "launcherSize": {
    "width": 1200,
    "height": 700
  },
  "language": "anglais",
  "theme": "com.atlauncher.themes.Vuesion",
  "dateFormat": "dd/MM/yyyy",
  "selectedTabOnStartup": 0,
  "sortPacksAlphabetically": false,
  "showPackNameAndVersion": true,
  "keepLauncherOpen": true,
  "enableConsole": true,
  "enableTrayMenu": true,
  "enableDiscordIntegration": true,
  "enableFeralGamemode": true,
  "disableAddModRestrictions": false,
  "disableCustomFonts": false,
  "useNativeFilePicker": false,
  "initialMemory": 512,
  "maximumMemory": 2048,
  "metaspace": 256,
  "windowWidth": 854,
  "windowHeight": 480,
  "javaPath": "/opt/jdk/jdk1.8.0_251/bin/java",
  "javaParameters": "-Dorg.lwjgl.librarypath='$HOME'/lwjgl3arm64 -Xmx1G -XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -XX:-UseAdaptiveSizePolicy -Xmn128M",
  "maximiseMinecraft": false,
  "ignoreJavaOnInstanceLaunch": false,
  "concurrentConnections": 8,
  "connectionTimeout": 30,
  "enableProxy": false,
  "proxyHost": "",
  "proxyPort": 8080,
  "proxyType": "HTTP",
  "forgeLoggingLevel": "INFO",
  "enableLogs": true,
  "enableAnalytics": true,
  "analyticsClientId": "30662333-d88f-4e21-8d77-95739af9bf78",
  "enableOpenEyeReporting": true,
  "enableServerChecker": false,
  "serverCheckerWait": 5,
  "enableModsBackups": false,
  "enableAutomaticBackupAfterLaunch": false
}' >ATLauncher.json
fi

sudo rm -rf ~/ATlauncher
echo 'Installation is now done! You can open the launcher by going to Menu > Games > ATlauncher'

