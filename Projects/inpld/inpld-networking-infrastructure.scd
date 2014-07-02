// Basic node discovery and networking code
// to run this code, make sure NMLAddressing.sc and OSCDataSpace.sc are in your extensions folder on the Beaglebone

INPLD {

	var nodeName, node, <dataspace;

	*new {arg argNodeName, argPythonReceivePort = 9000;
		^super.new.initINPLD(argnodeName);
	}

	initINPLD {arg argNodeName;
		pythonReceivePort = argPythonReceivePort;
		nodeName = argNodeName;
		node = NMLDecentralisedNode.new(
			doWhenMeAdded: {this.doWhenMeAdded}
		)
	}

	doWhenMeAdded {
		node.register(nodeName);
		this.initLocalPythonResponder;
		this.initSoundParameterResponders;
		this.initDataSpace;
	}

	initLocalPythonResponder {
		// receive sensing values locally from Python
		OSCFunc({arg msg;
			msg.postln;
			this.sendTrigger(value);
		}, '\fromPython\trigger', recvPort: pythonReceivePort);
		OSCFunc({arg msg;
			msg.postln;
			this.sendContinuous(value);
		}, '\fromPython\continuous', recvPort: pythonReceivePort);	
	}

	sendTrigger {
		// send the trigger value over the network (to all peers including self)
		// Q: how to do the sending? check Chinese Whispers code
	}

	sendContinuous {
		// send the trigger value over the network (to all peers including self)
		// Q: how to do the sending? check Chinese Whispers code
	}

	initSoundParameterResponders {
		// Q: do we need to know who the data is coming from?
		// A: yes, need to reconcile this sender's IP with the nodename in the address book
		OSCFunc({arg msg;
			msg.postln;
			this.changeTrigger(value); // pass sender name here as well?
		}, '\dig0', recvPort: node.me.addr.port);
		OSCFunc({arg msg;
			msg.postln;
			this.changeContinuous(value); // pass sender name here as well?
		}, '\adc0', recvPort: node.me.addr.port);
	}

	initDataSpace {
		var oscPath;
		oscPath = '/' ++ nodeName;
		inform("initialising data space for: " ++ oscPath);
		dataspace = OSCDataSpace(node.addrBook, node.me, oscPath);
	}

	changeTrigger {arg value;
		inform("triggering: " ++ value);
		// sound triggering code goes here
	}

	changeContinuous {arg value;
		inform("continuousing: " ++ value);
		// sound continuous value code goes here
	}

}
