# obicaller

A talking caller ID daemon for the OBiTALK OBi200. It communicates with the OBi
unit via syslog (essentially UDPv4 push notification) and runs out of the box on
Raspbian after installing eSpeak. You'll also need Python 3 and a working audio
setup.

### Usage

1. Configure the OBi200 to send its syslog messages over the network. On the web
   interface, the path is System Management > Device Admin > Syslog.
2. Run this script on the host and UDP port you specified in step 1.
3. Done! Start taking calls.

### License

Public domain.
