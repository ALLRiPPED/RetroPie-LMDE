#!/bin/bash

esbREF=$(
echo ''
echo "Current Linux Standard Base:"
echo " $(lsb_release -sidrc)"
echo ''
)

prereqsREF=$(
echo '

sudo apt-get install libpng-dev libboost-date-time-dev git dialog unzip xmlstarlet libsdl2-dev libfreeimage-dev libfreetype6-dev libcurl4-openssl-dev rapidjson-dev libasound2-dev libgles2-mesa-dev build-essential cmake libvlc-dev libvlccore-dev vlc-bin fonts-droid-fallback flex bison libglew-dev libsamplerate0-dev libspeexdsp-dev libboost-filesystem-dev nasm

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


[~/RetroPie-Setup/scriptmodules/system.sh]:

            # Add LMDE
            if [[ "$__os_desc" == LMDE* ]]; then
                if compareVersions "$__os_release" lt 5; then
                    __os_debian_ver=10
                else
                    __os_debian_ver=11
                fi
            fi

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
	3 " [TWEAK] System Identifier Script in [RetroPie-Setup]" \
	4 " [OPEN] [RetroPie-Setup]" )
	
if [ "$installESBflag" == '1' ]; then
	confPREreqs=$(dialog --stdout --no-collapse --title " INSTALL Prequisites for RetroPie and EmulationStation" \
		--ok-label OK --cancel-label Back \
		--menu "                          ? ARE YOU SURE ?                            $prereqsREF" 25 75 20 \
		Y "YES [INSTALL]  Prequisites for RetroPie and ES" \
		B "BACK")
	if [ "$confPREreqs" == 'Y' ]; then
		tput reset
		# Debian Bullseye RetroPie + ES PreReqs
		sudo apt-get install -y git dialog unzip xmlstarlet libboost-date-time-dev
		sudo apt-get install -y libsdl2-dev libfreeimage-dev libfreetype6-dev libcurl4-openssl-dev rapidjson-dev libasound2-dev libgles2-mesa-dev build-essential cmake libvlc-dev libvlccore-dev vlc-bin fonts-droid-fallback
		sudo apt-get install -y flex bison libglew-dev nasm
		sudo apt-get install -y libsamplerate0-dev libspeexdsp-dev libpng-dev libboost-filesystem-dev #libpng12-dev Depricated #libpng-dev
		
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
		if [ -d /home/$USER/RetroPie-Setup ]; then
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
	confRPEStweaks=$(dialog --stdout --no-collapse --title " [TWEAK] System Identifier Script in [RetroPie-Setup]" \
		--ok-label OK --cancel-label Back \
		--menu "                          ? ARE YOU SURE ?                            $tweaksREF" 25 75 20 \
		Y "YES [TWEAK] System Identifier Script in [RetroPie-Setup]" \
		B "BACK")
	if [ "$confRPEStweaks" == 'Y' ]; then
		tput reset
		# Abort if LMDE Not Found
		#if [ "$(lsb_release -sidrc | grep LMDE)" == '' ]; then
			#dialog --no-collapse --title "LMDE NOT FOUND!" --ok-label CONTINUE --msgbox "THIS UTILITY SCRIPT IS FOR LMDE ONLY! \n \n Current Linux Standard Base: \n $(lsb_release -sidrc)"  25 75
			#mainMENU
		#fi
		
		# Abort if ES/Helper Scripts Not Found
		if [ ! -f ~/RetroPie-Setup/scriptmodules/system.sh ]; then
			dialog --no-collapse --title "~/RetroPie-Setup/scriptmodules/system.sh NOT FOUND!" --ok-label CONTINUE --msgbox "DOWNLOAD RetroPie-Setup 1st! "  25 75
			mainMENU
		fi
		
		# Debian Bullseye UPDATES to [~/RetroPie-Setup/scriptmodules/helpers.sh]
		if [ ! -f ~/RetroPie-Setup/scriptmodules/system.sh.bak ]; then cp ~/RetroPie-Setup/scriptmodules/system.sh ~/RetroPie-Setup/scriptmodules/system.sh.bak; fi
		
		# Apply Updates for RetroPie 4.7.1 (202203) If Needed
		wget https://raw.githubusercontent.com/RapidEdwin08/RetroPie-LMDE/main/lmde_rpsetup.diff -P /dev/shm
		mv /dev/shm/lmde_rpsetup.diff ~/RetroPie-Setup/scriptmodules/
		cd ~/RetroPie-Setup/scriptmodules/
		git apply "/home/$USER/RetroPie-Setup/scriptmodules/lmde_rpsetup.diff"
		cd ~
		dialog --no-collapse --title "   *FINISHED* [TWEAK] ES Install Script in [RetroPie-Setup] " --ok-label CONTINUE --msgbox "$(cat ~/RetroPie-Setup/scriptmodules/system.sh | tail -n +231 | head -23)"  25 75
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
		# Abort if RetroPie-Setup Scripts Not Found
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

tput reset
exit 0
}

# Alert if LMDE Not Found
if [ "$(lsb_release -sidrc | grep LMDE)" == '' ]; then
	dialog --no-collapse --title "LMDE NOT FOUND!" --ok-label CONTINUE --msgbox "THIS UTILITY SCRIPT IS FOR LMDE ONLY! \n \n Current Linux Standard Base: \n $(lsb_release -sidrc) \n \n *CONTINUE AT YOUR OWN RISK*"  25 75
fi
		
mainMENU
tput reset
exit 0

