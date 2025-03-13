#!/bin/bash

echo ""
echo "---------------------------"
echo "- Netduke32 Bootstrapping -"
echo "-    MongoQ V0.1 '25      -"
echo "---------------------------"
echo ""

# Check if unrar, wget and TODO! ... are available

# List all required commands here:
required_commands=(unrar wget sha256sum)

for cmd in "${required_commands[@]}"; do
  if ! command -v "$cmd" &> /dev/null; then
    echo "Error: '$cmd' is not installed or not available."
    echo "Please install!"
    echo ""
    exit 1
  fi
done

# -----------------------

# Required files download:

# Duke Nukem 3D full version - Required files - duke3d.grp ...
# Source: https://archive.org/details/Duke3dAtomicEdition
duke3d_ae_url="https://archive.org/download/Duke3dAtomicEdition/Duke3d%20Atomic%20Edition.rar"
duke3d_ae_file="Duke3d Atomic Edition.rar"
duke3d_ae_cs="a7391bc586430c7af40fe560f096f886189ff0abf73d3932f926d340e17605b9"

# HRP Pack
# Source: https://hrp.duke4.net/download.php
duke3d_hrp_url="http://www.duke4.org/files/nightfright/hrp/duke3d_hrp.zip"
duke3d_hrp_file="duke3d_hrp.zip"
duke3d_hrp_cs="f217df456b4f11055041731033e35e4402fada99253e714e37c4a27e6fdc78a5"

# XXX Pack
# Source: https://hrp.duke4.net/download.php
duke3d_xxx_url="http://www.duke4.org/files/nightfright/related/duke3d_xxx.zip"
duke3d_xxx_file="duke3d_xxx.zip"
duke3d_xxx_cs="c31713e6400a175a1bfa3bd369d132f8a8abce8915c113549f98262b9a84b534"

# Maps !!!
# TODO: !!!

# -----------------------

echo "Checking if files are already downloaded ..."
echo "Downloading ..."
echo ""

# Function for downloading ...

check_file_download_hash() {
  local file="$1"
  local expected_hash="$2"
  local url="$3"

  # Check if the file exists and has the correct checksum
  if [ -f "$file" ] && [ "$(sha256sum "$file" | awk '{print $1}')" = "$expected_hash" ]; then
    echo "File '$file' is already present and has the correct SHA256 checksum."
    return 0
  fi

  # If the file is missing or has the wrong checksum, download it again
  #echo "File '$file' is missing or has a wrong SHA256 checksum. Starting download ..."
  echo "Starting download of file '$file' as it is missing or has a wrong SHA256 checksum ..."
  rm -f "$file"  # remove the existing (incorrect) file if present

  if ! wget -q --show-progress -O "$file" "$url"; then
    echo "Error downloading '$url'."
    exit 1
  fi

  # Verify the checksum again after downloading
  if [ "$(sha256sum "$file" | awk '{print $1}')" = "$expected_hash" ]; then
    echo "File '$file' was successfully downloaded and the checksum is correct."
  else
    echo "Error: The downloaded file '$file' has the wrong checksum!"
    exit 1
  fi
}


# Download them all!
check_file_download_hash "$duke3d_ae_file" "$duke3d_ae_cs" "$duke3d_ae_url"
check_file_download_hash  "$duke3d_hrp_file" "$duke3d_hrp_cs" "$duke3d_hrp_url"
check_file_download_hash  "$duke3d_xxx_file" "$duke3d_xxx_cs" "$duke3d_xxx_url"
echo "TODO: Download maps ?!"

echo ""
echo "Creating directory structure ..."
echo ""
#mkdir compile
#mkdir autoload
#mkdir maps

echo "Unpacking files ..."
echo ""

# Extract Duke Nukem 3D files
rm -rf duke3d && mkdir duke3d
unrar e -o+ "$duke3d_ae_file" ./duke3d

# Make all filename characters be lowercase
echo ""
echo "Lowercasing ..."

for f in duke3d/*; do
  if [ -f "$f" ]; then
    mv -- "$f" "${f,,}"
  fi
done

# Delete unneeded files
echo ""
echo "Deleting unneeded files ..."
rm ./duke3d/modem.pck
rm ./duke3d/commit.exe
rm ./duke3d/cdrom.ini
rm ./duke3d/ultramid.ini
rm ./duke3d/setup.exe
rm ./duke3d/license.doc
rm ./duke3d/duke3d.exe
rm ./duke3d/readme.txt
rm ./duke3d/dn3dhelp.exe
rm ./duke3d/setmain.exe

# Run netduke32 compilation
echo ""
echo "Now compile netduke32 ..."
