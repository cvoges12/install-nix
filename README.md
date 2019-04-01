Install NixOS
=============

Features
--------
- Formats single disk with GPT
- Encrypts partition with LUKs
- Creates arbitrarily sized root LVM volume
- Creates 8 GB swap LVM volume
- Formats filesystems
- Mounts root and boot partition
- Turns swap on

ToDo
----
- Haskell Translation
- Replace `nix-generate-config` with `curl` and `mv`
- Add `nixos-install` when operational
- MBR alternative
- Arbitrary swap size based on RAM size
- Format arbitrary amount of disks
- Offer parity LVM option

Start Wireless
--------------
```
systemctl restart wpa_supplicant.service
systemctl restart dhcpcd.service
wpa_supplicant -B -i wlp3s0 -c <(wpa_passphrase "<SSID>" "<PASSPHRASE>") 2
iwlist wlp3s0 scan
```

Diagnose Wireless
-----------------
`strace wpa_supplicant -i <WIFIINTERFACE> -c <(wpa_passphrase <SSID> <PASSPHRASE>) 2>&1 | less`

Curl
----
install.sh - https://0x0.st/zP4M.sh
