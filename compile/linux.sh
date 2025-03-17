#!/bin/bash

# This script compiles netduke32 and patches the out-of-sync error when running Linux and Windows combined
# Check https://voidpoint.io/StrikerTheHedgefox/eduke32-csrefactor/-/releases for new releases and changes and fixes

# Variables
ZIP_URL="https://voidpoint.io/StrikerTheHedgefox/eduke32-csrefactor/-/archive/NetDuke32_v1.2.1/eduke32-csrefactor-NetDuke32_v1.2.1.zip"
ZIP_FILE=$(basename "$ZIP_URL")
TEMP_DIR="eduke32_source"
TARGET_FILE="${ZIP_FILE%.zip}/source/netduke32/src/game.cpp"
LINE_NUMBER=8486 # --> We are commenting out: // Net_DisplaySyncMsg()  

# Show intro
echo ""
echo "-------------------------------------------------"
echo "- Netduke32 V1.2.1 - Linux Compiler and Patcher -"
echo "-                MongoQ V0.2                    -"
echo "-------------------------------------------------"
echo ""
sleep 3

# 1. Clean up
echo "Cleaning existing files."
rm $ZIP_FILE 2>/dev/null
# rm -ri $TEMP_DIR
rm netduke32 2>/dev/null
sleep 3

# 1. Download the source code .zip file
echo ""
echo "Downloading ..."
wget $ZIP_URL -O $ZIP_FILE
sleep 3

# 2. Unzip the file into a temporary directory
echo "Unzipping ..."
sleep 3
unzip $ZIP_FILE -d $TEMP_DIR

# 3. Comment out disturbing out-of sync screen display
echo ""
echo "Commenting out Net_DisplaySyncMsg() instruction ..."
echo "--> //Net_DisplaySyncMsg()"
sed -i "${LINE_NUMBER}s/^/\/\//" $TEMP_DIR/$TARGET_FILE
echo "Line $LINE_NUMBER in $TARGET_FILE was commented out."
sleep 3

# 4. Compile source code
echo "" 
echo "Check for further compiling instructions and what is needed:"
echo "https://wiki.eduke32.com/wiki/Building_EDuke32_on_Linux"
echo ""

read -p "Do you want to compile netduke32? (Y/n): " choice
choice=${choice:-y}  

if [[ "$choice" == [Yy] ]]; then
    echo "You chose Yes. Now we'll compile ..."
    cd $TEMP_DIR/${ZIP_FILE%.zip}
    echo ""
    echo "We are running: make netduke32"
    echo ""
    make netduke32 #-j\$(nproc) -> FIXME!
    cp netduke32 ../.. 
    echo ""
    echo "Now take the compiled netduke32 binary and put it in your netduke32 subfolder."
    echo ""
else
    echo "You chose No. Goodbye."
fi

# 5. Clean up
cd ../..
pwd
rm $ZIP_FILE #2>/dev/null
#rm -ri $TEMP_DIR
