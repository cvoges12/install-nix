# install-nix

Start Wireless
--------------


systemctl restart wpa_supplicant.service
systemctl restart dhcpcd.service
wpa_supplicant -B -i wlp3s0 -c <(wpa_passphrase "Voges Upstairs Network" "3142229933") 2
iwlist wlp3s0 scan

Diagnose Wireless
-----------------
strace wpa_supplicant -i <WIFIINTERFACE> -c <(wpa_passphrase <SSID> <PASSPHRASE>) 2>&1 | less
