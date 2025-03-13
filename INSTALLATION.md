Installation

1. Get compilation tools from: https://wiki.eduke32.com/wiki/Main_Page (Linux or Windows)
2. Compile *netduke32* binary using *get_patch_and_compile.sh* script. This automatically downloads and patches the most recent source code. Make sure to use *make netduke32* as simple *make* creates eduke32 port with disfunctional network code.
3. Get *duke3d.grp* and *duke.rts* from https://archive.org/details/Duke3dAtomicEdition
4. Get HRP and XXX pack from https://hrp.duke4.net/download.php and put them in folder *autoload*.
5. Get Maps from TODO
6. Setup either port forwarding with a port like *23513* (standard). Alternatively use the Wireguard trick (TODO). The game needs a IPv4 address for  the server side.
7. Use the Python scripts for server and client side (and the JSON settings files).
