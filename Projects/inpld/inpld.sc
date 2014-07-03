// Basic node discovery and networking code
// to run this code, make sure NMLAddressing.sc and OSCDataSpace.sc are in your extensions folder on the Beaglebone

INPLD {

	var pythonReceivePort, nodeName, node, <dataspace;

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
		node.register(nodeName);
		this.initLocalPythonResponder;
		this.initSoundParameterResponders;
		this.initDataSpace;
		// add sound bootup and Ndef initialisation here
	}

	initLocalPythonResponder {
		// receive sensing values locally from Python
		OSCFunc({arg msg;
			var value;
			value = msg[1];
			msg.postln;
			this.sendTrigger(value);
		}, '\fromPython\trigger', recvPort: pythonReceivePort);
		OSCFunc({arg msg;
			var value;
			value = msg[1];
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
		OSCFunc({arg msg, time, addr, recvPort;
			var player;
			msg.postln;
			player = this.getPlayerNameFromSenderIP(addr.ip);
			case
			{ player = 'player1'} { this.changePlayer1TriggerValue(msg[1]) }
			{ player = 'player2'} { this.changePlayer2TriggerValue(msg[1]) };
		}, '\dig0', recvPort: node.me.addr.port);
		OSCFunc({arg msg, time, addr, recvPort;
			var player;
			msg.postln;
			player = this.getPlayerNameFromSenderIP(addr.ip);
			case
			{ player = 'player1'} { this.changePlayer1ContinuousValue(msg[1]) }
			{ player = 'player2'} { this.changePlayer2ContinuousValue(msg[1]) };
		}, '\adc0', recvPort: node.me.addr.port);
	}

	getPlayerNameFromSenderIP {arg senderIP;
		// looks up sender's IP in the address book, and if found
		if (node.addrBook.includes(senderIP)) {
			var player;
			player = node.addrBook.findKeyForValue(senderIP);
			// note that if there is more than one player with the same IP this will find the 'first' one
			// (as dictionaries are unordered, the first one is essentially random)
			// this should not be a problem for us, but could cause difficulties when testing locally
			inform("found player" + player + "in addr book!");
			^player
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
