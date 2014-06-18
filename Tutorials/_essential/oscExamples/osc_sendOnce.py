# OSC Communication
# - One shot example of sending an OSC message from Python to SuperCollider
# - 

from OSC import OSCClient, OSCMessage

sendAddress = '127.0.0.1', 57120
client = OSCClient()
client.connect(sendAddress)
msg = OSCMessage()
msg.setAddress('/oscTest')
msg.append(100)
print "sending /oscTest 100 message to SuperCollider"
client.send(msg)
