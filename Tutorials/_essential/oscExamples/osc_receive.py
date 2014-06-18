# OSC Communication
# - receiving OSC Messages in Python

from OSC import OSCServer
import time, threading 

recvAddress = ('127.0.0.1', 9001) 
oscServer = OSCServer(recvAddress)

def oscTestHandler(addr, tags, data, source): 
     print "Received '/oscTest %s'" % data

oscServer.addMsgHandler("/oscTest", oscTestHandler)

print "\nWaiting for messages from SuperCollider. Use ctrl-C to quit." 
oscServerThread = threading.Thread( target = oscServer.serve_forever ) 
oscServerThread.start()

try : 
     while 1 : 
         time.sleep(5) 

except KeyboardInterrupt : 
     print "\nClosing OSCServer." 
     oscServer.close() 
     print "Waiting for Server-thread to finish" 
     oscServerThread.join()
     print "Done"
