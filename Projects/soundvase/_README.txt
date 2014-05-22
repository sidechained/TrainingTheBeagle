# Soundvase Project - README

- NOTE TO SELF: format this guide with github flavoured markdown

* Aim

- the aim of this project is to create a simple self-contained musical device which can process audio in response to sensor input
- the skills needed to get this project up and running form the basis of almost
- the soundvase project was created - consisted of the beaglebone, soundcard and speaker embedded inside a vase, which played by tapping on the vase

* Prerequisites

- to get this project up and running you will need the following:

** Hardware

- a beaglebone black
- a thumbdrive-style usb sound card
- a mic with 3.5mm jack output
- a speaker (e.g. doss asimom)
- a sensor/potentiometer (e.g. dial or slider)

** Software

- debian linux (running on the beaglebone)
- python
- supercollider
- jackd/alsa (link)
- python OSC library (link)
- adafruit BBIO library (link)

- NOTE TO SELF: ADD LINK TO TUTORIAL HERE ON HOW TO GET ALL THIS UP AND RUNNING

* Setup

- the project consists of four files:

soundvase.py		- reads values from the potentiometer and sends them to sclang
soundvase.scd		- receives potentiometer values from python and uses them to control the amount of pitch shifting done to the input from the mic
soundvaseStartup 	- sets up the usb soundcard, then runs the above python and sclang files
soundvaseBoot		- runs the soundvaseStartup file automatically when the beaglebone boots up

- the first three files will live in the /home/debian/soundvase folder on the beaglebone
- soundvaseBoot will go in /Volumes/rootfs/etc/init.d

** Copying the Files onto the Beaglebone

- open terminal and navigate to an appropriate folder to download the sound vase software into
$ cd ~/home/grahambooth/documents/
- clone the project from github
$ git clone https://github.com/sidechained/TrainingTheBeagle
- move into the projects folder where the soundvase project can be found
$ cd TrainingTheBeagle/Projects
- copy the soundvase folder into the home folder of the beaglebone (replace [your_ip] with the IP of your beaglebone)
$ scp -r soundvase debian@[your_ip]:/home/debian/
- log into the beaglebone and check the software is in the right place
$ ssh debian@[your_ip]
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
- repower the beaglebone, then log back in
$ ssh debian@[your_ip]

**** Software Setup

- in order to successfully generate audio, jack must be running
$ jackd -dalsa -dhw:1,0 -p512 -n3 -s &
- NOTE: & runs jackd concurrently in a separate process, allowing other terminal commands to subsequently be run (without it the command line would not reappear)
- the LED should begin to flash on the USB sound card
- perform a quick audio test
$ sclang
- in the sclang command prompt, enter the following lines one by one (don't enter the sc3> part):
sc3> s.boot
sc3> {SinOsc.ar}.play
- a 440Hz sine wave should play
- now exit sclang:
sc3> 0.exit
- go into the project folder, if not already there
$ cd /home/debian/soundvase
- now run the .scd file
$ sclang soundvase.scd
- you should now able to tap the mic and hear its output being routed to the speaker with noticeable pitch shifting being applied
- press CTRL+C a few times to exit sclang

*** 2. Testing the .py file

**** Hardware Setup

- power down the beaglebone and wire up your sensor (e.g. photoresistor, potentiometer) circuit
1. beagleboard 5v output to sensor + terminal
2. sensor - terminal to beagle board ground
3. sensor output to beaglebone ADC pin P9_40

**** Software Setup

- go into the project folder, if not already there
$ cd /home/debian/soundvase
- run the python script
$ sudo python soundvase.py
- check the values of your sensor as printed on screen
- exit using CTRL+C

*** 3. Testing the .scd and .py Files Together

- start jack again as in stage 1:
$ jackd -dalsa -dhw:1,0 -p512 -n3 -s &
- now run the .scd file, this time concurrently
$ sclang soundvase.scd &
- this will allow sclang to run it in the background so that you can continue to run the python script
- at this point no OSC messages are being sent to SuperCollider to alter the pitch shifting parameter (which is running at its default value of 0.5)
- now run the python script
$ sudo python soundvase.py
- NOTE: sudo is needed here otherwise the Adafruit library cannot interface with the beagle pin inputs and outputs
- interact with your sensor and the mic and you should be able to hear the sound changing

*** 4. Testing the Startup File

- now we are sure the .scd and .py files work well together, we can use a startup file to run them both automatically
- run the soundvaseStartup file as follows:
- NOTE: you may have to kill jack and sclang first e.g. $ sudo pkill jackd; sudo pkill sclang
- NOTE: if all else fails try rebooting to ensure there are no conflicting background processes
$ sudo sh soundvaseStartup
- Q: does this need sudo?
- as previously, interact with your sensor and the mic and you should be able to hear the sound changing
- once you are satisfied that this works, you can move onto to getting the beagle to run this script automatically on startup

*** 4. Enabling Automatic Startup

- NOTE TO SELF: is there anyway to symlink to the soundvaseBoot file in order to keep all the code together in one folder?
- NOTE TO SELF: also look at Fredrik's method for this on the supercollider wiki

- to enable automatic start we need to move the soundvaseBoot file into the startup folder
- NOTE: see separate tutorial for more on how the soundvaseBoot file works and is created
- make sure you are in the soundvase project folder
$ cd ~/home/debian/soundvase
- move the soundvaseBoot file into the debian startup folder
$ sudo mv soundvaseBoot ~/etc/init.d/
- initialise it as follows
$ sudo /usr/sbin/update-rc.d soundvaseBoot defaults
- Q: what message should come up
- reboot the beaglebone, wait a short while, then interact with your sensor and the mic and you should be able to hear the sound changing as previously
- NOTE: it should still be possible to ssh into the beaglebone whilst the project is running 

*** 5. Disabling Automatic Startup

- to disable the startup script, use the following command:
$ sudo /usr/sbin/update-rc.d soundvaseBoot remove
