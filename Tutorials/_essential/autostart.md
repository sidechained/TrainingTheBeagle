## Creating Initialisation Scripts on the Beaglebone Black

This tutorial covers how to start audio and sensing processes automatically on boot using Debian on the Beaglebone Black. This is an important technique which makes it possible to develop embedded systems. We will use the (somewhat complex) 'update-rc.d' method, and will walk through two tutorials, a [bare minimum example](#bare-minimum-example-aka-the-short-version) - which explains the basic concepts - and a more typical [real world example](#real-world-example-aka-the-long-version) - which runs Python and SuperCollider code. Note that using 'update-rc.d' is not the only way to start processes on boot, for more detail on alternative approaches see the [further reading section](#further-reading) of this tutorial.

Before starting out, there are a couple of things to be aware of:

* If you are using Extensions, be sure to host them in '/usr/local/share/SuperCollider/Extensions' NOT '/home/debian/.local/share/SuperCollider/Extensions' (as this folder is not in the search path when sclang runs as an initScript)

* In our experience, using the Pulse Width Modulation (PWM) pins is problematic from a startup script. Therefore, if you rely on the PWM pins in your project, you may have to do some additional investigation into this issue.

###Bare Minimum Example (A.K.A The short version)

In this section we introduce a simple 'bare bones' version of the code that is required to initiate a process on startup. At this stage, the idea is simply to illustrate the principles, not do anything particularly exciting.

#### Step 1. Create a Simple Bash Shell Script (to be run on startup)

* Log into the Beaglebone (replacing 192.168.2.14 with the IP of your own beagle, and entering your password as prompted)  
`$ ssh debian@192.168.2.14`
* Make a folder on the Beaglebone (to contain the files we will create for this example), and go into it  
`$ mkdir simpleAutostartExample`  
`$ cd simpleAutostartExample`
* Create and edit a new file named simpleAutostart.sh  
`$ sudo nano simpleAutostart.sh`
* Paste in the following code
```bash
#!/bin/sh
sudo exec > /tmp/simpleAutostartLog.txt 2>&1
echo $(date)
echo "The startup script ran succesfully!"
```
* Exit and save using CTRL+X

NOTE: The script itself will simply log the date and the message "The startup script ran succesfully!" to a temporary file called simpleAutostartLog.txt, which lives in the Beaglebone's /tmp folder. Once the autostart procedure has been initiated, we will be able to log in and check the content of this file to see if the script worked or not.

#### Step 2. Create an Initialisation Script (from a template)

To run the above bash script automatically on boot, we need to call it from within a separate initialisation script. To do this we modify the header section of an existing template file, called 'skeleton', which is found in the /etc/init.d folder.

* Log into the Beaglebone (if you aren't logged in already)
* Go into the /etc/init.d folder where the 'skeleton' initscript template can be found  
`$ cd /etc/init.d`
* Copy the skeleton file to a new file named 'simpleAutostart'  
`$ cp skeleton simpleAutostart`  
_NOTE: check if this needs sudo_
* Edit the new file  
`$ sudo nano simpleAutostart`
* Make the following changes to the file: 

1. Add extra paths for `:/usr/local/bin` and `:/home/debian/simpleAutostartExample` to the PATH line. The line should now read as follows:  
`PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/bin:/home/debian/simpleAutostartExample`  
_NOTE_ is `:/usr/local/bin` really needed here as we are running no additional programs

2. Replace the default name in the NAME line with the name of our bash script. The line should now read:  
`NAME=simpleAutostart.sh`

3. Change the DAEMON line to point to the path where our bash script is found. The line should now read:  
`DAEMON=/home/debian/simpleAutostartExample/$NAME`

* Exit and save using CTRL+X

_NOTE_: Other 'cosmetic' changes can also be made, but are not essential (for example changing the 'Provides' section, the descriptions of what the script does, and the author).

#### Step 3. Tell the System to Run the Initialisation Script on Startup

* To tell the system to use the initialisation script on boot, we register the script with a program called update-rc.d, as follows  
`$ sudo /usr/sbin/update-rc.d simpleAutostart defaults`
* Now we are ready to reboot the Beaglebone to test if our script works  
`$ sudo reboot`
* Once the Beaglebone is up and running, ssh back in as normal (replacing 192.168.2.14 with the IP of your beagle)    
`$ ssh debian@192.168.2.14`
* Check the content of the log file  
`$ cat /tmp/simpleAutostartLog.txt`
* You should see a very recent time and date, followed by the message "The startup script ran succesfully!". If not please double check the changes you made above, and see the [troubleshooting section](#troubleshooting) for additional ideas on what might be going wrong.

#### Extending the Bash Shell Script

From this basic starting point you can experiment with changes to the bash shell script (simpleAutostart.sh) to do more than simply logging a message to a file. For more on how to run Python or SuperCollider code from the shell script, see the following section.

### Real World Example (A.K.A The long version)

_NOTE: this tutorial was tested using the 'debian-wheezy-7.2-armhf-3.8.13-bone30.img.xz' (November 23, 2013), found [here](http://www.armhf.com/index.php/download/)_

In contrast to the bare bones method, this section aims to show how to run actual audio and sensing processes on startup. More specifically, by audio processes we mean jackd + sclang + scsynth, and by sensing processes we mean python + the Adafruit BBIO library. In addition to these processes, we will send also messages from Python to sclang using Open Sound Control (using the pyOSC library for python, build in OSC functionality of SuperCollider). For more detail on this see the separate [OSC Communication Tutorial](./osc.md).

#### Prerequisites

To follow along, you will need:

* a beaglebone black running Debian (wheezy), jack, pyOSC and SuperCollider  
(if you have not yet installed these, see the separate [installation tutorial](./installation.md))
* a USB audio sound card, similar to the one shown [here](http://www.dhgate.com/product/usb-3d-sound-card-usb-2-0-to-3d-audio-sound/151239248.html)
* headphones or a speaker with a 3.5mm minijack input
* a photoresistor (aka light-dependant resistor or LDR)
* a 10K resistor
* a breadboard
* some jumper cables

#### Step 1. Create a Python Script to Read Values from a Photoresistor

Firstly, setup a simple light sensing circuit on your beagle board, by following the tutorial described [here](http://learn.adafruit.com/measuring-light-with-a-beaglebone-black/)  
_NOTE: this tutorial also covers how to install the Adafruit BBIO library_

Now we will use a simple Python script to repeatedly poll this light dependant resistor and send its value to SuperCollider for sonification. The script we will use is called autostart.py and can be viewed [here](./autostartExamples/autostart.py), and the steps we need to undertake as are as follows:

* Clone the TrainingTheBeagle repo to a convenient temporary location on your pc (i.e. ~/Desktop)  
`$ cd ~/Desktop`  
`$ git clone https://github.com/sidechained/TrainingTheBeagle.git`  
* Navigate to the tutorials folder, where the autostartExamples can be found  
`$ cd TrainingTheBeagle/Tutorials/`  
* Copy the autostartExamples folder into your beaglebone's home folder as follows (replacing 192.168.2.14 with the IP of your own beagle, and entering your password as prompted)  
`$ scp -r autostartExamples debian@192.168.2.14:/home/debian`
* Tidy up by removing the cloned repo from the desktop (or wherever you put it)  
`$ cd ..`  
`$ rm -r TrainingTheBeagle`
* Log into the beaglebone (again replacing 192.168.2.14 with the IP of your own beagle, and entering your password as prompted)  
`$ ssh debian@192.168.2.14`  
* Go into the newly copied autostartExamples folder, and run the Python script found there  
`$ cd autostartExamples`  
`$ sudo python autostart.py`
* Now look for changing values on the screen as you expose the LDR to more light. The following message should appear (followed by a number) each time the sensor is polled  
`sending locally to supercollider: /light` 
* If this works, we are ready to move on to generating some basic sounds with these values

#### Step 2. Receive Photoresistor Values in SuperCollider and Use Them to Make Sound

In this section we will use SuperCollider to change the frequency of a sine wave in response to values coming from our photoresistor (as sent by Python). The SuperCollider patch we will use is called autostart.scd and can be viewed [here](./autostartExamples/autostart.scd). This file is already on our Beaglebone (in the autostartExamples folder which we copied across using the 'scp' command in in the previous step). We will now test it alongside our previously created Python script, as follows:

* Firstly start up jack (to enable audio)  
`$ jackd -dalsa -dhw:1,0 -p256 -n3 -s &`  
_NOTE: the '&' here ensures that jack will run as a background process_
* Now let's start our SuperCollider patch. This presumes you are still in the autostartExamples folder (if not go there first)
`$ sclang autostart.scd &`  
* The server will boot (takes a few seconds)  
_\TODO/ Q: should this command use sudo?_
* Once this is up and running, we can run our Python script
`$ sudo python autostart.py`
* If all is well, messages from Python should start be received and displayed on screen and you should be able to hear the frequency of a sine wave change in response to light changes at the photoresistor.

_NOTE: if you find the above process confusing, you can always ssh into the beaglebone from two separate terminal windows and run the jack and sclang commands in one, and the python commands in the other_

_NOTE: if you make mistakes in the above process, you may need to kill processes in order to be able to start again. To get back to a clean slate, try_:  
`$ pkill python`  
`$ pkill sclang`  
`$ pkill jackd`
…and if all else fails, reboot the system:  
`$ sudo reboot`

#### Step 3. Create a Shell Script to Automate the Process of Starting Jack, SuperCollider and Python

Now we get to the actual automatic start procedures. The first stage is to create a bash script that will perform the test from the previous section automatically as a background process. This script will:

1. Log its output to a file (to help troubleshooting).
2. Run jack
3. Run our SuperCollider patch
4. Run our Python script

The shell script is named autostart.sh and can be found [here](./autostart.sh). It is also replicated below, marked with #1-4 comments to show how the above process occurs.

```bash
#!/bin/sh
sudo exec > /tmp/autostartExample.txt 2>&1 #1
echo $(date)
echo "running sclang postbootscript..."
echo "starting jack..."
jackd -dalsa -dhw:1,0 -p512 -n3 -s & #2
sleep 4
echo "start supercollider..."
sclang /home/debian/initScript/autostart.scd & #3
sleep 4
echo "starting python..."
sudo python /home/debian/initScript/autostart.py #4
```

Also note the pauses and prints between processes. The pauses allow time for jack and sclang to start successfully, while the prints are logged to the file, so that even though we won't see when running the script automatically on boot, we will be able to trace where execution stopped, in the case of any problem.

Now let's test the script as follows (make sure you have killed all existing processes as described above first).

* Log into the beaglebone (replacing 192.168.2.14 with the IP of your own beagle, and entering your password as prompted)  
`$ ssh debian@192.168.2.14`
* Go into the autostartExamples folder  
`$ cd /autostartExamples`
* Run the bash script found there  
`$ sh autostart.sh`

As previously, you should hear the frequency change in response to light changes at the photoresistor.

#### Step 4. Create an Initialisation Script by Modifying a Template

The final stage is to run our bash script automatically on bootup. To do this we can modify an existing bash script template, which is called 'skeleton' and is found in the /etc/init.d folder.

Before modification the header of the 'skeleton' file looks like this:

```bash
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
```

To make a new initialisation script, we simply copy and renamed the template, as follows:  
`$ cp skeleton autostart`  
Then edit it i.e.  
`$ sudo nano autostart`

After modification our header looks like this:

```bash
#! /bin/sh
### BEGIN INIT INFO
# Provides:          autostart
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
PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/bin:/home/debian/autostart
DESC="Automatic startup for sound and sensing"
NAME=autostart.sh
DAEMON=/home/debian/autostartExamples/$NAME
DAEMON_ARGS="--options args"
PIDFILE=/var/run/$NAME.pid
SCRIPTNAME=/etc/init.d/$NAME
```

The most important changes made are as follows:

1. Added extra paths in the PATH section i.e.  
`:/usr/local/bin` (this gives us access to executables i.e. Python and SuperCollider)  
`:/home/debian/autostartExamples` (this gives us access to our project folder)  

2. Replaced the default name in the NAME section with the name of our bash script i.e.  
`NAME=autostart.sh`

3. Changed the DAEMON field to point to the path where our bash script is found i.e.  
`DAEMON=/home/debian/autostartExamples/$NAME`

These are the only changes that are needed for the init script to function correctly, but we also made some 'cosmetic' changes, such as:

* changing the 'Provides:' section from 'skeleton' to 'autostart'
* replacing the short description, description and DESC field with appropriate text
* changing the author field

If you like you can also perform all these edits by hand…or if you prefer, you can use the pre-modified code we have provided in the 'autostartExamples' folder. To use this file, you need to move it to the /etc/init.d/ system folder, as follows:  
`$ sudo mv autostart /etc/init.d/`  
_NOTE: symlinking to this file from /etc/init.d may also be possible, but we have yet to test this_

The only thing that remains now is to tell the system to use this script on startup. To do this we need to:
* Register the initscript with a program called update-rc.d so that it will be called on boot 
`$ sudo /usr/sbin/update-rc.d autostart defaults`  
_NOTE: 'defaults' means we use what is called the 'LSB header' from our modified skeleton file to specify exactly when in the boot process the script will be run (i.e. the # Required-Start, # Required-Stop, # Default-Start and # Default-Stop fields)_
* To check for success, execute the following command and look for 'autostart' in the list (with a number prepended to it)  
`$ ls /etc/rc*.d`  
_NOTE: this is the list of run levels, of which I think we are only using run level 2 (i.e. rc2.d) with headless debian_
* Now reboot the system to see if the initialisation script works  
`$ sudo reboot`
* Our code should now run automatically once the Beaglebone comes back up, and - as before - you should hear the frequency change in response to light changes at the photoresistor.  
_NOTE: You should still be able to ssh into the beagle board as normal whilst all this is going on_

### Deregistering the Initscript

The script can be deregistered with update-rc.d at any time using:  
`$ sudo /usr/sbin/update-rc.d autostart remove`

It also helps to clean up the the /etc/init.d folder from time to time.

### Troubleshooting

_\TODO/_ 

#### Document PWM issue here

#### Document issue Fredrik and Jonas have had with running the bash script

### Further Reading

For more technical detail about how the update-rc.d approach works in practice, and more about run levels, etc see [here](http://www.debian-administration.org/articles/28) and [here](http://www.debianhelp.co.uk/initscripts.htm).

For an alternative approach using using cron and rc.local see this [tutorial by Fredrik Olofsson](https://github.com/redFrik/udk10-Embedded_Systems/tree/master/udk131219#--autostart-jack-and-sc).
