#!/bin/bash

#export ARCH=arm
#export CROSS_COMPILE=arm-eabi-4.7/bin/arm-eabi-


BOARD_KERNEL_BASE=0x00000000
BOARD_KERNEL_PAGESIZE=4096
BOARD_KERNEL_TAGS_OFFSET=0x02400000
BOARD_RAMDISK_OFFSET=0x02600000
#BOARD_KERNEL_CMDLINE="console=ttyHSL0,115200,n8 androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x37 ehci-hcd.park=3"
BOARD_KERNEL_CMDLINE="console=null androidboot.hardware=qcom androidboot.selinux=permissive user_debug=31 msm_rtb.filter=0x37 dwc3_msm.cpu_to_affin=1"

mkdir -p out boot_ko
if [ -e ./out/.config ]; then
echo  .config exist, and using it ...
else
echo .config not exist, config it ...
#make apq8084_sec_defconfig VARIANT_DEFCONFIG=apq8084_sec_lentislte_ktt_defconfig DEBUG_DEFCONFIG=apq8084_sec_eng_defconfig SELINUX_DEFCONFIG=selinux_defconfig SELINUX_LOG_DEFCONFIG=selinux_log_defconfig TIMA_DEFCONFIG=tima_defconfig 
make -C . O=out/ apq8084_sec_defconfig VARIANT_DEFCONFIG=stv_defconfig SELINUX_DEFCONFIG=selinux_defconfig  TIMA_DEFCONFIG=tima_defconfig 
fi
make -C . O=out/  -j4
make -C . O=out/ modules  -j4

tools/dtbTool -o dt.img -s $BOARD_KERNEL_PAGESIZE -p out/scripts/dtc/ out/arch/arm/boot/dts/
tools/mkbootimg --kernel out/arch/arm/boot/zImage \
		--ramdisk ramdisk.img \
		--output boot.img \
		--cmdline "$BOARD_KERNEL_CMDLINE" \
		--base $BOARD_KERNEL_BASE \
		--pagesize $BOARD_KERNEL_PAGESIZE \
		--ramdisk_offset $BOARD_RAMDISK_OFFSET \
		--tags_offset $BOARD_KERNEL_TAGS_OFFSET \
		--dt dt.img

printf SEANDROIDENFORCE >> boot.img

find out/ -name *.ko -exec cp {} boot_ko \;
find boot_ko/ -name *.ko -exec arm-eabi-strip --strip-unneeded {} \;
