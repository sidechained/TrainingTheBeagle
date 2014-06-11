## Networking

This document covers basic network configuration and troubleshooting on the Beaglebone Black, focussing particular on

* editing the debian /etc/network/interfaces file

* taking control of the beaglebone using ssh (including passwordless login)

It is assumed that you are editing the interfaces file on the beaglebone itself (i.e. by connecting via ssh over ethernet). Another approach is to insert the sd card into your pc, and edit the interfaces file from the rootfs partition (sometimes necessary if you get locked out of the beaglebone itself)

remotely access your beaglebone from the command line using SSH
It currently covers 

You will need to know the IP of your beaglebone before starting

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

## Using SSH - Troubleshooting Guide

1. "WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!"

- if this message comes up, it usually means that you have switched to accessing another beaglebone which has the same IP address as the previous one
- this can also happen when switching to a new SD card using the same beaglebone (effectively the same thing)
- to resolve this, we need to remove our local reference to the, as follows (where 192.168.2.14 is the IP of your beaglebone)
$ ssh-keygen -R 192.168.2.14
- you should see:
/Users/grahambooth/.ssh/known_hosts updated.
Original contents retained as /Users/grahambooth/.ssh/known_hosts.old
- now login again and it should work

* TUTORIAL: Passwordless login

- logging into the beaglebone the traditional way (i.e. $ ssh debian@192.168.x.x) requires a password, which can become tedious to enter
- a passwordless approach involves generating a secure SSH public key on the device that connects to the beaglebone (the host)
- this key is then copied onto the beaglebone itself, the host becomes "trusted" and the password is no longer needed to gain access

* Generating a public SSH key on the host (i.e. a laptop)

- go into the hosts home directory
$ cd ~/
- check if an .ssh directory already exists
$ ls -al
- if not then create one (if there is then check if there is a id_rsa.pub
$ mkdir .ssh
- now go into the .ssh directory
$ cd .ssh
- invoke the command to generate the public key:
$ ssh-keygen -t rsa -C "yourname@yourdomain.ext"
or
$ ssh-keygen -b 1024 -t rsa -f id_rsa -P ""
- NOTE: choose the best of the above two approaches
- press enter when prompted for a file in which to save the key
- press enter when asked for a passphrase (no passphrase means no password is required on login)

* Copying the public key from the laptop to the beaglebone

- go into the local ssh directory, if you are not there already
$ cd ~/.ssh
-  
$ cat id_rsa.pub
- copy the response into the clipboard
- log into the beagle as normal (entering the password)
$ ssh debian@192.168.2.14
- cd into the home directory
$ /debian/home/
- create 

- go into the laptop's home directory
$ cd ~/
- check if an .ssh directory already exists
$ ls -al
- if not then create one (if there is then check if there is a id_rsa.pub
$ mkdir .ssh
- now go into the .ssh directory
$ cd .ssh
- check if an 'authorized_keys' file exists
$ ls -a
- if not, create one
$ touch authorized_keys
- edit the 'authorized_keys' file
$ nano authorized_keys
- paste the context of the clipboard onto a new line at the bottom of the file, then use CTRL+X to exit, choosing Y when prompted whether to save
- log out of the beaglebone 
$ exit
- log back in again, and no password should be required
$ ssh debian@192.168.2.14

Troubleshooting

- Here are a couple of common problems and ways to fix them:

1. Public key (on the host) does not feature within authorized_keys (on the beaglebone)

- many problems can stem from this mismatch
- to double check, view the public key of the host, as follows:
$ cat ~/.ssh/id_dsa.pub
- now remove the sd card from the beaglebone, mount it on your laptop, then:
$ cat /Volumes/rootfs/home/debian/.ssh/authorized_keys
- check to see if any item within authorized_keys matches the host public key
- using this knowledge it should be possible to regain entry to the beaglebone and re-add the host's public key to beagle bone's authorized_keys as above

2. Inaccurate known_hosts file on the host machine

- the known_hosts file on the host machine may contain the wrong key for the beaglebone
- (this has happened to me in the past, not sure why exactly)
- edit the host machine's known_hosts file:
$ sudo nano ~/.ssh/known_hosts
- look for the line which matches the IP of the beaglebone you are trying to connect to e.g. line beginning 192.168.2.14 
- cut the line from the CTRL+K. then exit using CTRL+X, choosing Y when prompted whether to save
- attempt to access the beaglebone again via ssh e.g.
$ ssh debian@192.168.2.14
- login should now be possible