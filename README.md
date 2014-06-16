# Training The Beagle

A project about learning how to use the Beaglebone Black, by Jonas Hummel and Graham Booth.

The aim of this repo is to document our work using the Beaglebone for combined audio and physical computing projects, and to make this work reusable as lessons or tutorials for others. All the projects contained here are 

Debian Linux
Jack
SuperCollider
Adafruit BBIO library
Open Sound Control

## Topic List

Here are a list of topics for possible future sessions:

- How to run sounds on top of what the beagle is running at startup
- Battery power: finding good solutions for creating a mobile device
- Wifi communication (dongles)
- Approaches to automatic startup (Graham's init script approach v Fredrik's crontab approach)
- Revisiting Chinese Whispers Networking classes to create adhoc networks of several beagles

## Schedule:

- Skype weekly on progress
- Do a practical session, trying out stuff as often as possible
- Graham leaves on July 6th, how many sessions do we want to do before then, and what can we realistically cover?

## References: 

#### Redfrik UdK Class

- This follows a long a project by redfrik @ Udk: 
https://github.com/redFrik/udk11-portable_sonification_projects/

#### INLPD / 3D Min Course Berlin

Jonas develops another beagle board there to be used for a mobile networking device, running supercollider, audioprocessing, networking to connect to a central "Republic-like" Server. 
With a tangible interface (using skin conductance to close connections).
He compiles some code for this on his repo.

The technological setup will be: 
One Node consists of 
- BBB
- WIFI Adapter
- Bluetooth Adapter (for Audio)
- Bluetooth Headset (the monitoring)
- USB Hub
- A "Power Bank" to supply the BBB
- GSR Sensors which go into GPIO / Analog In of BBB (basically bare wire/copper surfaces)
- Option: Connect a microphone to the Inputs of BBB or use Bluetooth Mic In
- Option: Connect an LDR or Ultrasound Distance Sensor for some non-touch gestural control! 


Each Node is connected to a Network and can send and receive OSC messages! 
-> Get Utopia Ready!
-> Can they also stream audio !?!?

