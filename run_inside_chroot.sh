#!/bin/bash
SOFT_PACK2=$1
MY_UID="1000"
MY_TIMEZONE="Europe/Istanbul"
MY_LOCALE="en_US.UTF-8"

HOSTNAME="mining_randomx"
EFI_SYS_NAME="arch_xmr"

MONERO_CHAIN_IN_EXTRA_DRIVE_PATH="/mega/data/chains/mnr/"

# Установка часового пояса
ln -sf /usr/share/zoneinfo/$MY_TIMEZONE /etc/localtime
hwclock --systohc


# Установка языка и локали
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=$MY_LOCALE" >> /etc/locale.conf

echo "FONT=cyr-sun16" >> /etc/vconsole.conf
echo "KEYMAP=us" >> /etc/vconsole.conf

#добавляем русскую раскладку для текстового режима
echo "KEYMAP=ruwin_alt_sh-UTF-8" >> /etc/vconsole.conf
#команда ниже не будет работать без systemd:
#localectl set-keymap --no-convert ruwin_alt_sh-UTF-8


# Настройка hostname
echo $HOSTNAME > /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1 localhost" >> /etc/hosts
echo "127.0.1.1 $HOSTNAME.localdomain $HOSTNAME" >> /etc/hosts

# Установка пароля root
# раскоментировать для установки пароля root
#echo "Введите пароль для пользователя root:"
#passwd

# Запрос имени нового пользователя
echo "Введите имя нового пользователя (например, user):"
read USERNAME

# Создание нового пользователя с UID и GID равными 1000 (или тем, что указано в начале файла)
groupadd -g $MY_UID $USERNAME
useradd -m -u $MY_UID -g $MY_UID -G users,wheel,storage,power -s /bin/bash $USERNAME


# Установка пароля для нового пользователя
echo "Введите пароль для пользователя $USERNAME:"
passwd $USERNAME

#установка дополнительного софта
pacman -Syu
pacman -S sudo coreutils sed --noconfirm
for package in $SOFT_PACK2; do
    sudo pacman -S $package --noconfirm
done


# Разрешение sudo для пользователя
#sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers


# Добавление пользователя в файл sudoers

mkdir -p /etc/sudoers.d
echo '#you can add rules here' > /etc/sudoers.d/rules-autogenerated
chmod 440 /etc/sudoers.d/rules-autogenerated
echo "#$USERNAME ALL=(ALL) ALL" | EDITOR='tee -a' visudo -f /etc/sudoers.d/rules-autogenerated
echo "#$USERNAME ALL=(ALL) NOPASSWD: ALL" | EDITOR='tee -a' visudo -f /etc/sudoers.d/rules-autogenerated
echo '#%wheel ALL=(ALL:ALL) ALL' | EDITOR='tee -a' visudo -f /etc/sudoers.d/rules-autogenerated
echo '#%wheel ALL=(ALL:ALL) NOPASSWD: ALL' | EDITOR='tee -a' visudo -f /etc/sudoers.d/rules-autogenerated
echo '#%sudo ALL=(ALL:ALL) ALL' | EDITOR='tee -a' visudo -f /etc/sudoers.d/rules-autogenerated
echo '#%wheel ALL=(ALL:ALL) ALL' | EDITOR='tee -a' visudo -f /etc/sudoers.d/rules-autogenerated

EDITOR="sed -i 's/^#%wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL'" visudo -f /etc/sudoers.d/rules-autogenerated



# Настройка mkinitcpio для поддержки LVM и шифрования
#sed -i 's/^HOOKS=(.*)/HOOKS=(base udev autodetect modconf block btrfs lvm2 keyboard encrypt filesystems fsck)/' /etc/mkinitcpio.conf
sed -i 's/^HOOKS=(.*)/HOOKS=(base udev autodetect microcode modconf kms keymap consolefont block btrfs lvm2 keyboard encrypt filesystems fsck)/' /etc/mkinitcpio.conf
#sed -i 's/^HOOKS=(.*)/HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block lvm2 encrypt filesystems fsck)/' /etc/mkinitcpio.conf
mkinitcpio -P



# Установка загрузчика
#если grub уже установлен другой системой
#при желании можно просто устоновить пакеты
#если они не были прописаны в $SOFT_PACK2
pacman -S grub efibootmgr  --noconfirm
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=$EFI_SYS_NAME
grub-mkconfig -o /boot/grub/grub.cfg

#don't forget about update-grub ( grub-mkconfig -o /boot/grub/grub.cfg ) in the main linux system 


#---------------------------------------------------------------
#тут будет ОПЦИОНАЛЬНЫЙ БЛОК
echo "настройка автозапуска NetworkManager для работа интернета"
#rc-update add networkmanager boot
#systemctl enable NetworkManager # такую команду нужно использовать в пост установочном скрипте
#dinitctl enable NetworkManager

ln -s /usr/lib/systemd/system/NetworkManager.service /etc/systemd/system/multi-user.target.wants/NetworkManager.service

#------------------------------------------------------------------------------------

#TODO:
#прикручиваем каталог с блокчейном monero
mkdir /home/$USERNAME/.bitmonero
echo "data-dir=/mnt/extra1$MONERO_CHAIN_IN_EXTRA_DRIVE_PATH" > /home/$USERNAME/.bitmonero/bitmonero.conf

#копируем tar-архив в домашнюю папку пользователя и распаковываем его
tar -xzf /homefiles.tar.gz -C /home/$USERNAME
rm /homefiles.tar.gz

# Выход из chroot
exit

