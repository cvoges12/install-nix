encrypt_part(){
  FS = $1
  PV = $2
  cryptsetup luksFormat $FS
  cryptsetup luksOpen $FS $PV
}
format_disk(){
  FS = $1
  TABLE = $2
  parted $FS --script mklabel $TABLE
  sgdisk -og $FS
  sgdisk -n 1:0:1G -c 1:"EFI" -t 1:ef02 -g $FS
  sgdisk -n 2:0:+20M -c 2:"boot" -t 2:8300 -g $FS
  sgdisk -n 3:0:0 -c 3:"LVM" -t 3:8e00 -g $FS
}
lvm(){
  PV = $1
  VG = $2
  pvcreate $PV
  vgcreate $VG $PV
  lvcreate -n swap $VG -L 8G
  lvcreate -n root $VG -l 100%FREE
}
filesystem(){
  mkfs.vfat -n BOOT /dev/sda2
  mkfs.ext4 -L root /dev/vg/root
  mkswap -L swap /dev/vg/swap
  mount /dev/vg/root /mnt
  mkdir /mnt/boot
  mount /dev/sda2 /mnt/boot
  swapon /dev/vg/swap
}

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
