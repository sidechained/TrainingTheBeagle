// OSC Communication
// - sending an OSC Message in SuperCollider (repeatedly)

n = NetAddr("127.0.0.1", 9001); //define address to send to here: localhost on port 9001

Routine({
    inf.do{
        n.sendMsg("\oscTest", 100); // send the message with osc-nametag and content (comma separated values)
        2.wait; // wait 2 seconds, then repeat it
    }
}).play

// to end this you have to type CMD + Period (.)
