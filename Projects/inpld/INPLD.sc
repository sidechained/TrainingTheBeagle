// Basic node discovery and networking code
// to run this code, make sure NMLAddressing.sc and OSCDataSpace.sc are in your extensions folder on the Beaglebone

// NOTE: dig0 is the 0 or 1 value, adc0 is the continuous value

INPLD {

	var pythonReceivePort, nodeName, <node, <dataspace;

	*new {arg argNodeName, argPythonReceivePort = 9000;
		^super.new.initINPLD(argNodeName);
	}

	initINPLD {arg argNodeName, argPythonReceivePort;
		pythonReceivePort = argPythonReceivePort;
		nodeName = argNodeName;
		node = NMLDecentralisedNode.new(
			doWhenMeAdded: {this.doWhenMeAdded}
		)
	}

	doWhenMeAdded {
		inform(nodeName ++ "came online");
		node.register(nodeName);
		this.initLocalPythonResponder;
		this.initSoundParameterResponders;
		this.initDataSpace;
		// add sound bootup and Ndef initialisation here
	}

	initLocalPythonResponder {
		// receive sensing values locally from Python
		// open the receive port
		thisProcess.openUDPPort(pythonReceivePort);
		OSCFunc({arg msg;
			// - for binary 0 or 1 trigger values
			var value;
			value = msg[1];
			inform("received" ++ msg ++ "from python");
			node.addrBook.sendAll('\fromNetwork\dig0', value)
		}, '\fromPython\dig0'
			//, recvPort: pythonReceivePort
		);
		OSCFunc({arg msg;
			// - for continuously streaming values
			var value;
			value = msg[1];
			inform("received" ++ msg ++ "from python");
			node.addrBook.sendAll('\fromNetwork\adc0', value)
		}, '\fromPython\adc0'
			//, recvPort: pythonReceivePort
		);
	}

	initSoundParameterResponders {
		// Q: do we need to know who the data is coming from?
		// A: yes, need to reconcile this sender's IP with the nodename in the address book
		OSCFunc({arg msg, time, addr, recvPort;
			var nodeNameOfSender;
			inform("received" ++ msg ++ "from network");
			nodeNameOfSender = this.getPlayerNameFromSenderIP(addr.ip);
			case
			{ nodeNameOfSender = 'player1'} { this.changePlayer1TriggerValue(msg[1]) }
			{ nodeNameOfSender = 'player2'} { this.changePlayer2TriggerValue(msg[1]) };
		}, '\fromNetwork\dig0', recvPort: node.me.addr.port);
		OSCFunc({arg msg, time, addr, recvPort;
			var nodeNameOfSender;
			inform("received" ++ msg ++ "from network");
			nodeNameOfSender = this.getPlayerNameFromSenderIP(addr.ip);
			case
			{ nodeNameOfSender = 'player1'} { this.changePlayer1ContinuousValue(msg[1]) }
			{ nodeNameOfSender = 'player2'} { this.changePlayer2ContinuousValue(msg[1]) };
		}, '\fromNetwork\adc0', recvPort: node.me.addr.port);
	}

	getPlayerNameFromSenderIP {arg senderIP;
		// looks up sender's IP in the address book, and if found
		if (node.addrBook.includes(senderIP)) {
			var nodeNameOfSender;
			nodeNameOfSender = node.addrBook.findKeyForValue(senderIP);
			// note that if there is more than one nodeNameOfSender with the same IP this will find the 'first' one
			// (as dictionaries are unordered, the first one is essentially random)
			// this should not be a problem for us, but could cause difficulties when testing locally
			inform("found player" + nodeNameOfSender + "in addr book!");
			^nodeNameOfSender
		} {
			warn("player not known!")
		};
	}

	initDataSpace {
		var oscPath;
		oscPath = '/' ++ nodeName;
		inform("initialising data space for: " ++ oscPath);
		dataspace = OSCDataSpace(node.addrBook, node.me, oscPath);
	}

	changePlayer1TriggerValue {arg value;
		inform("triggering: " ++ value);
		// sound triggering code goes here
	}

	changePlayer1ContinuousValue {arg value;
		inform("continuousing: " ++ value);
		// sound continuous value code goes here
	}

	changePlayer2TriggerValue {arg value;
		inform("triggering: " ++ value);
		// sound triggering code goes here
	}

	changePlayer2ContinuousValue {arg value;
		inform("continuousing: " ++ value);
		// sound continuous value code goes here
	}

}
