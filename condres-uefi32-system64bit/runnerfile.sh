#!/usr/bin/env bash
# 
# Copyright (c) 2017 Edgar Merino <emerino at nuevebit dot com>.
# Copyright (c) 2018 Condres OS Linux. <info at codelinsoft dot it>.
# 
# Product adapted for the Condres OS distribution
#
# This program is free software: you can redistribute it and/or modify  
# it under the terms of the GNU Lesser General Public License as published by  
# the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful, but 
# WITHOUT ANY WARRANTY; without even the implied warranty of 
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU 
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License 
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#
#
# Tasks for generating a bootable EFI32 Condres OS x64 ISO image.

cd `dirname ${0}`
source node_modules/bash-task-runner/src/runner.sh

# This should point to the original Condres ISO downloaded.
iso_file="src/iso/condres_os-19.07-xfce.iso"
filename=$(basename "$iso_file")
filename="${filename%.*}"

isolinux_bin_file="/usr/lib/syslinux/bios/isolinux.bin"

# Default is to clean, build and generate ISO image under target folder.
task_default() {
    runner_sequence clean build dist;
}

# Unpack the original ISO image.
task_unpack() {
    if [ ! -f "$iso_file" ]; then
        runner_log_error "ISO file not found";
        exit 1;
    fi

    runner_log "Unpacking ISO image";

    if [ ! -d "src/iso/$filename" ]; then
        mkdir -p "src/iso/$filename"; 
    fi

    runner_run bsdtar \
        -x \
        -f "$iso_file" \
        -C "src/iso/$filename";

    runner_log "ISO image unpacked";
}

# Generate the GRUB EFI32 Bootloader.
task_efi32loader() {
    runner_log "Creating GRUB standalone EFI 32 bootloader";
    check_target_dir;

    runner_run grub-mkstandalone \
        -d /usr/lib/grub/i386-pc/ \
        -O i386-multiboot \
        --modules="part_gpt part_msdos" \
        --fonts="unicode" \
        --themes="" \
        -o "target/bootia32.efi" \
        "boot/grub/grub.cfg=src/grub.cfg";

    runner_log "GRUB standalone EFI 32 bootloader created";
}

# Gather final files, those that'll be used to generate the ISO image.
task_build() {
    runner_log "Building ISO contents";

    if [ ! -d "src/iso/$filename" ]; then
        runner_sequence unpack;
    fi

    runner_sequence efi32loader;

    check_target_dir;

    # copy source iso files to target folder
    runner_run cp -r "src/iso/$filename" "target/iso";

    # copy efi32 bootloader
    runner_run cp "target/bootia32.efi" "target/iso/EFI/boot/";

    # TODO: According to this 
    # https://wiki.archlinux.org/index.php/Remastering_the_Install_ISO
    # isolinux.bin should always be the same version as the one used to 
    # generate the ISO... is this really needed? maybe we've got it wrong.
    runner_run cp "$isolinux_bin_file" target/iso/isolinux/

    # the efiboot.img disk image needs to be updated, the bootia32.efi binary
    # needs to be included
    runner_run mcopy \
        -D o \
        -i target/iso/EFI/archiso/efiboot.img \
        target/bootia32.efi ::EFI/boot/bootia32.efi

    runner_log "ISO contents ready";
}

# Generate ISO image file
task_dist() {
    check_target_dir;

    runner_run xorriso -as mkisofs \
        -iso-level 3 \
        -full-iso9660-filenames \
        -volid "Condres" \
        -eltorito-boot isolinux/isolinux.bin \
        -eltorito-catalog isolinux/boot.cat \
        -no-emul-boot \
        -boot-load-size 4 \
        -boot-info-table \
        -isohybrid-mbr target/iso/isolinux/isohdpfx.bin \
        -eltorito-alt-boot \
        -e EFI/archiso/efiboot.img \
        -no-emul-boot \
        -isohybrid-gpt-basdat \
        -output target/condres_os-19.07-efi32-system64.iso \
        target/iso
}

task_clean() {
    if [ -d target ]; then
        runner_run rm -rf target;
    fi
}

check_target_dir() {
    if [ ! -d "target" ]; then
        mkdir target;
    fi
}
