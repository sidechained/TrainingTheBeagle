# Soundvase Project - README

- NOTE TO SELF: format this guide with github flavoured markdown

* Aim

- the aim of this project is to create a simple self-contained musical device which can process audio in response to sensor input
- the skills needed to get this project up and running form the basis of almost
- the soundvase project was created - consisted of the beaglebone, soundcard and speaker embedded inside a vase, which played by tapping on the vase

* Prerequisites

- to get this project up and running you will need the following:

** Hardware

- beaglebone black
- thumbdrive-style usb sound card
- mic with 3.5mm jack output
- speaker (e.g. doss asimom)
- a sensor/potentiometer (e.g. dial or slider)

** Software

- beaglebone running debian linux
- python OSC library
- adafruit BBIO library
- jackd/alsa

* Setup

- the project consists of four files:

soundvase.py		- reads values from the potentiometer and sends them to sclang
soundvase.scd		- receives potentiometer values from python and uses them to control the amount of pitch shifting done to the input from the mic
soundvaseStartup 	- sets up the usb soundcard, then runs the above python and sclang files
soundvaseBoot		- runs the soundvaseStartup file automatically when the beaglebone boots up

- the first three files will live in the /home/debian/soundvase folder on the beaglebone
- soundvaseBoot will go in /Volumes/rootfs/etc/init.d

** Copying the files onto the beaglebone

- open terminal, navigate to an appropriate folder to download the sound vase software into
$ cd ~/home/grahambooth/documents/
- clone the project from github
$ git clone https://github.com/sidechained/TrainingTheBeagle
- move into the projects folder where the soundvase project can be found
$ cd TrainingTheBeagle/projects
- copy the soundvase folder into the home folder of the beaglebone
- [your_username] is … (will this always be debian?) and [x.x.x.x] is the IP of your beaglebone
$ scp soundvase [your_username]@[x.x.x.x] /home/debian/
- log into the beaglebone and check the software is in the right place
$ ssh debian@192.168.x.x
$ cd /soundvase
$ ls
- if you see the above list of four files, you are ready to start testing

** Step-by-step Test

*** 1. Testing the .scd file

**** Hardware Setup

- disconnect the beaglebone from power, then:
- 1. connect the USB sound card to the beaglebone
- 2. connect the mic to the sound card's input
- 3. connect the sound card's output to the speaker
- repower the beaglebone, and log back in
$ ssh debian@192.168.x.x

**** Software Setup

- in order to successfully, jack must be running
$ jackd -dalsa -dhw:1,0 -p512 -n3 -s &
- Q: & needed in this case?
- once this line is run, the LED should come on on the USB sound card
- now run the .scd file
$ sclang soundvase.scd
- you should now able to tap the mic and hear its output being routed to the speaker with little or no change

*** 2. Testing the .py file

**** Hardware Setup

- power down the beaglebone and wire up your sensor (e.g. photoresistor, potentiometer) circuit
1. beagleboard 5v output to sensor + terminal
2. sensor - terminal to beagle board ground
3. sensor output to beaglebone ADC pin P9_40

**** Software Setup

- run the python script
- Q: no sudo here?!
$ python soundvase.py
- check the values of your sensor as printed on screen
- exit using CTRL+C

*** 3. Testing the .scd and .py Files Together

- follow stage 1. again to get supercollider up and running, but add an & to the final command
$ sclang soundvase.scd &
- this will allow sclang to run it in the background so that you can continue to run the python script
- at this point no OSC messages are being sent to SuperCollider to alter the pitch shifting parameter (which is running at its default value of 0.5)
- now run the python script
$ python soundvase.py
- interact with your sensor and the mic and you should be able to hear the sound changing

*** 4. Testing the Startup File

- now we are sure the .scd and .py files work well together, we can use a startup file to run them both automatically
- run the soundvaseStartup file as follows:
- NOTE: you may have to kill jack and sclang first (how?)
- NOTE: if all else fails try rebooting to ensure there are no conflicting background processes
$ sudo sh soundvaseStartup
- Q: does this need sudo?
- as previously, interact with your sensor and the mic and you should be able to hear the sound changing
- once we are satisfied that this works, we can move onto to getting the beagle to run this script automatically on startup

*** 4. Enabling Automatic Startup

- to enable automatic start we need to move the soundvaseBoot file into the startup folder
- NOTE: see separate tutorial for more on how the soundvaseBoot file works and is created
- make sure you are in the soundvase project folder
$ cd ~/home/debian/soundvase
- move the soundvaseBoot file into the debian startup folder
$ mv soundvaseBoot ~/etc/init.d/
- initialise it as follows
$ sudo /usr/sbin/update-rc.d soundvaseBoot defaults
- Q: what message should come up
- reboot the beaglebone, wait a short while, then interact with your sensor and the mic and you should be able to hear the sound changing as previously
- NOTE: it should still be possible to ssh into the beaglebone whilst the project is running 

*** 5. Disabling Automatic Startup

- to disable the startup script, use the following command:

- NOTE TO SELF: is there anyway to symlink to the soundvaseBoot file in order to keep all the code together in one folder?
- NOTE TO SELF: also look at Fredrik's method for this on the supercollider wiki

