#strace wpa_supplicant -i <WIFIINTERFACE> -c <(wpa_passphrase <SSID> <PASSPHRASE>) 2>&1 | less # to diagnose problems
# MAKE SURE ANY HW WIRELESS SWS ARE UNBLOCKED
systemctl restart wpa_supplicant.service
systemctl restart dhcpcd.service
wpa_supplicant -B -i wlp3s0 -c <(wpa_passphrase "Voges Upstairs Network" "3142229933") 2
iwlist wlp3s0 scan
parted /dev/sda --script mklabel gpt
sgdisk -og /dev/sda
sgdisk -n 1:0:1G -c 1:"EFI" -t 1:ef02 -g /dev/sda
sgdisk -n 2:0:+20M -c 2:"boot" -t 2:8300 -g /dev/sda
sgdisk -n 3:0:0 -c 3:"LVM" -t 3:8e00 -g /dev/sda
cryptsetup luksFormat /dev/sda3
cryptsetup luksOpen /dev/sda3 enc-pv
pvcreate /dev/mapper/enc-pv
vgcreate vg /dev/mapper/enc-pv
lvcreate -n swap vg -L 8G
lvcreate -n root vg -l 100%FREE
mkfs.vfat -n BOOT /dev/sda2
mkfs.ext4 -L root /dev/vg/root
mkswap -L swap /dev/vg/swap
mount /dev/vg/root /mnt
mkdir /mnt/boot
mount /dev/sda2 /mnt/boot
swapon /dev/vg/swap
#nixos-generate-config --root /mnt
git clone https://github.com/cvoges12/configs
