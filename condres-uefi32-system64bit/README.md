# condres-efi32 ISO builder

This project allows for the creation of a bootable EFI-32 Condres OS x64 ISO
image. 

Our distro now supports 32-bit boot on 64-bit systems. Tablets or 2 in 1 are supported. The iso image that is supported is with desktop xfce, as light and fast and suitable for everyone's needs.


First of all, open the file 
    
    runner.sh 

and modify line 24 

    iso_file="src/iso/condres_os-18.09-xfce.iso"

specifying where is the iso image of condres that you want to adapt with efi32 on 64-bit systems.

# Dependencies

* NPM: Needed to download the [bash-task-runner](https://github.com/stylemistake/bash-task-runner).
* GRUB 2 (i386-efi): Creates the EFI 32 bootloader.
* bsdtar: Used to unpack the ISO image.
* cdrtools: Used to generate de ISO image.
* libisoburn: Needed to create bootable USB images (xorriso).
* mtools: For mcopy command, needed to modify image disk files (.img) without mounting.

# Getting started

*For all of the following commands to work, you need to change to the root folder
of the project.*

*For now, you need to manually download an Condres ISO file, and modify the
iso_file variable in the runnerfile.sh script to point to it. In a future
release, this will be automated too.*

To build a new ISO, you'll need to first install the bash-task-runner:
    
    cd condres-uefi32-system64bit

    npm install bash-task-runner

Then, you can simply call the runnerfile.sh script to generate the ISO:

    ./runnerfile.sh 

There are other tasks available, you can first unpack the ISO 
(to include modules, for instance), and then repackage it:

    ./runnerfile.sh unpack
    # modify ISO contents as needed
    ./runnerfile.sh 

# create ISO usb
Use etcher. 

  pacman -S etcher
  
# Screenshoot

![Etcher](https://etcher.io/static/screenshot.gif)
