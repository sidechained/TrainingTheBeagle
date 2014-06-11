## Networking

This document covers basic network configuration and troubleshooting on the Beaglebone Black, focussing particular on editing the debian /etc/network/interfaces file. It is assumed that you are editing the interfaces file on the beaglebone itself (i.e. by connecting via ssh over ethernet). Another approach is to insert the sd card into your pc, and edit the interfaces file from the rootfs partition (sometimes necessary if you get locked out of the beaglebone itself)

### Tutorials

#### Giving the Beaglebone a Static IP

- on Debian, DHCP is enabled by default
- using DHCP is often an issue
- to change this we need to edit /etc/network/interfaces
- firstly, log in
$ ssh debian@192.168.1.3
- now make a backup of the interfaces file (in case of emergency)
$ sudo cp /etc/network/interfaces /etc/network/interfaces.bak
- edit the original version
$ sudo nano /etc/network/interfaces
- replace the following...
iface eth0 inet dhcp
- with… (example for IP of 192.168.1.3)

iface eth0 inet static
       address 192.168.1.3
       netmask 255.255.255.0
       network 192.168.1.0
       broadcast 192.168.1.255
       gateway 192.168.1.1

- restart networking
$ sudo /etc/init.d/networking restart
$ sudo /etc/init.d/networking reload

#### Working with DHCP

__TODO__

- is there an easy way work with the beagle over DHCP and know what IP it has been allocated?
- according to http://www.armhf.com/index.php/getting-started-with-ubuntu-img-file/ Wheezy runs a DHCP server by default
- suggestion is: Try pinging it by name: "debian-armhf" for the debian images and "ubuntu-armhf" for the ubuntu images. It is setup for DHCP, so whatever your network handed out. You could mount partition 2 of the SD card and check the logs or edit the /etc/network/interfaces file to have a static IP address:

#### Working over USB

__TODO__

#### Using beaglebone.local

__TODO__

- in what cases can this approach be used instead?
- only when connected over USB?

#### Enabling a WIFI Dongle

__NEEDS TESTING__

- this is concisely covered in Fredrik's tutorial here: https://github.com/redFrik/udk10-Embedded_Systems/tree/master/udk131128#--extra-wlanwifi
- it is recommended to use a WIFI dongle that is based on the RALINK 5370 chipset
- e.g. http://www.aliexpress.com/store/product/Mini-150-Mbps-USB-Nano-802-11n-Wireless-Wifi-Network-LAN-Card-Adapter-EDUP-EP-N8531/409201_840839946.html
- NOTE: I remember having some problems getting my dongle to power up, need to go though this again to remember the problem

### Troubleshooting

This section contains a list of common network problems and how to resolve them.

#### How to make sure the ethernet adapter appears as eth0

In some cases, it is possible for the ethernet adapter to appear as eth1, not eth0 which can cause a lot of head bashing. For example, this can happen when sharing a single SD card between multiple BeagleBones.
- for more info see http://eewiki.net/display/linuxonarm/BeagleBone+Black#BeagleBoneBlack-Networking

- to always enable the Ethernet interface as eth0, do the following:
`$ sudo nano /etc/udev/rules.d/70-persistent-net.rules`  
- add the following lines
```
/etc/udev/rules.d/70-persistent-net.rules
# BeagleBone: net device ()
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{dev_id}=="0x0", ATTR{type}=="1", KERNEL=="eth*", NAME="eth0"
```

### Links and Further Reading

- guide here: http://elinux.org/RPi_Setting_up_a_static_IP_in_Debian
- and here: http://www.howtogeek.com/howto/ubuntu/change-ubuntu-server-from-dhcp-to-a-static-ip-address/



