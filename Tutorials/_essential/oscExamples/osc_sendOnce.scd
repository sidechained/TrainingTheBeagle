// OSC Communication
// - sending an OSC Message in SuperCollider (once)

n = NetAddr("127.0.0.1", 9001);
"Sending '/oscTest 100' message to Python".postln;
n.sendMsg("/oscTest", 100);
