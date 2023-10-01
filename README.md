# RetroPie-LMDE
 * **NOTE** *  
*The Tweaks Applied by this Script have been 0fficially committed to RetroPie-Setup and are No Longer Needed*.  
*See Here:* *[systems: add support Linux Mint LMDE ](https://github.com/RetroPie/RetroPie-Setup/commit/2d12325a95e293e2a29e7563a9409594fd182a83)*  

![rp-lmde.png](https://raw.githubusercontent.com/RapidEdwin08/RetroPie-LMDE/main/rp-lmde.png )  

Utility Script to assist with installing RetroPie on LMDE.  
*Applies Tweaks to 0vercome Issues during a Basic Install of RetroPie on LMDE due to misidentified OS. (Deprecated)*  
**NOTE:** *Tested with RetroPie-Setup v4.8.2 on LMDE4 (Debbie) + LMDE5 (Elsie).*  

## INSTALLATION
```bash
cd ~
wget https://raw.githubusercontent.com/RapidEdwin08/RetroPie-LMDE/main/rp_lmde.sh -P ~/
sudo chmod 755 ~/rp_lmde.sh
./rp_lmde.sh
```

**Issues with Basic Install of RetroPie-Setup in LMDE:**  
RetroPie-Setup misidentifies LMDE and applies [libpng12-dev] instead of [libpng-dev].  
RetroPie-Setup misidentifies LMDE and attempts to install 0lder EmulationStation Failing make install.  

**Tweaks Applied:**  
 *[[~/RetroPie-Setup/scriptmodules/system.sh](https://github.com/RetroPie/RetroPie-Setup/blob/085235d47904ed24973752f0f770cb653dfb42f0/scriptmodules/system.sh#L231-L245)]:*  
```bash            # Add LMDE
            if [[ "$__os_desc" == LMDE* ]]; then
                if compareVersions "$__os_release" lt 4; then
                    error="You need Linux Mint Debian Edition 4 or newer"
                elif compareVersions "$__os_release" lt 5; then
                    __os_debian_ver="10"
                elif compareVersions "$__os_release" lt 6; then
                    __os_debian_ver="11"
                else
                    __os_debian_ver="12"
                fi
            fi
```

## Sources
https://github.com/RetroPie/RetroPie-Setup  

## License
[GNU](https://www.gnu.org/licenses/gpl-3.0.en.html)  

