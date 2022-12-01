# RetroPie-LMDE
![rp-lmde.png](https://raw.githubusercontent.com/RapidEdwin08/RetroPie-LMDE/main/rp-lmde.png )  

Utility Script to assist with installing RetroPie on LMDE.  
Applies Tweaks to 0vercome Issues during a Basic Install of RetroPie on LMDE due to misidentified OS.  
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
                if compareVersions "$__os_release" lt 5; then
                    __os_debian_ver=10
                else
                    __os_debian_ver=11
                fi
            fi
```

## Sources
https://github.com/RetroPie/RetroPie-Setup  

## License
[GNU](https://www.gnu.org/licenses/gpl-3.0.en.html)  

