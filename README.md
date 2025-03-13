# netduke32
Setting up Netduke32 for multiplayer games with custom maps

tl;dr: Have a look at the [Installation](INSTALLATION.md)

What you need to play netduke32:

* Source code - https://voidpoint.io/StrikerTheHedgefox/eduke32-csrefactor/-/releases (v1.2.1 is the most recent)
* Compiler tools as seen in: https://wiki.eduke32.com/wiki/Main_Page
* Attention: Compile with "make netduke32" (!) - standard eduke32 ports do not offer proper network code
* Game content - https://archive.org/details/Duke3dAtomicEdition - that is: duke3d.grp, duke.rts
* HRP textures - https://hrp.duke4.net/download.php - that is: Duke3D HRP v5.4 and XXX Pack v1.33 (optional)
* For network games: The relevant Python scripts included here

What works in this repo: 

* Compilation of source code with Linux and Windows
* Potentially removing *out-of-sync message* when combining Linux and Windows systems
* Python scripts for client / server connection initiation
* Map selection on startup
  
TODO: 

* Maps as Download - where to host 226MB?
* Windows MSYS2 compilation guide / .exe generation
* Check out-of-sync error removal patch works with Linux <-> Windows
* Integrate FritzBox UDP port open script
* Description of Wireguard trick with dedicated server (IPv4 address required for the server)
* Windows Python standalone .exe for client / server scripts with icon
