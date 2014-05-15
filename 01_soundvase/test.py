import socket
import threading
import OSC
from OSC import OSCClient, OSCMessage, OSCServer

def handleIt(addr, tags, msg, source):
	print msg

receiveAddress = '127.0.0.1', 22004
pythonServer = OSC.OSCServer(receiveAddress)
pythonServer.socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
global st
pythonServer.addDefaultHandlers()
pythonServer.addMsgHandler('/shift', handleIt)
st = threading.Thread( target = pythonServer.serve_forever )
st.start()
sendAddress = '127.0.0.1', 57000
msg = OSC.OSCMessage()
msg.setAddress('/shift')
msg.append(1)
client = OSCClient()
client.connect( sendAddress )
client.send ( msg )
