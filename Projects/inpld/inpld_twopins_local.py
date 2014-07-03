# inpld project - python script for 2 pins
# - poll the value of an analog in and a digital in and send only changes via OSC to sclang e.g. '/adc0 52'
# THIS IS LOCAL VERSION FOR LAPTOP

import OSC
from OSC import OSCClient, OSCMessage
from threading import Timer
# import Adafruit_BBIO.ADC as ADC
# import Adafruit_BBIO.GPIO as GPIO
import random # for faking random ADC values

lastadc0= -1
lastdig0= -1
anaPin = "P9_40" # connect sensor to this pin
digiPin = "P9_41"
sendAddress = '127.0.0.1', 57120 # address to send to SuperCollider
sensingPollRate = 0.05 # rate at which values will be read (0.05 = 20ms)

def init_sensing_loop():
	Timer(sensingPollRate, sense_and_send_values).start()

def sense_and_send_values():
	global lastadc0
	global lastdig0
	# val = ADC.read(anaPin)
	# val = val/1799 # normalize to 0..1
	val = random.random() # faking it for now in the range 0 to 1
	if val!=lastadc0:
		sendOSC("/fromPython/adc0", val) #set adress and val to send via OSC
		lastadc0= val
	# val = GPIO.input(digiPin)
	val = int(round(random.random(),0)) # rand values: 0 or 1
	if val!=lastdig0:
		sendOSC("/fromPython/dig0", val)
		lastdig0= val
	init_sensing_loop() # recursive call, keeps timer going
		
def sendOSC(name, val):
	msg= OSC.OSCMessage()
	msg.setAddress(name)
	msg.append(val)
	print "sending locally to supercollider: '{0}', '{1}'".format(msg, client)
	try:
		client.send(msg)
	except:
		print "waiting for supercollider to become available"
		pass

# main:
# ADC.setup()
# GPIO.setup(digiPin, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
client = OSCClient()
client.connect( sendAddress )
init_sensing_loop() # init call to start the sensing loop

try:
	while True:
	     	time.sleep(1) 

except KeyboardInterrupt:
    print "\nClosing OSCServer."
    pythonServer.close()
    print "Waiting for Server-thread to finish"
    st.join() ##!!!
    print "Done"
