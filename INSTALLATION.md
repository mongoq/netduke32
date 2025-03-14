# Installation

1. Get the [compiler toolchain](https://wiki.eduke32.com/wiki/Main_Page) (Linux or Windows, MacOS 15 has problems)
2. Compile *netduke32* binary using the *get_patch_and_compile.sh* script. This automatically downloads and patches the most recent [source code](https://voidpoint.io/StrikerTheHedgefox/eduke32-csrefactor/-/releases) of netduke32 - . Make sure to use *make netduke32* if you compile it yourself as simple *make* creates an eduke32 port with disfunctional network code. The included patch removes the error message *Net_DisplaySyncMsg()* when running the game on Linux and Windows pcs in combination.
3. Run *bootstrap.sh* to download high resolution textures and game content. Put *duke3d_hrp.zip* and *duke3d_xxx.zip* in a folder called *autoload*. Put the contents of the *duke3d* folder in your main netduke32 folder.
4. Get Maps from (TODO) and put them in the subfolder *maps*. Make sure to have the same maps on all installations.
5. Setup either port forwarding with a UDP port like *23513* (standard) on your router. If you have a FritzBox! use the provided scripts to open and close the port. Alternatively use the Wireguard trick (TODO). The game needs a IPv4 address for the server side. When running the game in your LAN you obviously do not need this additional efforts. Just make sure the server port, e.g. *23513*, is reachable via UDP.
6. Use the Python starter scripts for server and client side (and the JSON settings files). This should work with Windows and Linux.
