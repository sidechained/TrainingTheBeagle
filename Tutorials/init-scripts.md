\TODO/
> could rename this tutorial to something more intuitive like 'automatic-startup'
> this file needs a little bit of work, but is mostly complete
> the 'long tutorial' belongs in the soundvase project, really
> need to preface the long tutorial below with a super-simple initscript no sound, perhaps just print some numbers to a file for testing

# TUTORIAL: Creating Initialisation Scripts on the Beaglebone Black

- this tutorial covers how to get the beaglebone black to (i.e. Debian) run software on startup
- embedded systems

- if using Extensions, be sure to host them in '/usr/local/share/SuperCollider/Extensions' NOT '/home/debian/.local/share/SuperCollider/Extensions' (as this folder is not in the search path when sclang runs as an initScript)
- PWM is problematic on startup

- useful link 1: Making scripts run at boot time with Debian: http://www.debian-administration.org/articles/28
- useful link 2: http://www.debianhelp.co.uk/initscripts.htm

* Short Tutorial

\TODO/

* Long Tutorial

- the aim of this tutorial is to show how to run audio and sensing processes at startup on the beaglebone black
- by audio processes we mean: jackd + sclang + scsynth
- by sensing processes we mean: python (using the Adafruit BBIO library)
- also, we will send messages from python to sclang using Open Sound Control (using the pyOSC library for python, build in OSC functionality of SuperCollider)

** Prerequisites:

you will need:
- a beaglebone black
- a USB audio sound card, similar to this: http://www.dhgate.com/product/usb-3d-sound-card-usb-2-0-to-3d-audio-sound/151239248.html
- headphones or a speaker with a 3.5mm minijack
- a photoresistor (aka light-dependant resistor or LDR)
- a 10K resistor
- a breadboard
- some jumper cables

1. install debian wheezy, jack, supercollider on the beagle board by following Fredrik Olofsson's excellent tutorial here: http://supercollider.github.io/development/building-beagleboneblack.html
NOTE: this tutorial was tested using the 'debian-wheezy-7.2-armhf-3.8.13-bone30.img.xz' (November 23, 2013), found at http://www.armhf.com/index.php/download/

2. install pyOSC
- download from here: https://trac.v2.nl/attachment/wiki/pyOSC/pyOSC-0.3.5b-5294.tar.gz
- copy the tar.gz file onto the beagleboard
$ scp /path debian@x.x.x.x :/home/Debian
- ssh in and untar the file
$ ssh debian@x.x.x.x
$ cd /home/debian
$ tar -xf pyOSC-0.3.5b-5294.tar.gz
- install pyosc
$ cd pyOSC-0.3.5b-5294 (CHECK)
$ sudo python setup.py install
- remove the source code and zip
$ cd ..
$ rm -r pyOSC-0.3.5b-5294 
$ rm pyOSC-0.3.5b-5294.tar.gz

3. Create a simple Python script for sensing light

- setup a simple light sensing circuit on your beagle board, by following the tutorial described here: http://learn.adafruit.com/measuring-light-with-a-beaglebone-black/
- NOTE: this also covers how to install the Adafruit BBIO library

- simple example of a python script which will repeatedly poll a light dependant resistor and send this value to SuperCollider for sonification
$ mkdir /home/debian/initScriptTest
$ nano python initScriptTest2.py
- paste in the example code below, use CMD+X to exit, answering Y to save when prompted
- now do a test run of the script
$ sudo python initScriptTest2.py
- look for changing values as you expose the LDR to more light

import OSC
from OSC import OSCClient, OSCMessage
import threading
from threading import Timer
import Adafruit_BBIO.ADC as ADC

sendAddress = '127.0.0.1', 57120 # localhost, supercollider default port
sensingPollRate = 0.05 # 0.05 = 20ms

def init_sensing_loop():
        Timer(sensingPollRate, sense_and_send_values).start()

def sense_and_send_values():
        sensedValue = ADC.read("P9_40")
        msg = OSC.OSCMessage()
        msg.setAddress('/light')
        msg.append(sensedValue)
        print "sending locally to supercollider: '{0}', '{1}'".format(msg, client)
        try:
                client.send ( msg )
        except:
                print "waiting for supercollider to become available"
                pass
        init_sensing_loop() # recursive call, keeps timer goingR

# main:
ADC.setup("P9_33")
client = OSCClient()
client.connect( sendAddress )
init_sensing_loop()

try:
     while True:
         time.sleep(1)

4. Create a simple SuperCollider patch for generating sound

- change the frequency of a sine wave in response to light from the LDR

- firstly, let's create our example SuperCollider patch, which will respond to messages sent from the python script we created earlier
$ sudo nano /home/debian/initScriptTest/initScriptExample2.scd
- paste in the example code below, use CMD+X to exit, answering Y to save when prompted

- we can now test this patch alongside our previously created python script
- firstly start up jack, as follows
- NOTE: the '&' here ensures it will run asynchronously in a separate process
$ jackd -dalsa -dhw:1,0 -p256 -n3 -s &
- now start our SuperCollider patch
NOTE: don't call sudo when running this command, as the audio user group will not be found
$ sclang /home/debian/initScriptTest/initScriptExample2.scd
- now run our python script as follows
$ sudo python initScriptTest2.py &

- all is well if you hear the frequency change in response to light changes at the LDR

* NOTE: if the messages are two confusing, ssh into the beaglebone in two separate terminal windows and run jack and sclang in one, python in the other
* NOTE: if you make mistakes in the above setup, you need to watch out for rogue processes 
* NOTE: python hogs ports

(i.e. which might hog the default supercollider port (57120), or hog ). To get back to a clean slate, try:

$ pkill python
$ pkill sclang
$ pkill jackd

(
s.waitForBoot({ // boot the server then do something
        var synth;
        SynthDef("lightFreq", { arg shift = 0.5; Out.ar([0, 1], SinOsc.ar(shift.linexp(0, 1, 440, 880)) }).add; // s
        s.sync; // wait for the synthDef to be loaded before continuing
        synth = Synth("lightFreq");
        OSCFunc({arg msg; // listen to messages from Python
                var ldrValue;
                ldrValue = msg[1];
                msg.postln;
                synth.set(\light, ldrValue);
        }, '/light');

})
)

5. Create a 'daemon' 

- next we need to create a bash script that will run the test from stage 4 for us automatically in a background process
- our script will run jack, supercollider and python and log its output to a file

- create a blank document
$ nano /home/debian/initScript/initScriptExample2
- paste in the example code below, use CMD+X to exit, answering Y to save when prompted
(note that the python process does not need to be run in parallel as it)
(NOTE TO SELF: this would be better done synchronously, if possible)

- now we can test the script as follows (make sure you have killed all existing processes as described above)
$ sh /home/debian/initScript/initScriptExample2

#!/bin/sh
sudo exec > /tmp/vase.txt 2>&1
echo $(date)
echo "running sclang postbootscript..."
echo "starting jack..."
jackd -dalsa -dhw:1,0 -p512 -n3 -s &
sleep 4
each "start supercollider..."
sclang /home/debian/initScript/initScriptExample2.scd &
sleep 4
echo "starting python..."
sudo python /home/debian/initScript/initScriptExample2.py

6. Example initscript (header only):

- go to the folder where initscripts are found
$ cd /etc/init.d
- copy the example skeleton file, giving it a new filename
$ sudo cp skeleton to initScriptExample2
- edit the new file
$ sudo nano initScriptExample2
- replace the 'before modification' lines with the corresponding 'after modification' lines below
- use CMD+X to exit, answering Y to save when prompted
- register the initscript so that it will be called on boot, as follows
$ sudo /usr/sbin/update-rc.d vaseBoot defaults
- NOTE: defaults mean we use the LSB header from our modified skeleton file (i.e. the # Required-Start, # Required-Stop, # Default-Start and # Default-Stop fields)
- to check for success, execute the following command and look for 'initScriptExample2' in the list (with a number prepended to it)
$ ls /etc/rc*.d
- NOTE: this is the list of run levels, of which I think we are only using run level 2 (i.e. rc2.d) with headless debian
- now reboot the system to 
$ sudo reboot
- the should run automatically, and you should still be able to ssh into the beagle board as normal

- NOTE: the script can be removed at any time using $ sudo /usr/sbin/update-rc.d vaseBoot remove

Before modification:

#! /bin/sh
### BEGIN INIT INFO
# Provides:          skeleton
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Example initscript
# Description:       This file should be used to construct scripts to be
#                    placed in /etc/init.d.
### END INIT INFO

# Author: Foo Bar <foobar@baz.org>
#
# Please remove the "Author" lines above and replace them
# with your own name if you copy and modify this script.

# Do NOT "set -e"

# PATH should only include /usr/* if it runs after the mountnfs.sh script
PATH=/sbin:/usr/sbin:/bin:/usr/bin
DESC="Description of the service"
NAME=daemonexecutablename
DAEMON=/usr/sbin/$NAME
DAEMON_ARGS="--options args"
PIDFILE=/var/run/$NAME.pid
SCRIPTNAME=/etc/init.d/$NAME

After modification:

#! /bin/sh
### BEGIN INIT INFO
# Provides:          initScriptExample2
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Example initscript for sound and sensing
# Description:       Example of an initscript which runs jack, supercollider and python processes
### END INIT INFO

# Author: Graham Booth

# Do NOT "set -e"

# PATH should only include /usr/* if it runs after the mountnfs.sh script
PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/bin:/home/debian/initScript
DESC="Description of the service"
NAME=daemonexecutablename
DAEMON=/home/debian/initScript/$NAME
DAEMON_ARGS="--options args"
PIDFILE=/var/run/$NAME.pid
SCRIPTNAME=/etc/init.d/$NAME