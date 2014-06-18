// OSC Communication
// - sending an OSC Message in SuperCollider (repeatedly)

n = NetAddr("127.0.0.1", 9001);

Routine({
	inf.do{
		"Sending '/oscTest 100' message to Python".postln;
		n.sendMsg("/oscTest", 100);
		2.wait;
	}
}).play;
