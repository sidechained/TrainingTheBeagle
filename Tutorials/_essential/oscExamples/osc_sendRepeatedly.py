# OSC Communication
# - repeatedly sending an OSC message to SuperCollider

from OSC import OSCClient, OSCMessage
from threading import Timer

def timedSendMessage():
	Timer(sendRate, sendMessage).start()

def sendMessage():
	msg = OSCMessage()
	msg.setAddress('/oscTest')
	msg.append(100)
	print "sending '/oscTest 100' message to SuperCollider"
	client.send(msg)
	timedSendMessage() # recursive call, keeps the timer going

sendAddress = '127.0.0.1', 57120
sendRate = 2 # send a message every two seconds
client = OSCClient()
client.connect(sendAddress)
timedSendMessage() # init call to start the sensing loop
