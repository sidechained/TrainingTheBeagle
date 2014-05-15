(
s.waitForBoot({

	var synth;

	SynthDef("pitchShift", { arg out=0, shift = 0.5;
		    var in, chain;
		    in = SoundIn.ar(0);
		    chain = FFT(LocalBuf(2048), in);
		    chain = PV_BinShift(chain, shift.linexp(0, 1, 0.25, 4));
		    Out.ar(out, 0.5 * IFFT(chain).dup);
	}).add;
	s.sync;

	synth = Synth("pitchShift");

	OSCFunc({arg msg;
		var shift;
		shift = msg[1];
		msg.postln;
		synth.set(\shift, shift);
	}, '/shift');

})
)
