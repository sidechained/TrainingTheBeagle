// Start Code for INPLD Beagle

// create instance
i = INPLD(\player1); // must be player1..3 currently

// turn off osc messages in postwindow
i.verbose_(true);
i.verbose_(false);


// HOW TO ACCESS THINGS IN THE ADDR BOOK...
q = q ? ();
q.myAddr = NetAddr("192.168.2.106", 57120);

i.node.addrBook
i.node.addrBook.dump
i.node.addrBook.dict; // the key and the value
i.node.addrBook.dict.values; // value is an NMLPeer
i.node.addrBook.dict.values.collect{|peer| peer.addr.ip}; // makes array of ip addrs from the peers in addrbook
i.node.addrBook.dict.values[0].addr; // gets addr of first peer in list
i.node.addrBook.names; // dict of registered peernames
i.node.addrBook.peers; // list of NMLPeers
i.node.addrBook.ids; // Set of Ids
i.node.addrBook.addrs; // Array of Netaddrs!
i.node.addrBook.atName(\player1).addr.ip; // returns the NMLPeer+addr+ip
i.node.addrBook.atId(0);

i.node.addrBook.addrs.includes(q.myAddr.ip); // always false, testing Netaddr vs. ip
i.node.addrBook.addrs.collect{|netaddr| netaddr.ip}; //new array to get only ips
i.node.addrBook.dict.values.collect{|peer| peer.addr.ip}; // same result

// this should work!
(i.node.addrBook.addrs.collect{|netaddr| netaddr.ip}).includes(q.myAddr.ip); // why always false?

// searches peers for ips and returns the first one found
q.myPeer = i.node.addrBook.peers.detect{|peer| peer.addr.ip == q.myAddr.ip};
// look up the dict key for that peer -> its just a number!
i.node.addrBook.dict.findKeyForValue(q.myPeer);
// find name for player is already in here:
q.myPeer.name;

/*
i.node.addrBook.peers
i.node.addrBook.dict.scanFor(0)
i.node.addrBook.dict.findKeyForValue(); // must be the exact Peer

(i.node.addrBook.addrs.collect{|netaddr| netaddr.ip}).includes(q.myAddr.ip);

q.ips.includes(q.myAddr.ip);
q.ips.includes(0);
q.ips[0].dump
q.myIp.dump


i.node.addrBook.findKeyForValue(0)
[q.myIp].includes(q.myIp);
*/
