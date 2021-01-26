CC = gcc
install: ATlaunpi
	./install
remove:
	unzip -u ATlauncherPI.zip || wget https://raw.githubusercontent.com/pi-dev500/MinecraftMicrosoftPILauncher/main/ATlauncherPI.zip && unzip -u ATlauncherPI.zip >/dev/null && chmod +x ./ATlauncherPI/uninstall
	./ATlauncherPI/uninstall

ATlaunpi:
	cd
