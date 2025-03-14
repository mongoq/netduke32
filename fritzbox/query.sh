#!/bin/bash

#https://knx-user-forum.de/forum/supportforen/smarthome-py/934835-avm-plugin/page44#post1533217

read -sp "FritzBox PW: " pw

if curl --anyauth -u fritz4711-changeme:"$pw" 'https://192.168.0.1:49443/upnp/control/wanipconnection1' \
  -H 'Content-Type: text/xml; charset="utf-8"' \
  -H 'SoapAction: urn:dslforum-org:service:WANIPConnection:1#GetSpecificPortMappingEntry' \
  -d '<?xml version="1.0"?>
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
  <s:Body>
    <u:GetSpecificPortMappingEntry xmlns:u="urn:dslforum-org:service:WANIPConnection:1">
      <NewRemoteHost>0.0.0.0</NewRemoteHost>
      <NewExternalPort>22222</NewExternalPort>
      <NewProtocol>UDP</NewProtocol>
    </u:GetSpecificPortMappingEntry>
  </s:Body>
</s:Envelope>' -s -k | grep -q "<NewEnabled>1"; then
 echo -e "\n-> Port forwarding active :-) Please disable after use."
else
  echo -e "\n-> NO port forwarding active :-/"
fi

