#!/usr/bin/python3

import json
import subprocess
import sys

# File Selector --- Start ------------------------------------------------------ 

import os
import curses

def list_directory(path):
    items = os.listdir(path)
    items.sort()
    return items

def file_selector(stdscr, initial_path):
    curses.curs_set(0)
    stdscr.keypad(True)

    curses.start_color()
    curses.init_pair(1, curses.COLOR_BLACK, curses.COLOR_WHITE)

    if not os.path.exists(initial_path) or not os.path.isdir(initial_path):
        stdscr.addstr(0, 0, "Folder 'maps' doesn't exist.")
        stdscr.refresh()
        stdscr.getch()
        return None

    current_path = initial_path
    selected_index = 0
    top_row = 0  # Zeile, ab der der Bildschirm beginnt zu zeichnen

    while True:
        stdscr.clear()
        height, width = stdscr.getmaxyx()

        items = list_directory(current_path)
        items = [".", ".."] + items

        # Wenn der ausgewählte Index außerhalb des sichtbaren Bereichs ist, scrollen
        if selected_index < top_row:
            top_row = selected_index
        elif selected_index >= top_row + height:
            top_row = selected_index - height + 1

        for idx in range(top_row, min(len(items), top_row + height)):
            item = items[idx]
            x = 0
            y = idx - top_row
            if len(item) > width:
                item = item[:width - 1]  # Kürze die Zeichenkette, wenn sie zu lang ist
            if idx == selected_index:
                stdscr.attron(curses.color_pair(1))
                stdscr.addstr(y, x, item)
                stdscr.attroff(curses.color_pair(1))
            else:
                stdscr.addstr(y, x, item)

        key = stdscr.getch()

        if key == curses.KEY_UP:
            selected_index = max(0, selected_index - 1)
        elif key == curses.KEY_DOWN:
            selected_index = min(len(items) - 1, selected_index + 1)
        elif key == ord('\n'):
            selected_item = items[selected_index]
            if selected_item == "..":
                # Übergeordnetes Verzeichnis auswählen
                current_path = os.path.dirname(current_path)
                selected_index = 0
                top_row = 0  # Zurücksetzen des Scroll-Offsets bei Verzeichniswechsel
            else:
                selected_path = os.path.join(current_path, selected_item)
                if os.path.isdir(selected_path):
                    current_path = selected_path
                    selected_index = 0
                    top_row = 0  # Zurücksetzen des Scroll-Offsets bei Verzeichniswechsel
                else:
                    relative_path = os.path.relpath(selected_path, initial_path)
                    return os.path.join('.', 'maps', relative_path)

        stdscr.refresh()

def select_file():
    initial_path = os.path.join(os.getcwd(), 'maps')
    return curses.wrapper(file_selector, initial_path)

# File Selector --- End -------------------------------------------------------- 

# Path to JSON-File
json_file = "inet_start_server_25.json"

# Load JSON-Data
with open(json_file, "r") as f:
  data = json.load(f)

# Reading JSON-Data
server = data["server"]
port = data["port"]
playername = data["playername"]
numberofplayers = data["numberofplayers"]
numberofbots = data["numberofbots"]
duke_map = data["duke_map"]
fraglimit = data["fraglimit"]
disable_monsters = data["disable_monsters"]
weaponstay = data["weaponstay"]
startup_window = data["startup_window"]
ssh_magic = data["ssh_magic"]
executable = data["executable"]
password = data["password"]

# TODO: Fix Bots
# -a -q23		Use fake player AI (fake multiplayer only) ?!

# Output
print("\n-------------------------------------")
print("Netduke32 Server Starter V0.3a MongoQ")
print("-------------------------------------\n")

# Read new user data
new_server = input("Server address [" + server + "]: ")
if new_server:
     server=new_server

new_port = input("Port (std.: 23513) [" + port + "]: ")
if new_port:
     port=new_port

new_ssh_magic = input("SSH magic (std.: 0 no action / 1 enable / 2 disable [" + ssh_magic + "]: ")
if new_ssh_magic == "0":
    pass
elif new_ssh_magic == "1":
    #print("... enabling SSH ...")  
    subprocess.run("./ssh-magic.sh " + server + " on", shell=True)  
elif new_ssh_magic == "2":
    #print("... disabling SSH ...")    
    subprocess.run("./ssh-magic.sh " + server + " off", shell=True)  
    sys.exit(0)
#if new_ssh_magic:
#     ssh_magic=new_ssh_magic

new_executable = input("Executable (std.: netduke32) [" + executable + "]: ")
if new_executable:
     executable=new_executable

new_playername = input("Playername [" + playername + "]: ")
if new_playername:
     playername=new_playername

new_numberofplayers = input("Number of players [" + numberofplayers + "]: ")
if new_numberofplayers:
     numberofplayers=new_numberofplayers

new_numberofbots = input("Number of bots [" + numberofbots + "]: ")
if new_numberofbots:
     numberofbots=new_numberofbots

new_password = input("Password [" + password + "]: ")
#if new_password:
password=new_password

new_duke_map = input("Map (tab-enter to select, space-enter to clear) [" + duke_map + "]: ")
if '\t' in new_duke_map:
    duke_map = select_file()
    print("Map set to [" + duke_map + "]")
elif ' ' in new_duke_map:
    duke_map = ""
    print("Map set to [" + duke_map + "]")

    
#if new_duke_map:
#     duke_map=new_duke_map

new_fraglimit = input("Frag limit [" + fraglimit + "]: ")
if new_fraglimit:
     fraglimit=new_fraglimit

new_disable_monsters = input("Disable monsters [" + disable_monsters + "]: ")
if new_disable_monsters:
     disable_monsters=new_disable_monsters

new_weaponstay = input("Weapon stay [" + weaponstay + "]: ")
if new_weaponstay:
     weaponstay=new_weaponstay

new_startup_window = input("Startup window [" + startup_window + "]: ")
if new_startup_window:
     startup_window=new_startup_window

# Save new JSON-Data
data["server"] = server
data["port"] = port
data["playername"] = playername
data["numberofplayers"] = numberofplayers
data["numberofbots"] = numberofbots
data["duke_map"] = duke_map
data["fraglimit"] = fraglimit
data["disable_monsters"] = disable_monsters
data["weaponstay"] = weaponstay
data["startup_window"] = startup_window
data["ssh_magic"] = ssh_magic
data["executable"] = executable
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

# Setup SSH magic
#if int(ssh_magic) > 0:
#    print("Starting inet server " + server + " before we start netduke32 ...")
    #subprocess.run("ssh " + server, shell=True)
#    subprocess.run("./ssh-magic.sh " + server + " on", shell=True)

# Hardcoded parameters --> https://wiki.eduke32.com/wiki/Command_line_options
parameters = []
parameters.append("./" + executable)
parameters.append(["-g", "./autoload/duke3d_hrp.zip", "-g", "./autoload/duke3d_xxx.zip"]) # Use HRP and XXX-Pack
parameters.append("-allowvisibility") # Allows visibility adjustment in multiplayer. TODO !!!
parameters.append("-nologo") # No stupid start animation

# Assemble parameters
parameters.append("-port " + port)
parameters.append("-name " + playername)
parameters.append("-map " + duke_map if duke_map else "") # TODO: Check this !!!

#parameters.append("-password " + password if password else ""
#(["-password", password] if password else [])
#parameters.append(["-password", password] if password else [])
#parameters.append("-password " + password if password else "")

# Magic hack ... append if password not empty
password and parameters.append(f"-password {password}")

parameters.append(("-y" + fraglimit) if int(fraglimit) > 0 else "")
parameters.append("-m" if int(disable_monsters) > 0 else "")
parameters.append("-wstay" if int(weaponstay) > 0 else "")
parameters.append(("-a -q" + numberofbots) if int(numberofbots) > 0 else "")
parameters.append(("-net /n0:" + numberofplayers) if int(numberofplayers) > 1 else "")
# parameters.append("-name " + playername)
#parameters.append(("-a -q" + numberofbots) if int(numberofbots) > 0 else "")
#parameters.append("-map " + duke_map if duke_map else "") # TODO: Check this !!!
#parameters.append(("-y" + fraglimit) if int(fraglimit) > 0 else "")
#parameters.append("-m" if int(disable_monsters) > 0 else "")
#parameters.append("-wstay" if int(weaponstay) > 0 else "")
parameters.append("-nosetup" if int(startup_window) == 0 else "")

# Show what's really started
print("Press enter to run:", runme := " ".join(str(elem) if not isinstance(elem, list) else ' '.join(elem) for elem in parameters))
input() # Wait ...

# Call subprocess and start netduke32
try:
    result = subprocess.run(runme, shell=True) # , stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
except FileNotFoundError:
    print("\nnetduke32 binary not found :-(\n")
print(result)
