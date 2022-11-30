# RetroPie-LMDE
![rp-lmde.png](https://raw.githubusercontent.com/RapidEdwin08/RetroPie-LMDE/main/rp-lmde.png )  

Utility Script to assist with installing RetroPie on LMDE.  
Applies Tweaks to 0vercome Issues during a Basic Install of RetroPie on LMDE.  
**NOTE:** *Successfully Tested on LMDE4 (Debbie) + LMDE5 (Elsie).*  

## INSTALLATION
```bash
cd ~
wget https://raw.githubusercontent.com/RapidEdwin08/RetroPie-LMDE/main/rp_lmde.sh -P ~/
sudo chmod 755 ~/rp_lmde.sh
./rp_lmde.sh
```

**Issues with Basic Install of RetroPie-Setup in LMDE:**  
RetroPie-Setup identifies LMDE as a Debian derivative less than 9 and applies [libpng12-dev] instead of [libpng-dev].  
EmulationStation Fails to make install due to what appears to be missing Boost libraries [libboost-date-time-dev].

**Tweaks Applied:**  
*[~/RetroPie-Setup/scriptmodules/helpers.sh]*:  
compareVersions "$__os_debian_ver" lt 9 && pkg="libpng-dev" #LMDE

*[~/RetroPie-Setup/scriptmodules/supplementary/emulationstation.sh]*:  
rp_module_repo="git https://github.com/RetroPie/EmulationStation.git"  
rp_module_licence="https://raw.githubusercontent.com/RetroPie/EmulationStation/master/LICENSE.md"  

***Issue: ERROR POST Basic Install of RetroPie-Setup with Tweaks Applied:***  
emulationstation: ~/RetroPie-Setup/tmp/build/emulationstation/es-core/src/resources/Font.cpp:21:  
Font::FontFace::FontFace(ResourceData&&, int): Assertion `!err' failed.  
Aborted (core dumped)  

EmulationStation is Referencing the Temp Build Location of RetroPie-Setup that no longer exists.  
Workaround is to Make emulationstation in the Default Install Location [/opt/retropie/supplementary/].  
***Use the Script to make emulationstation again following a Basic Install of RetroPie-Setup.***  

*Alternatively If you already Built ~/EmulationStation you can simply create a Symbolic Link to it instead.  
```bash
sudo ln -s ~/EmulationStation/emulationstation /opt/retropie/supplementary/emulationstation/emulationstation
```

## Sources
https://github.com/RetroPie/RetroPie-Setup  
https://github.com/RetroPie/EmulationStation  

## License
[GNU](https://www.gnu.org/licenses/gpl-3.0.en.html)  

