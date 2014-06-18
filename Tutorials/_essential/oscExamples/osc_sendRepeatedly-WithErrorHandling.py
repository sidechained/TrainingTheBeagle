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
	print "Sending '/oscTest 100' message to SuperCollider"
	try:
		client.send(msg)
	except:
		print "Waiting for SuperCollider to become available..."
		pass
	timedSendMessage() # recursive call, keeps the timer going

sendAddress = '127.0.0.1', 57120
sendRate = 2 # send a message every two seconds
client = OSCClient()
client.connect(sendAddress)
timedSendMessage() # init call to start the sensing loop
