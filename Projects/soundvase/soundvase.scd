// Soundvase Project - sclang file
// - does three very simple things:
// - 1. sends a simple pitchshifter SynthDef to the local server
// - 2. runs a single instance of the SynthDef as a synth
// - 3. listens for OSC messages e.g. '/shift 53.2' and sets the shift parameter of the synth accordingly

(
s.waitForBoot({ // boot the server and then do the following:

	var synth;

	// define a simple FFT based pitch shifting SynthDef, and send it to the server
	SynthDef("pitchShift", { arg out=0, shift = 0.5;
		    var in, chain;
		    in = SoundIn.ar(0);
		    chain = FFT(LocalBuf(2048), in);
		    chain = PV_BinShift(chain, shift.linexp(0, 1, 0.25, 4)); // .linexp can be adjusted to smooth out nonlinearities in the sensor values
		    Out.ar(out, 0.5 * IFFT(chain).dup); // .dup here makes the sound come out of both the L + R channel (instead of just L)
	}).add;
	s.sync; // wait until the synth has been added to the server before continuing
	synth = Synth("pitchShift"); // create a synth

	// listen for a /shift OSC message (from Python), and set the \shift parameter of the synth according to the float provided in the OSC message:
	OSCFunc({arg msg;
		var shift;
		shift = msg[1];
		msg.postln;
		synth.set(\shift, shift);
	}, '/shift');

})
)
