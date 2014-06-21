# autoStart.py
# - a simple python script which repeatedly polls a photoresistor, passing this reading to SuperCollider for sonification

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