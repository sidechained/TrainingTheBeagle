///////////////////////////////////
/*
SC Sketch for controlling Sounds through analog input.
Mixed mode:
One Monitor Ndef is scanning through two ongoing sound processes: a) A Tdef and b) an Ndef

*/
////////////////////////////////////


(
// Code for receiving OSC
s.waitForBoot({ // boot the server and then do the following:

	var synth;

	q = q ? ();
	b = Bus.control(s, 1); // make larger later if needed?


	// SETUP THE Sounds/Controls
	(
		Ndef(\monitor).play; // mixer for the two sounds
		Tdef(\poltergeist).set(\dir, 1, \freq, 1000, \sustain, 2);
		Ndef(\crossroads).play;
		Ndef(\crossroads).end;
	);

	// the actual sound processes:
	(
		Ndef(\monitor, { |amp=1|
			// read 4 input channels from 3 upwards
			var selector = In.kr(b,1).round(1); //MouseX.kr(0,3).round(1)
			// needs inFeedback or not?
			SelectX.ar(selector, [InFeedback.ar([3,4]), Ndef(\crossroads).ar]) * amp
		})

	);


	/// Our SynthDefs

	(

		(
			SynthDef('grainXLine', { arg out = 0, freq=800, sustain=0.01, amp=0.5, pan = 0.0;
				var window;
				window = Env.new([ amp, 0.001 ], [ sustain ], 'exponential');
				Out.ar(out,
					Pan2.ar(
						(SinOsc.ar(freq) * EnvGen.ar(window, doneAction:2)).clip2(1),
						pan
					)
				)
			}).add;
		);

		(
			SynthDef('hatXLRev', { arg out = 0, freq=8000, sustain=0.01, amp=0.5, pan = 0.0;
				var window;
				window = Env.new([ 0.001, amp ], [ sustain ], 'exponential');
				Out.ar(out,
					Pan2.ar(
						BPF.ar(ClipNoise.ar, freq, 0.1),
						pan,
						3
					) * EnvGen.ar(window, doneAction:2)
				)
			}).add;
		);


	);

	/////////////////////////////////////
	// the two test sounds
	(
		Tdef(\poltergeist, { |env|
			inf.do{

				10.do{
					var dir,sound;
					dir = env[\dir]; //[0,1].choose;
					sound = ['hatXLRev', 'grainXLine']@dir.round(0.5); // make it a bit xfade
					( 'instrument': sound, 'freq': env[\freq] * (8.0.rand + 0.4), 'sustain': env[\sustain], 'amp': exprand(0.3,0.5), 'pan': 0, 'out': 3	).play;

					0.1.wait;
				};

				[0.5,1,3].choose.wait;


			}
		});

		(
			Ndef(\crossroads, {arg rate=0.1, amp=1, freq=200, bass=0.3;
				var in, son, filt, rand, mod, which;
				in = SoundIn.ar(0,0.1);
				son = WhiteNoise.ar(20);
				rand = TRand.kr(0.1, 10, Dust.kr(rate));
				mod = [LFSaw.kr(rate*rand).range(0.5,2), LFTri.kr(rate*rand, 1).range(0.5,2)]@0;
				filt = BBandPass.ar(son, freq * mod, 0.1,  LFNoise1.kr(rate)).softclip;
				son = Pan2.ar(filt, LFNoise1.kr(LFNoise0.kr(rate)), amp) + BLowPass.ar(son, freq/3, 1, bass);
				Limiter.ar(son);
			})
		);

	);

	s.sync; // wait until the synth has been added to the server before continuing

	Tdef(\poltergeist).play;


	// listen for a /shift OSC message (from Python), and set the \shift parameter of the synth according to the float provided in the OSC message:
	OSCFunc({arg msg;
		var val;
		val = msg[1];
		msg.postln;
		b.set(val.linlin(0,400,0,4.0));
		// use more AnalogIns to change sound params!
		// Tdef(\poltergeist).set(\dir, msg[2].linlin(0,150,0,1), \freq, msg[3].linexp(0,150,130,2000), \sustain, msg[4].linlin(0,150,0.1,4));
		// 	Ndef(\crossroads).set(\rate, msg[2].linexp(0,150,0.1,30), \freq, msg[3].linexp(0,150,100,4000), \bass, msg[4].linlin(0,150,0,2.0));

		// no sound if no input!
		if((val > 0), {Ndef(\monitor).play;}, {Ndef(\monitor).stop});

	}, '/gsr');

})

);



