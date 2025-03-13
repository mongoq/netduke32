#!/usr/bin/python3

import json
import subprocess
import sys

# Path to JSON-File
json_file = "inet_start_client_25.json"

# Load JSON-Data
with open(json_file, "r") as f:
  data = json.load(f)

# Reading JSON-Data
server = data["server"]
port = data["port"]
playername = data["playername"]
password = data["password"]
startup_window = data["startup_window"]

# TODO: Fix Bots
# -a -q23		Use fake player AI (fake multiplayer only) ?!

# Output
print("\n-------------------------------------")
print("Netduke32 Client Starter V0.3a MongoQ")
print("-------------------------------------\n")

# Read new user data
new_server = input("Server address [" + server + "]: ")
if new_server:
     server=new_server

new_port = input("Port (std.: 23513) [" + port + "]: ")
if new_port:
     port=new_port

new_playername = input("Playername [" + playername + "]: ")
if new_playername:
     playername=new_playername

new_password = input("Password [" + password + "]: ")
#if new_password:
password=new_password

new_startup_window = input("Startup window [" + startup_window + "]: ")
if new_startup_window:
     startup_window=new_startup_window

# Save new JSON-Data
data["server"] = server
data["port"] = port
data["playername"] = playername
data["startup_window"] = startup_window
data["password"] = password

with open(json_file, "w") as f:
    json.dump(data, f, indent=4)

# Master server ping
ipv4_ping_response = subprocess.run(["ping", "-4", "-c", "1", "-W", "10",  server], capture_output=True, text=True)
ipv6_ping_response = subprocess.run(["ping", "-6", "-c", "1", "-W", "5", server], capture_output=True, text=True)

if "1 received" in ipv4_ping_response.stdout:
    print(f"\n{server} answers to IPv4-pings. All good to go ... :-)\n")
else:
    print(f"\n{server} does not answer to IPv4-pings. Exiting. :-(")
    if "1 received" in ipv6_ping_response.stdout:
        print(f"{server} answers to IPv6-pings but Netduke32 cannot use IPv6 alone.")
    sys.exit()

# Executable netduke32 with Windows or Linux
import platform
os_name = platform.system()
if os_name == "Windows":
    #print("We are running Windows ...")
    executable = "netduke32.exe"
elif os_name == "Linux":
    #print("We are running Linux ...")
    executable = "./netduke32"

# Hardcoded parameters --> https://wiki.eduke32.com/wiki/Command_line_options


parameters = []
parameters.append(executable)
parameters.append(["-g", "./autoload/duke3d_hrp.zip", "-g", "./autoload/duke3d_xxx.zip"]) # Use HRP and XXX-Pack
parameters.append("-allowvisibility") # Allows visibility adjustment in multiplayer. TODO !!!
parameters.append("-nologo") # No stupid start animation

# Assemble parameters
parameters.append("-name " + playername)
#parameters.append("-map " + duke_map if duke_map else "") # TODO: Check this !!!

parameters.append("-nosetup" if int(startup_window) == 0 else "")

#parameters.append("-password " + password if password else ""
#(["-password", password] if password else [])
#parameters.append(["-password", password] if password else [])
#parameters.append("-password " + password if password else "")

# Magic hack ... append if password not empty
password and parameters.append(f"-password {password}")

parameters.append("-net /n0 " + server + ":" + port)

#parameters.append(("-y" + fraglimit) if int(fraglimit) > 0 else "")
#parameters.append("-m" if int(disable_monsters) > 0 else "")
#parameters.append("-wstay" if int(weaponstay) > 0 else "")
#parameters.append(("-a -q" + numberofbots) if int(numberofbots) > 0 else "")
#parameters.append(("-net /n0:" + numberofplayers) if int(numberofplayers) > 1 else "")
# parameters.append("-name " + playername)
#parameters.append(("-a -q" + numberofbots) if int(numberofbots) > 0 else "")
#parameters.append("-map " + duke_map if duke_map else "") # TODO: Check this !!!
#parameters.append(("-y" + fraglimit) if int(fraglimit) > 0 else "")
#parameters.append("-m" if int(disable_monsters) > 0 else "")
#parameters.append("-wstay" if int(weaponstay) > 0 else "")
#parameters.append("-nosetup" if int(startup_window) == 0 else "")

# Show what's really started
print("Press enter to run:", runme := " ".join(str(elem) if not isinstance(elem, list) else ' '.join(elem) for elem in parameters))
input() # Wait ...

# Call subprocess and start netduke32
try:
    result = subprocess.run(runme, shell=True) # , stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
except FileNotFoundError:
    print("\nnetduke32 binary not found :-(\n")
print(result)
