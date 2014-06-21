## OSC Communication

This document deals with Open Sound Control communication between SuperCollider and Python and vice versa. For a primer on OSC itself see the [Open Sound Control website](http://opensoundcontrol.org/introduction-osc).

### Prerequisites

Python requires the pyOSC library to be able to handle Open Sound Control. For instructions on how to install this library, see the pyOSC section of Fredrik Olofsson's tutorial [here](https://github.com/redFrik/udk10-Embedded_Systems/tree/master/udk131114#--installing-software).

### 1. Python to SuperCollider

The following are 'bare bones' examples which show how to send OSC messages between Python and SuperCollider. This will be the typical approach for most simple projects (i.e. sensor input produces sound output).

#### Sending an OSC Message from Python

Writing a Python script which can send an OSC message is a three stage process:

a. Import the relevant classes from the pyOSC library
b. Set up a OSC client using the address you wish to send to. In our case this is: localhost (i.e. "127.0.0.1"), port 57120 (SuperCollider's default port)
c. Format and send a message using the client

The lines marked #1, #2 and #3 in the code below show how this is done in practice:

```python
from OSC import OSCClient, OSCMessage # 1

sendAddress = '127.0.0.1', 57120 # 2
client = OSCClient() # 2
client.connect(sendAddress) # 2
msg = OSCMessage() # 3
msg.setAddress('/oscTest') # 3
msg.append(100) # 3
print "sending /oscTest 100 message to SuperCollider"
client.send(msg) # 3
```

See [osc_sendOnce.py](./oscExamples/osc_sendOnce.py) for the standalone version of this code (which we will make use of shortly).

#### Receiving an OSC Message in SuperCollider

As OSC is native to SuperCollider, no external libraries are required. Therefore the sclang code for receiving messages is an incredibly concise one liner, as follows:

`OSCFunc({arg msg; ("Received" ++ msg).postln;}, '/oscTest');`

This line simply prints out any OSC message that matches the /oscTest tag (appending a "Received" message to the front). This will continue indefinitely as long as sclang is running and messages are being sent.

NOTE: If we wanted to mirror our 'sendOnce' python example, we could use OSCFunc's .oneShot method to close down the function after execution, so that only one message is received.

NOTE: It is also possible to configure OSCFunc so as to listen to messages coming from a particular sender IP, or only messages targeted at a particular port (i.e. 57120). However, in the interests of getting things working quickly, we have avoided imposing any of these restrictions. For more details on these approaches, see the [OSCFunc documentation](http://doc.sccode.org/Classes/OSCFunc.html).

Also, see [osc_receive.scd](./oscExamples/osc_receive.scd) for the standalone version of this code (which we will use next).

#### Testing

To test the above code, go through the following steps:

* Firsly, clone the TrainingTheBeagle repo to a convenient temporary location on your pc (i.e. ~/Desktop)  
`$ cd ~/Desktop` 
`$ git clone https://github.com/sidechained/TrainingTheBeagle.git`  
* Navigate to the tutorials folder, where the oscExamples can be found  
`$ cd TrainingTheBeagle/Tutorials/`  
* Copy the oscExamples folder into your beaglebone's home folder as follows (replacing 192.168.2.14 with the IP of your own beagle, and entering your password as prompted)  
`$ scp -r oscExamples debian@192.168.2.14:/home/debian`
* Tidy up by removing the cloned repo from the desktop (or wherever you put it)  
`$ cd ..`
`$ rm -r TrainingTheBeagle`
* Log into the beaglebone (again replacing 192.168.2.14 with the IP of your own beagle, and entering your password as prompted)  
`$ ssh debian@192.168.2.14`  
* Start the SuperCollider code for receiving OSC messages  
`$ sclang oscExamples/osc_receive.scd`  
* You should now see the message "Waiting for /oscTest message from Python"  
* Open another terminal window so that it is visible  
* Log into to the beaglebone again from this window (this will allow us to run and see the output of two concurrent processing i.e. sending and receiving). Again, replace 192.168.2.14 with the IP of your board, and enter your password as prompted
`$ ssh debian@192.168.2.14`  
* Run the Python code for sending an OSC message  
`$ sudo python oscExamples/osc_sendOnce.py`  
* If successful a message will appear in the OSC receive window. If not see the [troubleshooting section](#troubleshooting) of this guide.

#### Repeatedly Sending from Python

In many cases, sending a one shot OSC message will not be enough. Often we work with sensors that need to be polled (i.e. their values need to be read repeatedly), and for this we need to work with loops in Python. In the following example, we will create a function from our existing code, and call that function repeatedly at a set rate in order to repeatedly send a message.

##### The 'sendMessage' function

```python
def sendMessage():
        msg = OSCMessage()
        msg.setAddress('/oscTest')
        msg.append(100)
        print "sending '/oscTest 100' message to SuperCollider"
        client.send(msg)
        timedSendMessage() # recursive call to a timer loop (see 
```

As we can see, the code is very similar to our previous example, the only difference being that the function calls back to a timer function.

##### The Timer Function

Our timer function is simply called 'timedSendMessage', and looks like this:

```python
def timedSendMessage():
        Timer(sendRate, sendMessage).start()
```

When called 'timedSendMessage' simply waits a set amount of time (the sendRate) before calling a specified function (our 'sendMessage' function). All that is needed now is to set up our client and sendAddress, define the sendRate, and set the timer function into motion. This is done as follows:

```python
sendAddress = '127.0.0.1', 57120
sendRate = 2 # send a message every two seconds
client = OSCClient()
client.connect(sendAddress)
timedSendMessage() # init call to start the sensing loop
```

For the standalone version of this code see [osc_sendRepeatedly.py](./oscExamples/osc_sendRepeatedly.py).

NOTE: To test this code, follow the [testing section](#testing) above but substitute the last line for:

`$ sudo python osc_sendRepeatedly.py`

#### Error Handling

If you run the Python 'send' code before the SuperCollider 'receive' code, you will notice that Python will throw a 'connection refused' error e.g.

```
OSCClientError: while sending: [Errno 111] Connection refused
```

This is problematic as it stops the script. Therefore, our final addition to the sending code will be to add a couple of extra lines to prevent this from occurring, as follows:

```python
def sendMessage():
        msg = OSCMessage()
        msg.setAddress('/oscTest')
        msg.append(100)
        try:
		print "Sending '/oscTest 100' message to SuperCollider"
		client.send(msg)
        except:
                print "Waiting for SuperCollider to become available..."
                pass
        initLoop() # recursive call, keeps the timer going
```

The sendMessage function is very similar to before, only we use the 'try...except' structure to handle the connection refused error and post a more useful message instead ("Waiting for SuperCollider to become available…).

For the standalone version of this code see [osc_sendRepeatedly-WithErrorHandling.py](./oscExamples/osc_sendRepeatedly-WithErrorHandling.py).

NOTE: To test this code, follow the [testing section](#testing) above but substitute the last line for:

`$ sudo python osc_sendRepeatedly-WithErrorHandling.py`

### 2. SuperCollider to Python

As well as envisaging sensing which actives sound processes, we might also imagine a scenario where sound-making code activates physical processes. For this we need to communicate the other way around, from sclang to python.

#### Sending an OSC Message from SuperCollider

This is a simple two-line process, which involves setting up a NetAddr and then sending a message to it, as follows:

```
n = NetAddr("127.0.0.1", 9001);
n.sendMsg("\oscTest", 100);
```

For the standalone version of this code see [osc_sendOnce.scd](./oscExamples/osc_sendOnce.scd).

#### Receiving an OSC Message in Python

NOTE: This example is modified from ixi software's basic_receive.py example, which can be found in this [zip file](http://ixi-audio.net/content/download/pyOSC_examples.zip). More info at the [backyard](http://www.ixi-audio.net/content/backyard.html).

Receiving OSC in Python using pyOSC is requires four basic stages:

a. Import the OSCServer class from the pyOSC library, and the time and threading modules
b. Set up an OSCServer on a receive address. In our case this is '127.0.0.1', port 9001
c. Define a message handler function (which will print the incoming message), then add it to the server
d. Create and start a server thread

```python
from OSC import OSCServer # 1
import time, threading # 1

recvAddress = ('127.0.0.1', 9001) # 2
oscServer = OSCServer(recvAddress) # 2

def oscTestHandler(addr, tags, data, source): # 3
     print "Received '/oscTest %s'" % data # 3

oscServer.addMsgHandler("/oscTest", oscTestHandler) # 3

oscServerThread = threading.Thread( target = oscServer.serve_forever ) # 4
oscServerThread.start() # 4
```

For things to run smoothly, we also need to add two more elements. Firstly, we will add a few lines which will keep the script alive:


```
try :
     while 1 :
         time.sleep(5)
```

…and secondly we add a function which will exit gracefully and shut down the server if we press CTRL + C in Python (otherwise Python will hog port 9001)

```
except KeyboardInterrupt :
     print "\nClosing OSCServer."
     oscServer.close()
     print "Waiting for Server-thread to finish"
     oscServerThread.join()
     print "Done"
```

For the standalone version of this code see [osc_receive.py](./oscExamples/osc_receive.py).

#### Testing (revisited)

Follow the above [testing guide](#testing) to open two concurrent terminal windows, substituting the named files for [osc_receive.py](./oscExamples/osc_receive.py) and [osc_sendOnce.scd](./oscExamples/osc_sendOnce.scd) respectively.

#### Repeatedly Sending from Python

To send repeatedly, we simply wrap the send message in a routine as follows:

```
n = NetAddr("127.0.0.1", 9001);
Routine({
	inf.do{
		n.sendMsg("\oscTest", 100);
		2.wait;
	}
}).play
```

For the standalone version of this code see [osc_sendRepeatedly.scd](./oscExamples/osc_sendRepeatedly.scd). To test simply use osc_sendRepeatedly.scd instead of osc_sendOnce.scd.

### Troubleshooting

This section contains advice on a a number of common issues (to be updated as and when they occur)

#### Force Release A Socket in Python

\TODO/

What to do when this occur happens (a regular occurrence):

socket.error: [Errno 98] Address already in use

#### OSCFunc.trace

sclang features a trace method for debugging incoming OSC messages. This is a good way test to see if messages are reaching sclang at all. From the sclang command line simply type:  
`OSCFunc.trace`  

#### Discussion of Sending Messages from SuperCollider to Python

http://new-supercollider-mailing-lists-forums-use-these.2681727.n2.nabble.com/OSC-first-timer-problem-td5211207.html

### Additional Resources

http://doc.sccode.org/Guides/OSC_communication.html

#### Sensor examples: Beaglebone Pin-in/outs + OSC

NOTE: all the examples below require the Adafruit BBIO library in order to function.

For more on how to use OSC as part of a larger 'sound and sensors' project, see the ['soundvase' project code](../Projects/soundvase), and in particular the [python file](../Projects/soundvasesoundvase/soundvase.py) and [SuperCollider file](../Projects/soundvase/soundvase.scd).

Also see Fredrik Olofsson's approach here (uses sensors):
[receiving osc in python](https://github.com/redFrik/udk10-Embedded_Systems/tree/master/udk131128#--receiving-osc-in-python)
[sending osc to SuperCollider](https://github.com/redFrik/udk10-Embedded_Systems/tree/master/udk131128#--sending-osc-from-python-to-sc)
[read analogue and digital pins and send to another computer](https://github.com/redFrik/udk10-Embedded_Systems/tree/master/udk131114#--send-osc-example)

#### Other OSC Libraries

It is worth noting that there are other python libraries for OSC other than pyOSC e.g.:
* scosc, python OSC for supercollider: http://www.patrickkidd.com/
* SC 0.2, python client for SuperCollider http://pypi.python.org/pypi/SC/0.2


