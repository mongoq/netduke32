# netduke32
Setting up netduke32 for multiplayer games with custom maps even across the Internet

![netduke32 image](https://wiki.eduke32.com/w/images/5/5e/Netduke32.png)


tl;dr: [Installation](INSTALLATION.md)

What you need to play netduke32:

* [Source code v1.2.1](https://voidpoint.io/StrikerTheHedgefox/eduke32-csrefactor/-/releases) - compile with *get_and_patch_and_compile.sh* (auto download)
* Get appropriate [toolchain](https://wiki.eduke32.com/wiki/Main_Page) for your os before compilation
* Attention: netduke32 is compiled by *make netduke32* - standard eduke32 ports (as also compiled by *make* only) do not include functional network code
* [Game content](https://archive.org/details/Duke3dAtomicEdition) - that is duke3d.grp and duke.rts and [HRP textures](https://hrp.duke4.net/download.php) - that is Duke3D HRP v5.4 and XXX Pack v1.33 (optional) can also be downloaded by running *bootstrap.sh*
* For network games - use the relevant Python starter scripts included here :-)

What works with this repo: 

* Compilation of source code for Linux and Windows
* Potentially removing *out-of-sync message* when combining Linux and Windows systems
* Python scripts for client / server connection initiation
* Map selection on startup of server script
* Started implementing *bootstrapping* scripts to automatically install and configure netduke32
* Fritz!Box UDP port forwarding activator
  
TODO: 

* Maps as download - where to host 226MB?
* Windows MSYS2 compilation script / .exe tests
* Check *out-of-sync error* removal patch works with Linux <-> Windows
* Wireguard trick with dedicated server (IPv4 address is required for the server side of netduke32)
* Windows Python standalone .exe for client / server scripts with icon
* Test of dedicated server: *xvfb-run ./netduke32 -nosetup -dedicated ...* (seems to start, no gui, with sound, more to be tested!)
* https://wiki.eduke32.com/wiki/NetDuke32 ... https://wiki.eduke32.com/wiki/Frequently_Asked_Questions ... https://forums.duke4.net/topic/9956-strikerdm-the-ultimate-netduke32-dm-mod/ ... https://shadowmavericks.com/#mods/strikerdm.php ... check out and copy infos ...
