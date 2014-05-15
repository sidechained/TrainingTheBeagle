import csv
import socket, errno
import OSC
from OSC import OSCClient, OSCMessage
import random, time, threading
from threading import Timer
import os
import Adafruit_BBIO.ADC as ADC

sendAddress = '127.0.0.1', 57120
sensingPollRate = 0.05 # 0.05 = 20ms

def init_sensing_loop():
	Timer(sensingPollRate, sense_and_send_values).start()

def sense_and_send_values():
	sensedValue = ADC.read("P9_40")
	msg = OSC.OSCMessage()
	msg.setAddress('/shift')
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

except KeyboardInterrupt:
    print "\nClosing OSCServer."
    pythonServer.close()
    print "Waiting for Server-thread to finish"
    st.join() ##!!!
    print "Done"
