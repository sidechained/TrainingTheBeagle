## Audio Hardware

This document collects some key information on how to work with audio hardware on the Beaglebone Black in Debian Linux using ALSA and JACK. Mostly, the focus is on USB audio (using a small, low-cost USB soundcard), but there is also section on using [audio over HDMI](#experiments-with-hdmi).

#### What are ALSA and JACK?

According to the [ALSA Wikipedia entry](http://en.wikipedia.org/wiki/Advanced_Linux_Sound_Architecture)
Advanced Linux Sound Architecture (ALSA) is "the part of the Linux kernel that provides an application programming interface (API) for sound card device drivers. ALSA is used as a hardware back-end by JACK to allow performing low-latency professional-grade audio editing and mixing."

Likewise the [JACK Wikipedia Page](http://en.wikipedia.org/wiki/JACK_Audio_Connection_Kit) states that the JACK Audio Connection Kit (or JACK; a recursive acronym) is "a professional sound server daemon that provides real-time, low latency connections for both audio and MIDI data between applications that implement its API. JACK can use ALSA, PortAudio, CoreAudio, FFADO and OSS as hardware back-ends."

JACK comes in two versions, 1 and 2. For our purposes we will use the jackdmp implemention of JACK2, which is described in the [github readme](https://github.com/jackaudio/jack2) as "a C++ version of the JACK low-latency audio server for multi-processor machines" and "is a new implementation of the JACK server core features that aims in removing some limitations of the JACK1 design."

### Connecting a USB Soundcard

We recommend using a USB soundcard, as shown [here](http://www.hermann-uwe.de/files/images/3d_sound_usb.preview.jpg). This card is mono in, stereo out, and while the audio quality is not professional level, it is satisfactory for most purposes. Make sure to connect the soundcard before powering up, as hotplugging is not supported. Also, as the soundcard is powered by the USB bus, be sure power your Beaglebone from an external supply in order to provide adequate current (i.e. 2A).

### Installation

To get started we need to install jackdmp (a.k.a. JACK2). To do so, ssh into your beaglebone using the [normal method](https://github.com/sidechained/TrainingTheBeagle/blob/master/Tutorials/_essential/installation.md#ssh-basics), then refer to the relevant section of [Fredrik Olofsson's tutorial](https://github.com/redFrik/udk10-Embedded_Systems/tree/master/udk131121#--install-jack).

_NOTE: You can skip this if you have already installed jackdmp as part of the wider [installation tutorial](./installation.md)._

### Deconstructing a Typical jackd Command

In this section we attempt to demystify the various command line switches used in a typical jackd command, with some help from the [jackd man page](http://ccrma.stanford.edu/planetccrma/man/man1/jackd.1.html). As well as authoring the above guide, Fredrik has also conducted numerous experiments to achieve reliable audio with jackd on the BeagleBone, so we will take the general jackd command he uses as our starting point:

`$ jackd -P95 -d alsa -d hw:1,0 -p512 -n3 -s &`

It is worth noting here that the `-P` and `-d` options at the start are JACK options, whilst those that follow the `-d alsa` section are ALSA options. The command as a whole can also be expressed more concisely as:

`$ jackd -P95 -dalsa -dhw:1,0 -p512 -n3 -s &`

Firstly, let us look at the output of jackdmp, which can be useful for troubleshooting purposes:

```
jackdmp 1.9.10
Copyright 2001-2005 Paul Davis and others.
Copyright 2004-2013 Grame.
jackdmp comes with ABSOLUTELY NO WARRANTY
This is free software, and you are welcome to redistribute it
under certain conditions; see the file COPYING for details
JACK server starting in realtime mode with priority 95
creating alsa driver ... hw:1,0|hw:1,0|512|3|48000|0|0|nomon|swmeter|soft-mode|32bit
configuring for 48000Hz, period = 512 frames (10.7 ms), buffer = 3 periods
ALSA: final selected sample format for capture: 16bit little-endian
ALSA: use 3 periods for capture
ALSA: final selected sample format for playback: 16bit little-endian
ALSA: use 3 periods for playback
```

Now onto the meaning of the various command line switches:

#### -P
_JACK switch_

* This is an undocumented jackd switch, but it seems to specify audio priority. With it jackdmp reports…  
`JACK server starting in realtime mode with priority 95`
* …whilst without it, jackdmp reports:  
`JACK server starting in realtime mode with priority 10`
* Q: Does this relate to the rtprio 95 line in /etc/security/limits.conf?

#### -d alsa
_JACK switch short for_ `--driver=alsa`

* This selects the output driver. This will always be `alsa`, as this is the only documented driver.

#### -d hw:1,0
_ALSA switch short for_ `--device=hw:1,0`

* Here 'hw:1,0' is the name given to the device, and follows some kind of (seemingly undocumented) conventions. For example `hw:0` also works with the warning `ALSA: Cannot open PCM device alsa_pcm for playback. Falling back to capture-only mode`. However, trying with the name 'mySoundCard' produces the folowing error:

```
ALSA lib control.c:951:(snd_ctl_open_noupdate) Invalid CTL mySoundCard
control open "mySoundCard" (No such file or directory)
ALSA lib pcm.c:2217:(snd_pcm_open_noupdate) Unknown PCM mySoundCard
ALSA lib pcm.c:2217:(snd_pcm_open_noupdate) Unknown PCM mySoundCard
ALSA: Cannot open PCM device alsa_pcm for playback. Falling back to capture-only mode
Cannot initialize driver
JackServer::Open failed with -1
```

#### -p
_ALSA switch short for_ `--period` _e.g._ `--period 512`

* The default value is 1024
* The advice given is to set as low as you can go without seeing xruns (audio dropouts)
* Also note that a larger period size yields higher latency

#### -n
_ALSA switch short for_ `--nperiods` _e.g._ `--nperiods3`

* This specifies the number of periods in the hardware buffer
* The default value is 2
* Note that the period (i.e. -p) mutiplied by the nperiod (i.e. -n) mutiplied by 4 is equal to the JACK buffer size in bytes

##### -s
_ALSA switch short for_ `--softmode`

* This ignores xruns reported by the ALSA driver. This makes JACK less likely to disconnect unresponsive ports when running without --realtime.

##### &
_UNIX command_

* The ampersand is not a jackd command line switch, but is a general unix command that is required to ensure that jackdmp runs in the background and returns the shell to the user.
* Without this the command line would not reppear we would need to open another terminal session in order to be able to continue.
 
#### Realtime vs Non-Realtime Scheduling

* Realtime scheduling can be enforced using the -R switch (short for `--realtime`)
* Apparently this is "needed for reliable low-latency performance"
* Curiously -R is not included in the above command, yet we can see from the terminal output that:  
`JACK server starting in realtime mode with priority 95`
* Q: How does this happen?
* According to the documentation realtime scheduling requires jackd and its client to run as root

#### Specifying Sample Rate and Bit Rate
* Although it is not done above, the sample rate can be set using the ALSA `-r` flag followed by an integer e.g. `-r 44100`.
* It is not clear how to set the resolution/bit rate.

#### Adding Scheduler and Memory Allocation Privileges

In Fredrik's guide, some audio specific lines are added to the /etc/security/limits.conf file. As far as I can tell, this gives privileges to members of the @audio group, and helps to lock down a specific chunk of the Beaglebone's (limited) memory for audio purposes. These lines are added as follows:

* Log into the Beaglebone and edit the file from the command line
`$ sudo nano /etc/security/limits.conf`  
* Now add the following lines to the end of the file
```
@audio - memlock 256000
@audio - rtprio 95
```
* When done, exit and save using CTRL+X

NOTE: in my configuration file I also have the line `@audio - nice -19`. Q: what does this do and is it needed?

#### Testing Audio without SuperCollider

* Start jack, if you haven't already  
`$ jackd -P95 -dalsa -dhw:1,0 -p512 -n3 -s &`
* Check the name of your soundcard as follows  
`$ aplay -L`
* Look for the first items in the list that is called something like  
`C-Media USB Headphone Set, USB Audio`  
and copy it's name (in my case `default:CARD=Set`)
* Then the speaker-test program can be used to test audio, as follows (replace `default:CARD=Set` with your device name):  
`$ speaker-test -Ddefault:CARD=Set`  
* This should play a test sound through usb soundcard, and can be stopped with CTRL+C.
* For more info see the [speaker-test man page](http://linux.die.net/man/1/speaker-test)

NOTE: this did not work for me, I got the following error:

```
Playback device is default:CARD=Set
Stream parameters are 48000Hz, S16_LE, 1 channels
Using 16 octaves of pink noise
ALSA lib pcm_dmix.c:1018:(snd_pcm_dmix_open) unable to open slave
Playback open error: -16,Device or resource busy
```

#### Testing Audio with SuperCollider

It is also worth testing audio with SuperCollider (if you have it installed). 

* Start sclang, as follows
`$ sudo sclang`
* NOTE that sudo must always be used (not doing so can be the cause of much head scratching)
* From the SuperCollider command prompt, boot the audio server (don't type the sc3> part)
`sc3> s.boot` 
* Perform the following command to start stereo output (a different pitch of sine wave in each channel)
`sc3> a = {SinOsc.ar([330,880])}.play` 
* To stop audio, do the following
`sc3> a.free`
* To exit sclang, type
`sc3> 0.exit`

### Experiments with HDMI

This section covers (will cover) use of HDMI devices for audio input/output. I noticed that HDMI audio worked in Debian accidentally when connecting my pico projector to the Beaglebone. Apparently HDMI audio output is the standard. HDMI is interesting as it may potentially do away with the need for USB bus power, allowing the onboard power to be used for power and recharging.

* Apparently [multi-channel audio](http://www.element14.com/community/community/knode/single-board_computers/next-gen_beaglebone/blog/2013/05/28/bbb--audio-notes) is possible.
* Also [this link](http://www.elinux.org/BeagleBone_Black_Capes) refers to an HDMI audio cape, which could be worth studying.
* Note that the BBB does not actually support audio out over the mHDMI yet (though it is said to be coming in a near-term release). See [this forum thread](https://groups.google.com/forum/#!category-topic/beagleboard/audio/8Zc9DPd7rxc) for more info.

#### To sudo or not to sudo?

NOTE: Need a definitive answer on this one (TODO)

It is not always clear whether to run both jackd and as root in order for audio to work successfully. The [jackd man page](http://ccrma.stanford.edu/planetccrma/man/man1/jackd.1.html) gives at least one (realtime) example of a jackd command which must be run as root, and generally to run realtime audio requires root access in order to be able to invoke special scheduler and memory allocation privileges.

### Troubleshooting

This sections documents some common problems when working with JACK/ALSA under Linux.

### jackd ERROR: "`default' server already active" or "Cannot lock down 82278944 byte memory area (Cannot allocate memory)"

If you get either of the following errors when trying to run jackd:

```
`default' server already active
Failed to open server
```

```
Cannot lock down 82278944 byte memory area (Cannot allocate memory)
```

Then it is likely jackd is still running from a previous invocation. In this case we can use the pkill command to force jackd to stop, as follows:  

`$ sudo pkill jackd`

Note that the LED on the USB soundcard should stop flashing when jackdmp is killed successfully.

### sclang ERROR: "server failed to start"

If you get the following error(s) after trying to boot the audio server with `s.boot`...

```
booting 57110
localhost
sc3> Exception in World_New: Permission denied
RESULT = 0
ERROR: server failed to start
For advice: [http://supercollider.sf.net/wiki/index.php/ERROR:_server_failed_to_start]
```

..it could be that you didn't start SuperCollider as root i.e. you did `$ sclang` instead of `$ sudo sclang`. Root access is neccessary to be able to interface with jackd.

### Resources

* The README.md at the [JACK Github repository](http://github.com/jackaudio/jack2.git) is a good source of general JACK2 information.
* The [jackd man page](http://ccrma.stanford.edu/planetccrma/man/man1/jackd.1.html) gives an overview of jackd and ALSA command line switches.
* [This tutorial](http://puredata.info/docs/embedded/bbb/sound) focusses on getting audio running on the Beaglebone for use with Pd. It runs through the whole jackd process including setting scheduler and memory allocation privileges.


