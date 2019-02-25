#!/bin/bash

#Archiso Stuff
set -e -u
umask 022
sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
usermod -s /usr/bin/zsh root
cp -aT /etc/skel/ /root/
chmod 700 /root
chown -R root /etc/sudoers.d
chmod -R 755 /etc/sudoers.d
chmod -R 755 /etc/sudoers

#Create Liveuser
id -u liveuser &>/dev/null || useradd -m "liveuser" -g users -G "adm,audio,floppy,log,network,rfkill,scanner,storage,optical,power,wheel"
passwd -d liveuser
#rm /home/liveuser/.config/autostart/firstrun.desktop
echo 'Created User'

# Setup Pacman
 pacman-key --init archlinux
 pacman-key --populate archlinux
 pacman-key --init
 pacman-key --init condres
 pacman-key --populate condres
 pacman-key --populate
 #pacman -Syy
 #pacman-key --refresh-keys

#Edit Mirrorlist
	sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
	sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

#Load freezedry configuration
sudo -u liveuser freezedry --load /etc/freezedry/default.toml --livecd || /bin/true
OSNAME="Condres OS GNU/Linux"
#Name Condres

osReleasePath='/usr/lib/os-release'
rm -rf $osReleasePath
touch $osReleasePath
echo 'NAME="'${OSNAME}'"' >> $osReleasePath
echo 'ID=condres_os' >> $osReleasePath
echo 'PRETTY_NAME="'${OSNAME}'"' >> $osReleasePath
echo 'ANSI_COLOR="0;35"' >> $osReleasePath
echo 'HOME_URL="www.codelinsoft.it/sito"' >> $osReleasePath
echo 'SUPPORT_URL="www.codelinsoft.it/sito/forum.html"' >> $osReleasePath
echo 'BUG_REPORT_URL="www.codelinsoft.it/sito/forum.html"' >> $osReleasePath

    arch=`uname -m`




#Run Architecture-Specific Tasks
arch=`uname -m`
if [ "$arch" == "x86_64" ]
then
sed -i 's@Icon=/usr/share/hplip/data/images/128x128/hp_logo.png@Icon=hplip@' /usr/share/applications/hplip.desktop || /bin/true
	cp -f /etc/condres-assets/playonlinux.png /usr/share/playonlinux/etc || /bin/true
	cp -f /etc/condres-assets/playonlinux15.png /usr/share/playonlinux/etc || /bin/true
	cp -f /etc/condres-assets/playonlinux16.png /usr/share/playonlinux/etc || /bin/true
	cp -f /etc/condres-assets/playonlinux22.png /usr/share/playonlinux/etc || /bin/true
	cp -f /etc/condres-assets/playonlinux32.png /usr/share/playonlinux/etc || /bin/true
	rm -f /root/install.txt
	echo "$(cat /etc/mkinitcpio.conf)"
#Enable Calamares Autostart
	mkdir -p /home/liveuser/.config/autostart
	mkdir -p /home/liveuser/Desktop
	chown liveuser:users /home/liveuser/Desktop/
	chmod 777 -R /home/liveuser/Desktop/
	ln -fs /usr/share/applications/welcome.desktop /home/liveuser/.config/autostart/welcome.desktop
#Set Nano Editor
	export _BROWSER=google-chrome-stable
    echo "BROWSER=/usr/bin/${_BROWSER}" >> /etc/environment
    echo "BROWSER=/usr/bin/${_BROWSER}" >> /etc/profile
	export _EDITOR=nano
	echo "EDITOR=${_EDITOR}" >> /etc/environment
	echo "EDITOR=${_EDITOR}" >> /etc/skel/.bashrc
	echo "EDITOR=${_EDITOR}" >> /etc/profile
#Enable Sudo
	chmod 750 /etc/sudoers.d
	chmod 440 /etc/sudoers.d/g_wheel
	chown -R root /etc/sudoers.d
	echo "Enabled Sudo"
#Set Apricity Grub Theme
	/etc/condres-assets/Elegant_Dark/install.sh || /bin/true
#Enable Apricity Plymouth Theme
	#sed -i.bak 's/base udev/base udev plymouth/g' /etc/mkinitcpio.conf
	#chown -R root.root /usr/share/plymouth/themes/condres
	plymouth-set-default-theme -R condres
	mkinitcpio -p linux
	grub-mkconfig -o /boot/grub/grub.cfg
	chsh -s /bin/zsh || /bin/true
#Setup Su
    sed -i /etc/pam.d/su -e 's/auth      sufficient  pam_wheel.so trust use_uid/#auth        sufficient  pam_wheel.so trust use_uid/'
#Try to do sudo again
    chmod -R 755 /etc/sudoers.d
else
	echo "i686"
sed -i 's@Icon=/usr/share/hplip/data/images/128x128/hp_logo.png@Icon=hplip@' /usr/share/applications/hplip.desktop || /bin/true
	cp -f /etc/condres-assets/playonlinux.png /usr/share/playonlinux/etc || /bin/true
	cp -f /etc/condres-assets/playonlinux15.png /usr/share/playonlinux/etc || /bin/true
	cp -f /etc/condres-assets/playonlinux16.png /usr/share/playonlinux/etc || /bin/true
	cp -f /etc/condres-assets/playonlinux22.png /usr/share/playonlinux/etc || /bin/true
	cp -f /etc/condres-assets/playonlinux32.png /usr/share/playonlinux/etc || /bin/true
	rm -f /root/install.txt
	echo "$(cat /etc/mkinitcpio.conf)"
#Enable Calamares Autostart
	mkdir -p /home/liveuser/.config/autostart
	ln -fs /usr/share/applications/welcome.desktop /home/liveuser/.config/autostart/welcome.desktop
#Set Nano Editor
	export _BROWSER=google-chrome-stable
    echo "BROWSER=/usr/bin/${_BROWSER}" >> /etc/environment
    echo "BROWSER=/usr/bin/${_BROWSER}" >> /etc/profile
	export _EDITOR=nano
	echo "EDITOR=${_EDITOR}" >> /etc/environment
	echo "EDITOR=${_EDITOR}" >> /etc/skel/.bashrc
	echo "EDITOR=${_EDITOR}" >> /etc/profile
#Enable Sudo
	chmod 750 /etc/sudoers.d
	chmod 440 /etc/sudoers.d/g_wheel
	chown -R root /etc/sudoers.d
	echo "Enabled Sudo"
#Set Apricity Grub Theme
	/etc/condres-assets/Elegant_Dark/install.sh || /bin/true
#Enable Apricity Plymouth Theme
	#sed -i.bak 's/base udev/base udev plymouth/g' /etc/mkinitcpio.conf
	#chown -R root.root /usr/share/plymouth/themes/condres
	plymouth-set-default-theme -R condres
	mkinitcpio -p linux
	grub-mkconfig -o /boot/grub/grub.cfg
	chsh -s /bin/zsh || /bin/true
#Setup Su
 #   sed -i /etc/pam.d/su -e 's/auth      sufficient  pam_wheel.so trust use_uid/#auth        sufficient  pam_wheel.so trust use_uid/'
   # systemctl enable pacman-init.service lightdm.service choose-mirror.service
   systemctl disable gdm.service    
   systemctl enable sddm-plymouth.service
   systemctl enable --now macbook-wakeup.service
   # systemctl enable avahi-daemon.service
   # systemctl enable vboxservice.service
   # systemctl enable haveged
   # systemctl enable systemd-networkd.service
   # systemctl enable systemd-resolved.service
   # systemctl -fq enable NetworkManager
   # systemctl enable reflector.service
   # systemctl mask systemd-rfkill@.service
   # systemctl set-default graphical.target
#Try to do sudo again
    chmod -R 755 /etc/sudoers.d
fi
