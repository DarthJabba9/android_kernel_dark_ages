#!/bin/bash

# Copyright (C) Abubakar Yagob (abubakaryagob@gmail.com)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#Colors
black='\033[0;30m'
red='\033[0;31m'
green='\033[0;32m'
brown='\033[0;33m'
blue='\033[0;34m'
purple='\033[1;35m'
cyan='\033[0;36m'
nc='\033[0m'

#Directories
KERNEL_DIR=$PWD
KERN_IMG=$KERNEL_DIR/out/arch/arm64/boot/Image.gz
DTB=$KERNEL_DIR/out/arch/arm64/boot/dts/qcom/msm8953-qrd-sku3-e7-non-treble.dtb
DTB_T=$KERNEL_DIR/out/arch/arm64/boot/dts/qcom/msm8953-qrd-sku3-e7-treble.dtb
ZIP_DIR=$KERNEL_DIR/Zipper
CONFIG_DIR=$KERNEL_DIR/arch/arm64/configs


#clang
export CLANG_COMPILE=true
export CLANG_TRIPLE=aarch64-linux-gnu-

#Exports
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER="Blacksuan19"
export KBUILD_BUILD_HOST="Dark-Castle"

#Misc
CONFIG=vince_defconfig
THREAD="-j16"

# Here We Go
echo -e "$cyan---------------------------------------------------------------------";
echo -e "---------------------------------------------------------------------\n";
echo -e "██████╗--█████╗-██████╗-██╗--██╗-----█████╗--██████╗-███████╗███████╗";
echo -e "██╔══██╗██╔══██╗██╔══██╗██║-██╔╝----██╔══██╗██╔════╝-██╔════╝██╔════╝";
echo -e "██║--██║███████║██████╔╝█████╔╝-----███████║██║--███╗█████╗--███████╗";
echo -e "██║--██║██╔══██║██╔══██╗██╔═██╗-----██╔══██║██║---██║██╔══╝--╚════██║";
echo -e "██████╔╝██║--██║██║--██║██║--██╗----██║--██║╚██████╔╝███████╗███████║";
echo -e "╚═════╝-╚═╝--╚═╝╚═╝--╚═╝╚═╝--╚═╝----╚═╝--╚═╝-╚═════╝-╚══════╝╚══════╝\n";
echo -e "---------------------------------------------------------------------";
echo -e "---------------------------------------------------------------------";
#Main script
while true; do
echo -e "\n$green[1] Build Kernel"
echo -e "[2] Regenerate defconfig"
echo -e "[3] Source cleanup"
echo -e "[4] Create flashable zip"
echo -e "[5] Upload Created Zip File"
echo -e "$red[6] Quit$nc"
echo -ne "\n$brown(i) Please enter a choice[1-6]:$nc "

read choice

if [ "$choice" == "1" ]; then

echo -e "\n$green[1] Stock GCC"
echo -e "[2] Stock Clang"
echo -e "[3] Custom Toolchain"
echo -ne "\n$brown(i) Select Toolchain[1-4]:$nc "
read TC

  if [[ "$TC" == "1" ]]; then
  echo -e "\n$blue building with stock GCC..."
  export CROSS_COMPILE="$PWD/toolchains/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-"
  make  O=out $CONFIG $THREAD &>/dev/null
  make  O=out $THREAD &>Buildlog.txt & pid=$!   
  fi

if [[ "$TC" == "2" ]]; then
  echo -e "\n$blue building with stock Clang..."
  export CLANG_PATH="$PWD/toolchains/linux-x86/clang-4053586"
  export PATH=${CLANG_PATH}:${PATH}
  make O=out $CONFIG $THREAD &>/dev/null  \
               CC="$PWD/toolchains/linux-x86/clang-4053586/bin/clang"  \
               CROSS_COMPILE="$PWD/toolchains/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-" 
  make O=out $THREAD &>Buildlog.txt & pid=$! \
               CC="$PWD/toolchains/linux-x86/clang-4053586/bin/clang"  \
               CROSS_COMPILE="$PWD/toolchains/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-" 
  fi

if [[ "$TC" == "3" ]]; then
echo -e "\n$green[1] GCC 8.1"
echo -e "[2] GCC 7.x"
echo -e "[3] Linaro 7.x"
echo -e "[4] DragonTC 7.0"
echo -ne "\n$brown(i) Select Custom Toolchain[1-4]:$nc "
read customTC
if [[ "$customTC" == "1" ]]; then
  cd toolchains/Toolchains
  git checkout opt-gnu-8.x &>/dev/null 
  cd - &>/dev/null
  echo -e "\n$blue building with custom GCC 8.x..."
  export CROSS_COMPILE="$PWD/toolchains/Toolchains/bin/aarch64-opt-linux-android-"
  make  O=out $CONFIG $THREAD &>/dev/null
  make  O=out $THREAD &>Buildlog.txt & pid=$!   
fi

if [[ "$customTC" == "2" ]]; then
  cd toolchains/Toolchains
  git checkout opt-gnu-7.x &>/dev/null
  cd - &>/dev/null
  echo -e "\n$blue building with custom GCC 7.x..."
  export CROSS_COMPILE="$PWD/toolchains/Toolchains/bin/aarch64-opt-linux-android-"
  make  O=out $CONFIG $THREAD &>/dev/null
  make  O=out $THREAD &>Buildlog.txt & pid=$!   
fi

if [[ "$customTC" == "3" ]]; then
  cd toolchains/Toolchains
  git checkout opt-linaro-7.x cd - &>/dev/null
  cd - cd - &>/dev/null
  echo -e "\n$blue building with custom linaro 7.x..."
  export CROSS_COMPILE="$PWD/toolchains/Toolchains/bin/aarch64-opt-linux-android-"
  make  O=out $CONFIG $THREAD &>/dev/null
  make  O=out $THREAD &>Buildlog.txt & pid=$!   
fi

if [[ "$customTC" == "4" ]]; then
  cd toolchains/Toolchains 
  git checkout dragonTC-7.0 &>/dev/null
  cd - &>/dev/null
  echo -e "\n$blue building with custom Clang Dragon TC..."
  export CLANG_PATH="$PWD/toolchains/Toolchains"
  export PATH=${CLANG_PATH}:${PATH}
  make O=out $CONFIG $THREAD &>/dev/null \
  CC="$PWD/toolchains/Toolchains/bin/clang" 
  make CC="$PWD/toolchains/toolchains/bin/clang" O=out $THREAD &>Buildlog.txt & pid=$! 
fi
fi

BUILD_START=$(date +"%s")
DATE=`date`
echo -e "\n$cyan#######################################################################$nc"
echo -e "$brown(i) Build started at $DATE$nc"
  spin[0]="$blue-"
  spin[1]="\\"
  spin[2]="|"
  spin[3]="/$nc"
  echo -ne "\n$blue[Please wait...] ${spin[0]}$nc"
  while kill -0 $pid &>/dev/null
  do
    for i in "${spin[@]}"
    do
          echo -ne "\b$i"
          sleep 0.1
    done
  done

  if ! [ -a $KERNEL_IMG ]; then
    echo -e "\n$red(!) Kernel compilation failed, See buildlog to fix errors $nc"
    echo -e "$red#######################################################################$nc"
    git checkout darky &>/dev/null  
    exit 1
  fi
  $DTBTOOL -2 -o $KERNEL_DIR/arch/arm/boot/dt.img -s 2048 -p $KERNEL_DIR/scripts/dtc/ $KERNEL_DIR/arch/arm/boot/dts/ &>/dev/null &>/dev/null

  BUILD_END=$(date +"%s")
  DIFF=$(($BUILD_END - $BUILD_START))
  echo -e "\n$brown(i)Image-dtb compiled successfully.$nc"
  echo -e "$cyan#######################################################################$nc"
  echo -e "$purple(i) Total time elapsed: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nc"
  echo -e "$cyan#######################################################################$nc"
  git checkout darky &>/dev/null  
fi

if [ "$choice" == "2" ]; then
  echo -e "\n$cyan#######################################################################$nc"
  make O=out  $CONFIG
  cp .config arch/arm64/configs/$CONFIG
  echo -e "$purple(i) Defconfig generated.$nc"
  echo -e "$cyan#######################################################################$nc"
fi

if [ "$choice" == "3" ]; then
  echo -e "\n$cyan#######################################################################$nc"
  rm -f $DT_IMG
  make O=out clean &>/dev/null
  make mrproper &>/dev/null
  rm -rf out/*
  echo -e "$purple(i) Kernel source cleaned up.$nc"
  echo -e "$cyan#######################################################################$nc"
fi


if [ "$choice" == "4" ]; then
  echo -e "\n$cyan#######################################################################$nc"
  cd $ZIP_DIR
  make clean &>/dev/null
  cp $KERNEL_IMG $ZIP_DIR/kernel/Image.gz
  cp $DTB_T $ZIP_DIR/kernel/treble/msm8953-qrd-sku3-e7-treble.dtb
  cp $DTB $ZIP_DIR/kernel/normal/msm8953-qrd-sku3-e7-non-treble.dtb
  if [[ "$TC" == "1" ||  "$customTC" == "1" || "$customTC" == "2" || "$customTC" == "3" ]]; then
    make normal &>/dev/null
  fi
  if [[ "$TC" == "2" || "$customTC" == "4" ]]; then
    make nclang &>/dev/null
  fi
  cd ..
  echo -e "$purple(i) Flashable zip generated under $ZIP_DIR.$nc"
  echo -e "$cyan#######################################################################$nc"
fi


if [[ "$choice" == "5" ]]; then
  echo -e "\n$cyan#######################################################################$nc"
  cd $ZIP_DIR
  gdrive upload Dark-Ages*.zip &>/dev/null
  cd ..
  echo -e "$purple(i) Zip uploaded Sucessfully!"
  echo -e "$cyan#######################################################################$nc" 
fi

if [ "$choice" == "6" ]; then
 exit 1
fi
done

