# netduke32
Setting up Netduke32 for multiplayer games with custom maps

-> [Installation](INSTALLATION.md)

What you need to play netduke32:

* Source code - https://voidpoint.io/StrikerTheHedgefox/eduke32-csrefactor/-/releases
* Compiler tools as seen in: https://wiki.eduke32.com/wiki/Main_Page
* Attention: Compile with "make netduke32" (!) - standard eduke32 ports do not offer proper network code
* Game content - https://archive.org/details/Duke3dAtomicEdition - that is: duke3d.grp, duke.rts
* HRP textures - https://hrp.duke4.net/download.php - that is: Duke3D HRP v5.4 and XXX Pack v1.33 (optional)
* For network games the relevant Python scripts are included here

What works in this repo: 

* Compilation of source code with Linux
* Potentially removing out-of-sync message when combining Linux and Windows systems
* Python scripts for client / server connection
* Map selection on startup
  
TODO: 

* Describe usage more detailed
* Maps as Download - where to host 226MB?
* Windows MSYS2 compilation guide / .exe generation
* Check out-of-sync error removal patch works with Linux <-> Windows
* Integrate FritzBox UDP port open script
* Description of Wireguard trick with dedicated server
* Windows Python standalone .exe for client / server scripts with icon
