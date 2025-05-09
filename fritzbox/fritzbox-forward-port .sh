#!/bin/bash

help() {
   echo 'usage: fritzbox-forward-port (ENABLE|DISABLE) DESTINATION_IP PORT [COMMENT]'
   echo '       fritzbox-forward-port --help'
   echo
   echo '    This script will enable/disable port $PORT forwarding on'
   echo '    a FRITZ!Box to the $DESTINATION_IP'
   echo
   echo '     You can set the following variables directly in the'
   echo '     script, or in `~/.fritzbox.conf` :'
   echo
   echo '         FB=fritz.box'
   echo '         FB_USER=fritz1234'
   echo '         FB_PASS=password'
   echo '         FB_CERT=~/.fritzbox.pem'
   echo
   echo '     FB_CERT can be left empty but then the https'
   echo '     connection will NOT be authenticated'
   echo
   exit 0
}

# set the following in `~/.fritzbox.conf`
#
     FB=192.168.0.1
     FB_USER=fritz4711-changeme
     read -sp "FritzBox PW: " FB_PASS

#     FB_CERT=./fritzbox.pem # can be left empty but then the https
#                             # connection will NOT be authenticated
# make sure ~/.fritzbox.conf is rwx------
#
[ -f ~/.fritzbox.conf ] && source ~/.fritzbox.conf

if [ "$FB_CERT" == "" ]; then
  USE_CERT=-k
else
  USE_CERT="--cacert $FB_CERT"
fi

# TODO: maybe it'd be better to use the a UPnP tool instead
#       of using curl
#
# UPnP on Fritzbox docu:
#
# * nice overview over useful UPNP calls:
#   https://blog.grimreapers.de/index.php/2020/03/08/probleme-bei-der-portfreigabe-ueber-upnp-von-systemen-hinter-einem-usg-ohne-nat-und-einer-fritzbox/
#
# * nice Python script:
#   https://www.heise.de/forum/c-t/Kommentare-zu-c-t-Artikeln/Fritzbox-per-Skript-fernsteuern/Re-AddPortMapping-mit-Python-funktioniert-nicht-Upate/posting-30922097/show/
#
# * one line curl commands for FritzBox:
#   https://knx-user-forum.de/forum/supportforen/smarthome-py/934835-avm-plugin?p=1533217#post1533217
#
# * Gettings started with TR-064/UPnP by AVM:
#   https://avm.de/fileadmin/user_upload/Global/Service/Schnittstellen/AVM_TR-064_first_steps.pdf
#
# * Technical Notes about TR-064/UPnP by AVM:
#   https://avm.de/fileadmin/user_upload/Global/Service/Schnittstellen/AVM_Technical_Note_-_Konfiguration_ueber_TR-064.pdf
#
# * TR-064 - WAN IP Connection API docu from AVM:
#   https://avm.de/fileadmin/user_upload/Global/Service/Schnittstellen/wanipconnSCPD.pdf
#
# * TR-064 standards by the standartization body:
#   https://wiki.broadband-forum.org/display/RESOURCES/Broadband+Forum+Published+Resources#tf-filters=%7B%22selectfilters%22%3A%5B%5D%2C%22userfilters%22%3A%5B%22Number%22%5D%2C%22numberfilters%22%3A%5B%5D%2C%22datefilters%22%3A%5B%5D%2C%22globalfilter%22%3Atrue%2C%22columnhider%22%3Afalse%2C%22iconfilters%22%3A%5B%5D%2C%22defaults%22%3A%5B%22TR-064%22%2C%22%22%5D%2C%22width%22%3A%5B%22150%22%2C%22150%22%5D%2C%22inverse%22%3A%5Bfalse%2Cfalse%5D%2C%22order%22%3A%5B0%2C1%5D%2C%22ddSeparator%22%3A%5B%5D%2C%22ddOperator%22%3A%5B%5D%2C%22sorts%22%3A%5B%22Date%20%E2%87%A9%22%5D%7D
#
# * Definitions that the TR-064 standard uses (by the UPNP standartization body):
#   http://www.upnp.org/specs/gw/UPnP-gw-WANPPPConnection-v1-Service.pdf
#
# * Schnittstellen und Protokolle rund um FritzBox:
#   https://avm.de/service/schnittstellen/
#
# * libfritzpp C++ lib:
#   https://github.com/jowi24/libfritzpp/blob/master/FritzClient.cpp
#
# * fritzctl go binary that works, that can authenticate, but doesn't
#   know much about the TR-064 interface
#   https://github.com/bpicode/fritzctl
#
# * not relevant for UPnP but I keep it here for docu for myself:
#
#   * old md5 way to log in :
#     http://www.apfel-z.net/artikel/Fritz_Box_API_via_curl_wget
#
#   * How to log in by AVM (not relevant for UPnP):
#     https://avm.de/fileadmin/user_upload/Global/Service/Schnittstellen/AVM_Technical_Note_-_Session_ID_english_2021-05-03.pdf
#     in the past the FritzBox was using md5 hash
#     based auth. They have moved to a PBKDF2 hash
#     as of FRITZ!OS: 07.28 I could not get the
#     old md5 based auth to work. Does it work at
#     all any more?

fritzbox_forward_port() {
  local enable_or_disable="$1"
  local destination_ip="$2"
  local port="$3"
  local comment="$4"

  local command
  local output
  local exit_code

  if [ "$comment" == "" ]; then
    comment="Port $port to $destination_ip"
  fi

  command=$( echo \
    "curl $USE_CERT --anyauth -u $FB_USER:$FB_PASS --silent" \
        "https://$FB:49443/upnp/control/wanipconnection1" \
           "-H 'Content-Type: text/xml; charset=\"utf-8\"'" \
           "-H 'SoapAction: urn:dslforum-org:service:WANIPConnection:1#AddPortMapping'" \
           "-d '
<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">
  <s:Body>
    <u:AddPortMapping xmlns:u=\"urn:schemas-upnp-org:service:WANIPConnection:1\">
      <NewRemoteHost></NewRemoteHost>
      <NewExternalPort>$port</NewExternalPort>
      <NewProtocol>UDP</NewProtocol>
      <NewInternalPort>$port</NewInternalPort>
      <NewInternalClient>$destination_ip</NewInternalClient>
      <NewEnabled>$enable_or_disable</NewEnabled>
      <NewPortMappingDescription>$comment</NewPortMappingDescription>
      <NewLeaseDuration>0</NewLeaseDuration>
    </u:AddPortMapping>
  </s:Body>
</s:Envelope>'"
  )
  output=$( eval "$command" )
  exit_code=$?

  if echo "$output" | grep -q errorCode || \
     [ "$exit_code" != "0" ] ; then
    echo "There was an error while executing the following command:"
    echo
    echo "$command"
    echo
    echo "The output was:"
    echo
    echo "$output"
    echo
    echo "And the exit code was:"
    echo
    echo "$exit_code"
    echo

    if [ "$exit_code" != "0" ] ; then
      return $exit_code
    else
      return 1
    fi
  else
    return 0
  fi
}

[ "$1" == "--help" ] && help

# parse first parameter (ENABLE|DISABLE)
#
if [ "$1" == "ENABLE" ]; then
  enable_or_disable=1
elif [ "$1" == "DISABLE" ]; then
  enable_or_disable=0
else
  echo "ERROR: the first parameter needs to be either ENABLE or DISABLE"
  exit 1
fi

# parse second parameter DESTINATION_IP
#
if [ "$2" == "" ]; then
  echo "ERROR: the second parameter needs to be set to the DESTINATION_IP"
  exit 2
else
  destination_ip="$2"
fi

# parse third parameter PORT
#
if [ "$3" == "" ]; then
  echo "ERROR: the third parameter needs to be set to PORT"
  exit 3
else
  port="$3"
fi

# parse fourth parameter COMMENT
#
comment="$4"

if fritzbox_forward_port "$enable_or_disable" "$destination_ip" "$port" "$comment"; then
  echo "success :-)"
  exit 0
else
  echo "failed"
  exit 11
fi
