CC = gcc
Install:
	./setupATpi.sh
remove: ATlaunpi
	unzip -u ATlauncherPI.zip && chmod +x ./ATlauncherPI/uninstall
	./ATlauncherPI/uninstall

ATlaunpi:
	rm -f ATlauncherPI.zip
	wget https://raw.githubusercontent.com/pi-dev500/MinecraftMicrosoftPILauncher/main/ATlauncherPI.zip
x86:
	./install_x86_64
beta:
        chmod +x ./pre-release/setupATpi.sh
        ./pre-release/setupATpi.sh
