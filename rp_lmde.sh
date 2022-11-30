#!/bin/bash

esbREF=$(
echo ''
echo "Current Linux Standard Base:"
echo " $(lsb_release -sidrc)"
echo ''
)

prereqsREF=$(
echo '

sudo apt-get install libpng-dev git dialog unzip xmlstarlet libsdl2-dev libfreeimage-dev libfreetype6-dev libcurl4-openssl-dev rapidjson-dev libasound2-dev libgles2-mesa-dev build-essential cmake libvlc-dev libvlccore-dev vlc-bin fonts-droid-fallback flex bison libglew-dev libsamplerate0-dev libspeexdsp-dev libboost-filesystem-dev nasm

')

gitrpsetupREF=$(
echo '
cd ~/
git clone --depth=1 https://github.com/RetroPie/RetroPie-Setup.git
cd ~/RetroPie-Setup && sudo ./retropie_setup.sh
'
)

tweaksREF=$(
echo '


[~/RetroPie-Setup/scriptmodules/helpers.sh]:
compareVersions "$__os_debian_ver" lt 9 && pkg="libpng-dev" #LMDE


[~/RetroPie-Setup/scriptmodules/supplementary/emulationstation.sh]:
rp_module_repo="git https://github.com/RetroPie/EmulationStation.git"

rp_module_licence="https://raw.githubusercontent.com/RetroPie/EmulationStation/master/LICENSE.md"

')

cmakeREF=$(
echo '

cd /opt/retropie/supplementary/
sudo mv emulationstation emulationstation_bak

sudo git clone --recursive https://github.com/RetroPie/EmulationStation.git

sudo mv EmulationStation emulationstation
cd emulationstation
sudo cmake .
sudo make

cd /opt/retropie/supplementary/
sudo cp -R emulationstation_bak/scripts emulationstation/scripts
cd ~/
'
)

mainMENU()
{
# Confirm installESBflag
installESBflag=$(dialog --stdout --no-collapse --title "   [RetroPie] for LMDE  *DISCLAIMER* Use at your own Risk   " \
	--ok-label OK --cancel-label Exit \
	--menu "$esbREF"  25 75 20 \
	1 " [INSTALL]  Prequisites for RetroPie and ES" \
	2 " [DOWNLOAD] [RetroPie-Setup]" \
	3 " [TWEAK] ES/Helper Scripts in [RetroPie-Setup]" \
	4 " [OPEN] [RetroPie-Setup]" \
	5 " [INSTALL] emulationstation for LMDE" )
	
if [ "$installESBflag" == '1' ]; then
	confPREreqs=$(dialog --stdout --no-collapse --title " INSTALL Prequisites for RetroPie and EmulationStation" \
		--ok-label OK --cancel-label Back \
		--menu "                          ? ARE YOU SURE ?                            $prereqsREF" 25 75 20 \
		Y "YES [INSTALL]  Prequisites for RetroPie and ES" \
		B "BACK")
	if [ "$confPREreqs" == 'Y' ]; then
		tput reset
		# Debian Bullseye RetroPie + ES PreReqs
		sudo apt-get install -y git dialog unzip xmlstarlet
		sudo apt-get install -y libsdl2-dev libfreeimage-dev libfreetype6-dev libcurl4-openssl-dev rapidjson-dev libasound2-dev libgles2-mesa-dev build-essential cmake libvlc-dev libvlccore-dev vlc-bin fonts-droid-fallback
		sudo apt-get install -y flex bison libglew-dev nasm
		sudo apt-get install -y libsamplerate0-dev libspeexdsp-dev libpng-dev libboost-filesystem-dev libglew-dev nasm #libpng12-dev Depricated #libpng-dev
		
		dialog --no-collapse --title "   *FINISHED* [INSTALL]  Prequisites for RetroPie and ES  " --ok-label CONTINUE --msgbox "$prereqsREF"  25 75
	fi
	mainMENU
fi

if [ "$installESBflag" == '2' ]; then
	confGITrpsetup=$(dialog --stdout --no-collapse --title " [DOWNLOAD] [RetroPie-Setup]" \
		--ok-label OK --cancel-label Back \
		--menu "                          ? ARE YOU SURE ?                            $gitrpsetupREF" 25 75 20 \
		Y "YES [DOWNLOAD] [RetroPie-Setup]" \
		B "BACK")
	if [ "$confGITrpsetup" == 'Y' ]; then
		tput reset
		# Abort RetroPie-Setup Already Found
		if [ -d /opt/retropie/supplementary/emulationstation ]; then
			dialog --no-collapse --title "   *[~/RetroPie-Setup] ALREADY EXISTS*  " --ok-label CONTINUE --msgbox "/home/$USER/RetroPie-Setup"  25 75
			mainMENU
		fi
		# Debian Bullseye RetroPie + ES PreReqs
		sudo apt-get install -y git dialog unzip xmlstarlet
		cd ~/
		git clone --depth=1 https://github.com/RetroPie/RetroPie-Setup.git
		
		dialog --no-collapse --title "   *FINISHED* [DOWNLOAD] [RetroPie-Setup]  " --ok-label CONTINUE --msgbox "$gitrpsetupREF"  25 75
	fi
	mainMENU
fi

if [ "$installESBflag" == '3' ]; then
	confRPEStweaks=$(dialog --stdout --no-collapse --title " [TWEAK] ES/Helper Scripts in [RetroPie-Setup]" \
		--ok-label OK --cancel-label Back \
		--menu "                          ? ARE YOU SURE ?                            $tweaksREF" 25 75 20 \
		Y "YES [TWEAK] ES/Helper Scripts in [RetroPie-Setup]" \
		B "BACK")
	if [ "$confRPEStweaks" == 'Y' ]; then
		tput reset
		
		# Abort if ES/Helper Scripts Not Found
		if [ ! -f ~/RetroPie-Setup/scriptmodules/helpers.sh ]; then
			dialog --no-collapse --title "~/RetroPie-Setup/scriptmodules/helpers.sh NOT FOUND!" --ok-label CONTINUE --msgbox "DOWNLOAD RetroPie-Setup 1st! "  25 75
			mainMENU
		fi
		if [ ! -f ~/RetroPie-Setup/scriptmodules/supplementary/emulationstation.sh ]; then
			dialog --no-collapse --title "~/RetroPie-Setup/scriptmodules/supplementary/emulationstation.sh NOT FOUND!" --ok-label CONTINUE --msgbox "DOWNLOAD RetroPie-Setup 1st! "  25 75
			mainMENU
		fi
		
		# Debian Bullseye UPDATES to [~/RetroPie-Setup/scriptmodules/helpers.sh]
		if [ ! -f ~/RetroPie-Setup/scriptmodules/helpers.sh.bak ]; then cp ~/RetroPie-Setup/scriptmodules/helpers.sh ~/RetroPie-Setup/scriptmodules/helpers.sh.bak; fi
		# CHANGE: [compareVersions "$__os_debian_ver" lt 9 && pkg="libpng12-dev"] TO: [compareVersions "$__os_debian_ver" lt 9 && pkg="libpng-dev" #Debian Bullseye]
		sed -i "s/pkg=\"libpng12-dev\"/pkg=\"libpng-dev\"\ #LMDE/g" ~/RetroPie-Setup/scriptmodules/helpers.sh
		
		# Debian Bullseye UPDATES to [~/RetroPie-Setup/scriptmodules/supplementary/emulationstation.sh]
		if [ ! -f ~/RetroPie-Setup/scriptmodules/supplementary/emulationstation.sh.bak ]; then cp ~/RetroPie-Setup/scriptmodules/supplementary/emulationstation.sh ~/RetroPie-Setup/scriptmodules/supplementary/emulationstation.sh.bak; fi
		# CHANGE: [rp_module_licence="MIT https://raw.githubusercontent.com/RetroPie/EmulationStation/master/LICENSE.md"] TO: [rp_module_licence="https://raw.githubusercontent.com/RetroPie/EmulationStation/master/LICENSE.md"]
		# CHANGE: [rp_module_repo="git https://github.com/RetroPie/EmulationStation :_get_branch_emulationstation"] TO: [rp_module_repo="git https://github.com/RetroPie/EmulationStation.git"]
		sed -i "s/rp_module_licence=.*/rp_module_licence=\"https:\/\/raw.githubusercontent.com\/RetroPie\/EmulationStation\/master\/LICENSE.md\"/g" ~/RetroPie-Setup/scriptmodules/supplementary/emulationstation.sh
		sed -i "s/rp_module_repo=.*/rp_module_repo=\"git https:\/\/github.com\/RetroPie\/EmulationStation.git\"/g" ~/RetroPie-Setup/scriptmodules/supplementary/emulationstation.sh
		
		dialog --no-collapse --title "   *FINISHED* [TWEAK] ES Install Script in [RetroPie-Setup] " --ok-label CONTINUE --msgbox "$tweaksREF"  25 75
	fi
	mainMENU
fi

if [ "$installESBflag" == '4' ]; then
	confiRPsetup=$(dialog --stdout --no-collapse --title " GO TO [RetroPie-Setup] TO INSTALL EmulationStation FROM SOURCE" \
		--ok-label OK --cancel-label Back \
		--menu "                          ? ARE YOU SURE ?             \nRP Setup -> Manage Packages -> Manage core packages -> emulationstation\n" 25 75 20 \
		Y "YES OPEN [RetroPie-Setup]" \
		B "BACK")
	if [ "$confiRPsetup" == 'Y' ]; then
		tput reset
		# Abort if ES/Helper Scripts Not Found
		if [ ! -f ~/RetroPie-Setup/retropie_setup.sh ]; then
			dialog --no-collapse --title "~/RetroPie-Setup/retropie_setup.sh NOT FOUND!" --ok-label CONTINUE --msgbox "DOWNLOAD RetroPie-Setup 1st! "  25 75
			mainMENU
		fi
		
		cd ~/RetroPie-Setup && sudo bash ~/RetroPie-Setup/retropie_setup.sh
		#sudo bash ~/RetroPie-Setup/retropie_packages.sh retropiemenu launch "/home/$USER/RetroPie-Setup/retropie_setup.sh" </dev/tty > /dev/tty
		#exit 0
	fi
	mainMENU
fi

if [ "$installESBflag" == '5' ]; then	
	confMAKEes=$(dialog --stdout --no-collapse --title " [INSTALL] emulationstation for LMDE" \
		--ok-label OK --cancel-label Back \
		--menu "                          ? ARE YOU SURE ?                            $cmakeREF" 25 75 20 \
		Y "YES [INSTALL] emulationstation for LMDE" \
		B "BACK")
	if [ "$confMAKEes" == 'Y' ]; then
		tput reset
		cd ~
		# Abort Install if ES Not Found
		if [ ! -d /opt/retropie/supplementary/emulationstation ]; then
			dialog --no-collapse --title "   *EmulationStation NOT FOUND! *  " --ok-label CONTINUE --msgbox "INSTALL EmulationStation FROM RetroPie-Setup 1st! "  25 75
			mainMENU
		fi
		
		#Backup Current ES
		if [ ! -d /opt/retropie/supplementary/emulationstation_bak ]; then sudo mv /opt/retropie/supplementary/emulationstation /opt/retropie/supplementary/emulationstation_bak; fi
		
		# REMOVE Current ES AFTER Backing up
		if [ -d /opt/retropie/supplementary/emulationstation ]; then sudo rm /opt/retropie/supplementary/emulationstation -R -f; fi
		
		# cmake make ES in its Final Installation Directory
		cd /opt/retropie/supplementary/
		sudo git clone --recursive https://github.com/RetroPie/EmulationStation.git
		sudo mv /opt/retropie/supplementary/EmulationStation/ /opt/retropie/supplementary/emulationstation/
		cd /opt/retropie/supplementary/emulationstation/
		sudo cmake .
		sudo make
		cd /opt/retropie/supplementary/
		
		#sudo cp -R /opt/retropie/supplementary/emulationstation_bak/resources /opt/retropie/supplementary/emulationstation/resources
		sudo cp -R /opt/retropie/supplementary/emulationstation_bak/scripts /opt/retropie/supplementary/emulationstation/scripts
		
		cd ~
		dialog --no-collapse --title "   *FINISHED* [INSTALL] emulationstation for LMDE" --ok-label CONTINUE --msgbox "$cmakeREF"  25 75
	fi
	mainMENU
fi
tput reset
exit 0
}

mainMENU
tput reset
exit 0

