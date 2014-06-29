# autoStart.py
# - a simple python script which repeatedly polls a photoresistor, passing this reading to SuperCollider for sonification

import OSC
from OSC import OSCClient, OSCMessage
from threading import Timer
import Adafruit_BBIO.ADC as ADC

inPin = "P9_40" # connect LDR to this pin
sendAddress = '127.0.0.1', 57120 # address to send to SuperCollider
sensingPollRate = 0.05 # rate at which values will be read (0.05 = 20ms)

def init_sensing_loop():
	Timer(sensingPollRate, sense_and_send_values).start()

def sense_and_send_values():
	sensedValue = ADC.read(inPin)
	msg = OSC.OSCMessage()
	msg.setAddress('/light')
	msg.append(sensedValue)
	print "sending locally to supercollider: '{0}', '{1}'".format(msg, client)
	try:
		client.send ( msg )
	except:
		print "waiting for supercollider to become available"
		pass
	init_sensing_loop() # recursive call, keeps timer going

# main:
ADC.setup()
client = OSCClient()
client.connect( sendAddress )
init_sensing_loop() # init call to start the sensing loop
