// OSC Communication
// - listen to /oscTest messages coming from Python

"Waiting for /oscTest message from Python".postln;
OSCFunc({arg msg; ("Received" ++ msg).postln;}, '/oscTest');
