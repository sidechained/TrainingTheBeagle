add section on internet connection sharing
add section on 'find' to unix lore

## Networking

This document covers basic network configuration and troubleshooting on the Beaglebone Black, focussing on the following topics:

[TOPIC LIST HERE]

### Networking Basics

Once you have identified or reconfigured the IP of your Beaglebone

If you are having trouble logging in your beaglebone because you don't know its IP, see [this section]() first.

Default username and password is debian/debian

#### Ping

Ping is the basic command we perform to see if our is Beagleboard is alive on the network at a specified address
typically before trying to connect

`$ ping 192.168.2.14`

#### SSH

Logging in via ssh is the way we securely connect to the Beaglebone in order to control it remotely. In the absence of a dedicated monitor and keyboard for the Beaglebone Black, this is the primary way we can interact with our Beaglebone.

`$ ssh debian@192.168.2.14`
- you will be prompted to enter your password (unless you have configured ssh keys for [passwordless login]()

#### ipconfig

ipconfig

#### default Debian networking

It is worth taking a look at the /etc/network/interfaces file

`$ sudo nano /etc/network/interfaces`

```
# interfaces(5) file used by ifup(8) and ifdown(8)

# loopback network interface
auto lo
iface lo inet loopback

# primary network interface
auto eth0
iface eth0 inet dhcp
#hwaddress ether DE:AD:BE:EF:CA:FE

# wireless network interface
#auto wlan0
#iface wlan0 inet dhcp
#   wpa-ssid "my_wifi_name"
#   wpa-psk  "my_wifi_pass"
```

Note that there are two basic interfaces in use, a 'loopback network interface' and a 'primary network interface'. 

Note that the primary network interfaces is currently configured under the name 'eth0' and in 'dhcp' mode (i.e.

static)

Finally, note the commented out lines (preceded by #) which show how to use a wireless network interface.

### Editing the Network Configuration File

This section covers making various types of changes to the /etc/network/interfaces file.

Before proceeeding, we recommend making a backup of the existing file, 

* log in
`$ ssh debian@192.168.2.14`
* copy the interfaces file to
`$ sudo cp /etc/network/interfaces /etc/network/interfaces.bak`

_NOTE: It is assumed that you are editing the interfaces file on the beaglebone itself (i.e. by connecting via ssh over ethernet). To edit from a laptop, the process is basically the same and is detailed [here](link to section 1)_

#### 0. DHCP

In the Debian ARMHF image, DHCP is enabled as the default primary networking configuration.

Q: How does the Beagle work in DHCP mode, does it act as an DHCP server, allocating the laptop an IP address in a given range, or does it allow itself to be given an IP by other DHCP servers on the network. If the latter, then how do we found out (i.e. from the server machine) what IP it has been given?

To enable DHCP on your Beaglebone, your /etc/network/interfaces files should include a section that looks as follows:

<<<<<<< HEAD
```
# primary network interface
auto eth0
iface eth0 inet dhcp
#hwaddress ether DE:AD:BE:EF:CA:FE
```


- is there an easy way work with the beagle over DHCP and know what IP it has been allocated?
- according to http://www.armhf.com/index.php/getting-started-with-ubuntu-img-file/ Wheezy runs a DHCP server by default
- suggestion is: Try pinging it by name: "debian-armhf" for the debian images and "ubuntu-armhf" for the ubuntu images. It is setup for DHCP, so whatever your network handed out. You could mount partition 2 of the SD card and check the logs or edit the /etc/network/interfaces file to have a static IP address:



#### 1. Static IP

This is the most likely configuration, as it gives our Beaglebone a single fixed address

avoids confusion.

* edit the interfaces file (having made a backup, as described above)
`$ sudo nano /etc/network/interfaces`
* replace the following line...
```
iface eth0 inet dhcp
```
* …with the following lines (replacing)
NOTE - if you want to use a base address other than '192.168.1', replace this in the address, network, broadcast and gateway lines

=======
- on Debian, DHCP is enabled by default
- using DHCP is often an issue
- to change this we need to edit /etc/network/interfaces
- firstly, log in
`$ ssh debian@192.168.1.3`
- now make a backup of the interfaces file (in case of emergency)
`$ sudo cp /etc/network/interfaces /etc/network/interfaces.bak`
- edit the original version
`$ sudo nano /etc/network/interfaces`
- replace the following...
`iface eth0 inet dhcp`
- with… (example for IP of 192.168.1.3)
```
>>>>>>> 95f21aba981964ea7ead293a3f106ba76a5ae866
iface eth0 inet static
       address 192.168.1.x
       netmask 255.255.255.0
       network 192.168.1.0
       broadcast 192.168.1.255
       gateway 192.168.1.1
<<<<<<< HEAD

* restart networking (this saves us from having to reboot)
`$ sudo /etc/init.d/networking restart`  
`$ sudo /etc/init.d/networking reload`
* log out of the beaglebone
`$ exit`
* Attempt to log back in using the new address (replacing x with the 
`$ ssh debian@192.168.1.x`
* If log in fails, first try rebooting the board using the onboard reset button
* If you still have problems logging in, consult the [finding my IP section]() of this document in order to regain access
=======
```
- restart networking  
`$ sudo /etc/init.d/networking restart` 
`$ sudo /etc/init.d/networking reload`
>>>>>>> 95f21aba981964ea7ead293a3f106ba76a5ae866

#### 2. USB-To-Ethernet

In the absence of ethernet hardware (i.e. cables and/or an ethernet switch), it can be convenient to use the Beaglebone's built-in USB-To-Ethernet functionality (as provided by the onboard microcontroller), which allows us to ssh in simply by connecting the beaglebone to a laptop via a Standard to Mini USB Cable. Another advantage of this approach is that is it often simpler to share your pc's internet connection this way than via traditional ethernet (see [here](http://robotic-controls.com/learn/beaglebone/beaglebone-internet-over-usb-only) and [here](http://askubuntu.com/questions/380810/internet-over-usb-on-beaglebone-black)).

<<<<<<< HEAD
_NOTE: For the ultimate in convenience, it is tempting to use this USB connection to power the Beaglebone as well, but the maximum 0.5A output of most laptops USB ports is not enough to reliably write to the. Therefore it is essential to bolster this by using an appropriately rated (i.e. 5V2A) external power supply (such as [this one]).

Under Angstrom Linux, USB-To-Ethernet forms part of the default networking configuration, where the Beaglebone uses the address 192.168.7.2 and the pc uses the address 192.168.7.1. In what followsm we will attempt to recreate this functionality within Debian.

Here we - in addition to (rather than instead of) our primary network interface.

```
# usb-to-ethernet
ifconfig usb0 192.168.7.2
route add default gw 192.168.7.1
```

Q: What is the state of play on USB-to-Ethernet is the current ARM debian image?

### Identifying the IP Address of Your Beaglebone

When trying to log into the Beaglebone for the first time, we are faced with a catch 22 situation. To know what kind of network configuration is in already in use, we ideally need to consult the /etc/network/interfaces file on the Beaglebone itself. The typical way to access this file would be by logging into the Beaglebone via ssh and taking a look, but to do this we need to know the IP address being used by the Beaglebone itself. There are a number of possible ways to overcome this problem, you may find one preferable to the others depending on what networking hardware you have to hand and what operating system you are using.

#### 1. Inspecting/Editing the /etc/network/interfaces File on Your PC

If you are booting your Beaglebone from a micro SD card, then the easiest way to find out what kind of networking configuration is in use is to mount the SD card on your pc and take a look at the /etc/network/interfaces file from there. 

##### Under Linux
=======
_is there an easy way work with the beagle over DHCP and know what IP it has been allocated?_
- according to http://www.armhf.com/index.php/getting-started-with-ubuntu-img-file/ Wheezy runs a DHCP server by default
- suggestion is: Try pinging it by name: "debian-armhf" for the debian images and "ubuntu-armhf" for the ubuntu images. It is setup for DHCP, so whatever your network handed out. You could mount partition 2 of the SD card and check the logs or edit the /etc/network/interfaces file to have a static IP address:
>>>>>>> 95f21aba981964ea7ead293a3f106ba76a5ae866

For Linux users opening and edited
this is easy, as the file system of the Beaglebone's SD card is also Linux based (Q: EXT3?), so the /etc/network/interfaces file can be opened and edited in whatever method your flavour of Linux allows (i.e. via text editor, or via the  terminal using nano)

##### Under OSX

For Mac users the process is little more tricky, as some extensions are required to be able to natively read the Linux file system under OSX. There are two options here

1. Perhaps the best way around this - but also the most long-winded - is to install a Linux virtual machine such as [VirtualBox](https://www.virtualbox.org). This is preferable as it will also allow you to edit the 'interfaces' file not just read it.  However, if read-only access is required, an easier way to look at the 

directly in Finder

2. Install [OSXFuse](http://osxfuse.github.io). OSXFuse is a successor to the no longer maintained [MacFuse](http://code.google.com/p/macfuse/) project, and the OSXFuse installation guide can be found [here]().

#### 2. Peform a Scan

\TODO/

If you know your Beaglebone has been given a static IP address, but you don't know what this IP address you could perform a scan of.
_UNDER DEVELOPMENT_
Use `nmap` and `grep` are useful to quickly scan networks.

To install nmap, enter `$ sudo apt-get install nmap`. 
Once it is installed, enter `$ nmap -sP 192.168.2.0/24`  (put your subnet IP range here, we use ..2.xxx)
Which returns something like: 
```
Nmap scan report for easy.box (192.168.2.1)
Host is up (0.025s latency).
Nmap scan report for localhost (192.168.2.14)
Host is up (0.0011s latency).
Nmap scan report for localhost (192.168.2.103)
Host is up (0.089s latency).
Nmap scan report for localhost (192.168.2.119)
Host is up (0.14s latency).
Nmap scan report for localhost (192.168.2.200)
Host is up (0.0047s latency).
Nmap scan report for localhost (192.168.2.222)
Host is up (0.0086s latency).
```
or this: ?
`$ nmap -sP $(ip -o addr show | grep inet\  | grep eth | cut -d\  -f 7)`



### Enabling SSH Passwordless Login

Logging into the beaglebone the traditional way (i.e. using `$ ssh debian@192.168.x.x`) requires a password, which can become tedious to enter. The following tutorial demonstrates a passwordless approach, which involves generating a secure SSH public key on the device that connects to the beaglebone (the host). This key is then copied onto the beaglebone itself, the host becomes "trusted" and the password is no longer needed in order to gain access. 

#### Generating a public SSH key on the host (i.e. a laptop)

* Go into the home directory of the host pc
`$ cd ~/`
* Check if an .ssh directory already exists in this location
`$ ls -al`
* If not then create one, and go into it
`$ mkdir .ssh`
`$ cd .ssh`
_NOTE: if the .ssh did exist previously, check if there is a id_rsa.pub inside, if so you may skip to the [next section](#copying-the-public-key-from-the-laptop-to-the-beaglebone)_
* Generate the public key
`$ ssh-keygen -b 1024 -t rsa -f id_rsa -P ""`
* Press enter when prompted for a file in which to save the key
* Press enter when asked for a passphrase (no passphrase means no password is required on login)

#### Copying the public key from the laptop to the beaglebone

* Go into the local .ssh directory (if you are not there already)
`$ cd ~/.ssh`
* Display the public key:  
`$ cat id_rsa.pub`
* Copy the resulting text into the clipboard
* Now log into the beagle as normal (replacing 192.168.2.14 with the IP of your Beaglebone, and entering the password)
`$ ssh debian@192.168.2.14`
* On login you will be in the home directory. Check if an .ssh directory already exists here
`$ ls -al`
* If not then create one, and go into it
`$ mkdir .ssh`
`$ cd .ssh`
* Check if an 'authorized_keys' file exists there
`$ ls -a`
* If not, create and edit a new 'authorized_keys' file (if so just edit it, the following command is the same)
`$ nano authorized_keys`
* Paste the context of the clipboard onto a new line at the bottom of the file, then use CTRL+X to exit, choosing Y when prompted whether to save
* Log out of the beaglebone
`$ exit`
* Log back in again, and this time no password should be required
`$ ssh debian@192.168.2.14`

### Accessing the Beaglebone using a .local Address (i.e. beaglebone.local)

Giving the beaglebone a .local address can be helpful in that it means we no longer have to remember a specific IP address e.g. instead of `$ ssh debian@192.168.2.14` we can simply remember to do `$ ssh debian@beaglebone.local`. The following is a basic summary of the key points of this [guide](http://www.howtogeek.com/167190/how-and-why-to-assign-the-.local-domain-to-your-raspberry-pi/) to assigning a .local address on the Raspberry Pi. This is essentially the same process as on the Beaglebone Black.

According to [wikipedia](http://en.wikipedia.org/wiki/.local) .local addresses "are resolved either via the multicast domain name service (mDNS) and/or local Domain Name System (DNS) servers".

* The first step is to install avahi for zero-configuration networking (zeroconf), which is the Linux equivalent of bonjour on OSX). Avahi allows the beagle to announces its .local name via multicast DNS (mDNS). In turn, this is what allows a laptop to connect to it by name.

* Make sure your Debian installation is up to date:
`$ sudo apt-get update`
`$ sudo apt-get upgrade`
* Install avahi
`$ sudo apt-get install avahi-daemon`
* Edit the beaglebone's hostname (if you want a different name other than default of 'debian-armhf.local')
`$ sudo nano /etc/hosts`
* Edit the (last) entry labeled 127.0.1.1, changing 'debian-armhf' to the name of your choice (i.e. 'beaglebone') 
* Run a script to register the changes
`$ sudo /etc/init.d/hostname.sh`
* Reboot the Beaglebone
`$ sudo reboot`
* Ping the beaglebone using the .local address, after a short while the 
`$ ping beaglebone.local`
* Log back in using the .local address
`$ ssh beaglebone.local`

### Enabling a WIFI Dongle

\TODO/: __NEEDS TESTING__

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

### Further Reading

Setting Static IP on Angstrom using connman: http://derekmolloy.ie/set-ip-address-to-be-static-on-the-beaglebone-black/

http://www.mathworks.co.uk/help/simulink/ug/getting-the-beagleboard-ip-address.html
- guide here: http://elinux.org/RPi_Setting_up_a_static_IP_in_Debian
- and here: http://www.howtogeek.com/howto/ubuntu/change-ubuntu-server-from-dhcp-to-a-static-ip-address/

## Using SSH - Troubleshooting Guide

1. "WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!"

- if this message comes up, it usually means that you have switched to accessing another beaglebone which has the same IP address as the previous one
- this can also happen when switching to a new SD card using the same beaglebone (effectively the same thing)
- to resolve this, we need to remove our local reference to the, as follows (where 192.168.2.14 is the IP of your beaglebone)
`$ ssh-keygen -R 192.168.2.14`
- you should see:
`/Users/grahambooth/.ssh/known_hosts` updated.
Original contents retained as `/Users/grahambooth/.ssh/known_hosts.old`
- now login again and it should work

<<<<<<< HEAD
Troubleshooting
=======
###### TUTORIAL: Passwordless login

- logging into the beaglebone the traditional way (i.e. `$ ssh debian@192.168.x.x`) requires a password, which can become tedious to enter
- a passwordless approach involves generating a secure SSH public key on the device that connects to the beaglebone (the host)
- this key is then copied onto the beaglebone itself, the host becomes "trusted" and the password is no longer needed to gain access

* __Generating a public SSH key on the host (i.e. a laptop)__

- go into the hosts home directory
`$ cd ~/`
- check if an .ssh directory already exists
`$ ls -al`
- if not then create one (if there is then check if there is a id_rsa.pub
`$ mkdir .ssh`
- now go into the .ssh directory
`$ cd .ssh`
- invoke the command to generate the public key:
`$ ssh-keygen -t rsa -C "yourname@yourdomain.ext"`
__or__
`$ ssh-keygen -b 1024 -t rsa -f id_rsa -P ""`
_NOTE: choose the best of the above two approaches_
- press enter when prompted for a file in which to save the key
- press enter when asked for a passphrase (no passphrase means no password is required on login)

* __Copying the public key from the laptop to the beaglebone__

- go into the local ssh directory, if you are not there already
`$ cd ~/.ssh`
-  
`$ cat id_rsa.pub`
- copy the response into the clipboard
- log into the beagle as normal (entering the password)
`$ ssh debian@192.168.2.14`
- cd into the home directory
`$ /debian/home/`
- create 
_SOMETHING MISSING HERE?_
- go into the laptop's home directory
`$ cd ~/`
- check if an .ssh directory already exists
`$ ls -al`
- if not then create one (if there is then check if there is a id_rsa.pub
`$ mkdir .ssh`
- now go into the .ssh directory
`$ cd .ssh`
- check if an 'authorized_keys' file exists
`$ ls -a`
- if not, create one
`$ touch authorized_keys`
- edit the 'authorized_keys' file
`$ nano authorized_keys`
- paste the context of the clipboard onto a new line at the bottom of the file, then use CTRL+X to exit, choosing Y when prompted whether to save
- log out of the beaglebone 
`$ exit`
- log back in again, and no password should be required
`$ ssh debian@192.168.2.14`

##### Troubleshooting
>>>>>>> 95f21aba981964ea7ead293a3f106ba76a5ae866

- Here are a couple of common problems and ways to fix them:

1. Public key (on the host) does not feature within authorized_keys (on the beaglebone)

- many problems can stem from this mismatch
- to double check, view the public key of the host, as follows:
`$ cat ~/.ssh/id_dsa.pub`
- now remove the sd card from the beaglebone, mount it on your laptop, then:
`$ cat /Volumes/rootfs/home/debian/.ssh/authorized_keys`
- check to see if any item within authorized_keys matches the host public key
- using this knowledge it should be possible to regain entry to the beaglebone and re-add the host's public key to beagle bone's authorized_keys as above

2. Inaccurate known_hosts file on the host machine

- the known_hosts file on the host machine may contain the wrong key for the beaglebone
- (this has happened to me in the past, not sure why exactly)
- edit the host machine's known_hosts file:
`$ sudo nano ~/.ssh/known_hosts`
- look for the line which matches the IP of the beaglebone you are trying to connect to e.g. line beginning 192.168.2.14 
- cut the line from the CTRL+K. then exit using CTRL+X, choosing Y when prompted whether to save
- attempt to access the beaglebone again via ssh e.g.
`$ ssh debian@192.168.2.14`
- login should now be possible
