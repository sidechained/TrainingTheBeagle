## Installation

This document explains how to install an operating system and some other important software on your Beaglebone Black.

The aim is to install the following essentials for hybrid audio + physical computing projects:

* debian (operating system)
* jack (for audio)
* supercollider (programming language for audio synthesis)
* adafruit BBIO library (python library for interfacing with the beaglebone pin-ins/outs)
* pyOSC (python library for communicating via the Open Sound Control protocol)

Debian will be installed on the SD card from a PC, whilst the other software will be installed from the command line by booting the SD card in the beaglebone and logging in to it remotely via SSH. As each stage is relatively complex and time-consuming, you may wish to backup your SD card along the way...for more on this see [the backup tutorial](https://github.com/sidechained/TrainingTheBeagle/blob/master/Tutorials/_essential/backup.md).

### Requirements

You will need:

* a laptop capable of running a unix terminal (i.e. mac/linux)
* a beaglebone black
* a 4GB SD card (minimum)
* a micro to normal size SD card convertor (to insert the SD card into your computer)
* a simple USB sound card for your beaglebone (for audio testing)
* an ethernet connection to your Beaglebone Black (ethernet cable, switch or wireless router) 
* a working internet connection on the Beaglebone Black (see separate tutorial on internet access [here](http://www.TODO.com))

#### SSH Basics

compare with: https://github.com/redFrik/udk10-Embedded_Systems/tree/master/udk131114#--logging-in

* connect your beaglebone via ethernet
* ping the beagle board to see if it exists
`$ ping 192.168.2.14`
* you should see:
```
PING 192.168.2.14 (192.168.2.14): 56 data bytes
64 bytes from 192.168.2.14: icmp_seq=0 ttl=64 time=0.702 ms
64 bytes from 192.168.2.14: icmp_seq=1 ttl=64 time=0.543 ms
64 bytes from 192.168.2.14: icmp_seq=2 ttl=64 time=0.543 ms
```
* now, attempt to login
`$ ssh debian@192.168.2.14`
* enter password (by default: debian)
* if successful, the debian login message should appear as follows:
```Linux debian-armhf 3.8.13-bone30 #1 SMP Thu Nov 14 02:59:07 UTC 2013 armv7l

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Sat Jan  1 00:01:02 2000 from 192.168.2.21
```
* to exit, simply...
`$ exit`

### Installing Debian

https://github.com/redFrik/udk11-Portable_sonification_projects/tree/master/udk140515#installing-debian-linux
https://github.com/redFrik/udk11-Portable_sonification_projects/tree/master/udk140515#starting-for-the-first-time
https://github.com/redFrik/udk10-Embedded_Systems/tree/master/udk131114#--preparation-first-time-only (debian)

### Installing ALSA

https://github.com/redFrik/udk10-Embedded_Systems/tree/master/udk131121#--install-alsa--test-sound

### Installing Jack

https://github.com/redFrik/udk10-Embedded_Systems/tree/master/udk131121#--install-jack

### Installing SuperCollider

https://github.com/redFrik/udk10-Embedded_Systems/tree/master/udk131121#--install-supercollider-37alpha0

* installing Jack and Supercollider are the basic requirements for the Beaglebone to run audio
* Fredrik Olofsson has produced excellent tutorials on this, which we will not attempt to reproduce here

https://github.com/redFrik/udk10-Embedded_Systems/tree/master/udk131121#--start-sc
https://github.com/redFrik/udk10-Embedded_Systems/tree/master/udk131121#--get-low-latency-audio
https://github.com/redFrik/udk10-Embedded_Systems/tree/master/udk131121#--loading-files

#### Installing the Adafruit BBIO Library

compare with: https://github.com/redFrik/udk10-Embedded_Systems/tree/master/udk131114#--installing-software (python, bbio)

##### Overview

* the Adafruit BBIO Library is one of a number of libraries written to interface with the beaglebone pin headers
* for more info see: https://github.com/adafruit/adafruit-beaglebone-io-python
* Other libraries include [PyBBIO](http://beagleboard.org/project/PyBBIO/) ([and here](https://github.com/alexanderhiam/PyBBIO/wiki)) and [Bonescript](http://beagleboard.org/project/bonescript/) (on Angstrom, using node.js)
* according to this, Adafruit is the best: http://petebachant.me/stepper-motor-control-with-the-beaglebone-black-and-python/

##### Installation

* This tutorial is (heavily) modified from the Angstrom or Ubuntu version found at:
https://learn.adafruit.com/setting-up-io-python-library-on-beaglebone-black/overview

* NOTE: requires internet connection, which you should have if you completed the debian, jack + supercollider installation above

* ssh into the beaglebone black
`$ ssh debian@192.168.2.14`
* make sure the beagle has the correct date and time
`$ sudo ntpdate pool.ntp.org`
* make sure your debian packages are up to date
`$ sudo apt-get update`
* install python-pip package and dependecies
`$ sudo apt-get install build-essential python-dev python-pip -y`
* cd to an appropriate folder to temporarily clone a git repo to e.g.
`$ cd /home/debian`
* clone the adafruit BBIO library to this location
`$ git clone git://github.com/adafruit/adafruit-beaglebone-io-python.git`
`$ cd adafruit-beaglebone-io-python`
`$ sudo python setup.py install`
* remove the cloned git repo
`$ cd ..`
`$ sudo rm -rf adafruit-beaglebone-io-python`

* for more details and to troubleshoot any problems see:
https://pypi.python.org/pypi/Adafruit_BBIO
https://github.com/adafruit/adafruit-beaglebone-io-python/issues/12

##### Checking Installation

a. Quick Check

`$ python -c "import Adafruit_BBIO.GPIO as GPIO; print GPIO"`
* you should see this or similar
`<module 'Adafruit_BBIO.GPIO' from '/usr/local/lib/python2.7/dist-packages/Adafruit_BBIO/GPIO.so'>`

b. Real-World Check

* wire up a basic LED circuit, as here: http://learn.adafruit.com/blinking-an-led-with-beaglebone-black
* start the python interpreter
`$ sudo python`
* import bbio library
`>>> import Adafruit_BBIO.GPIO as GPIO`
* setup a pin as an output:
`>>> GPIO.setup("P8_10", GPIO.OUT)`
* turn LED On:
`>>> GPIO.output("P8_10", GPIO.HIGH)`
* turn LED Off:
`>>> GPIO.output("P8_10", GPIO.LOW)`
* exit python
`>>> exit()`

#### Installing the Python pyOSC Library

* compare with https://github.com/redFrik/udk10-Embedded_Systems/tree/master/udk131114#--installing-software (python, bbio)

##### Optional Section

* NOTE: this section can be skipped if you already performed these commands in the Adafruit BBIO library installation (see above)

* ssh into the beaglebone black
$ ssh debian@192.168.2.14
* make sure the beagle has the correct date and time
$ sudo ntpdate pool.ntp.org
* make sure your debian packages are up to date
$ sudo apt-get update
* install python-pip package and dependecies
$ sudo apt-get install build-essential python-dev python-pip -y

##### Required Section

* download an archive from here: https://trac.v2.nl/attachment/wiki/pyOSC/pyOSC-0.3.5b-5294.tar.gz
* copy the tar.gz file onto the beagleboard using scp
$ scp /path debian@192.168.2.14 :/home/Debian
* ssh in and untar the file
$ ssh debian@192.168.2.14
$ cd /home/debian
$ tar -xf pyOSC-0.3.5b-5294.tar.gz
* install pyosc
$ cd pyOSC-0.3.5b-5294
NOTE TO SELF: check the above line 
$ sudo python setup.py install
* remove the source code and zip
$ cd ..
$ rm -r pyOSC-0.3.5b-5294 
$ rm pyOSC-0.3.5b-5294.tar.gz

#### Backing Up the SD Card

Now you're done, consider [backing up the SD card](https://github.com/sidechained/TrainingTheBeagle/blob/master/Tutorials/_essential/backup.md)

### Troubleshooting

This section covers some things that can wrong during the above install process and how to solve them:

#### "cc1plus: error: unrecognized command line option '-std=c++11'" when building supercollider from source

* can occur when doing $ sudo make install
* newer kernels seem to include old version of g++, which cmake doesn’t like
* solution is:
$ sudo apt-get install g++-4.7
$ cmake -L -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF -DSSE=OFF -DSSE2=OFF -DSUPERNOVA=OFF -DNOVA_SIMD=OFF -DSC_QT=OFF -DSC_WII=OFF -DSC_ED=OFF -DSC_IDE=OFF -DSC_EL=ON -DCMAKE_CXX_COMPILER=g++-4.7 -DSEQAN_C++11_STANDARD=ON ..

NOTE: Debian has the package under the name gcc-4.8 (or for the c++ compiler, g++-4.8)
NOTE: Installing those packages will not mess up your OS, as long as you do not rename it to g++.

#### PWM Not Working in Adafruit Library

* this is down to an issue in the kernel, ideally need to update to bone24 or higher
* fixed it by following instructions here to flash sd card wtih debian 7.1 + bone24 : http://elinux.org/BeagleBoardDebian
also useful: http://elinux.org/BeagleBone
* related links here:
https://github.com/adafruit/adafruit-beaglebone-io-python/issues/22
https://github.com/adafruit/adafruit-beaglebone-io-python/issues/23
https://github.com/adafruit/adafruit-beaglebone-io-python/issues/6
http://www.armhf.com/index.php/boards/beaglebone-black/
http://eewiki.net/display/linuxonarm/BeagleBone+Black

### Links

* a simplified [here](http://supercollider.github.io/development/building-beagleboneblack.html)
* some discussion on the install process can be found [here](http://new-supercollider-mailing-lists-forums-use-these.2681727.n2.nabble.com/supercollider-on-Beaglebone-Black-td7599684.html)
* comprehensive tutorial: https://learn.adafruit.com/setting-up-io-python-library-on-beaglebone-black/using-the-bbio-library
* a quicker overview: https://pypi.python.org/pypi/Adafruit_BBIO
* below is a selection from the many well written tutorials for the adafruit BBIO library:
http://learn.adafruit.com/blinking-an-led-with-beaglebone-black
http://learn.adafruit.com/connecting-a-push-button-to-beaglebone-black
http://learn.adafruit.com/measuring-temperature-with-a-beaglebone-black