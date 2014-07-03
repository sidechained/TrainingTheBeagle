// Sketch for using the

OSCFunc.trace(true)
OSCFunc.trace(false)

// Responders calling func
(
//for digis
OSCFunc({ |msg|
	q.soundFunc(msg[0], msg[1])
}, '/dig0');
// for adcs
OSCFunc({ |msg|
	q.soundFunc(msg[0], msg[1])
}, '/adc0')
)

///////
q = q ? ();
q.sounds = q.sounds ? [];
q.sounds = 5.collect{|i| var name= \soundbeam; (name++(i+1)).asSymbol};
q.sounds[0];
q.lastvals = [0.5,0];
(
q.soundFunc = {|q, msgType, val=0.5|
	var instrument = q.sounds[0];
	// cycle through sounds
	if ((msgType == '/adc0') && (val>0.3))
	{ q.lastvals[0]=val;
		q.lastvals[1]=q.lastvals[1]%q.sounds.size; instrument=q.sounds[q.lastvals[1]];
		q.lastvals[1]=q.lastvals[1]+1;
	};
	// trigger a sound
	if (msgType=='/dig0')
	{
		//(instrument: instrument, freq: \freq.asSpec.map(q.lastvals[0]), sustain:0.05).play
	}
};
);

/*
(instrument: \soundbeam1, freq: 400).play; // Noise
(instrument: \soundbeam2, freq: 200).play; // a Pluck Instrument
(instrument: \soundbeam3, freq: 600).play; // a random melody of sines
(instrument: \soundbeam4, freq: 400).play; // a percussive snare sound
(instrument: \soundbeam5, freq: 300).play; // a percussive tom sound
*/

//// THE SOUNDS
(
SynthDef(\soundbeam1, {arg out, amp=0.1, pan=0, freq=200,atk=0.1, sustain=1, noise=1, bw=0.2;
	var son, env;
	env=EnvGen.kr(Env.linen(atk, sustain), doneAction:2);
	son=BBandPass.ar(WhiteNoise.ar(noise), freq, bw).softclip;
	son=son*env;
	Out.ar(out, Pan2.ar(son, pan, amp));
}).add;


SynthDef(\soundbeam2, { |out=0,amp=0.1,sustain=1.0,freq=440,coef=0.5|
    var snd, env;
    snd = Pluck.ar(WhiteNoise.ar(1!2),
        Impulse.ar(0),
        freq.reciprocal,
        freq.reciprocal,
        sustain, coef: 0.5);
    env = EnvGen.ar(Env.perc(0.01,sustain), doneAction:2);
    OffsetOut.ar(out, snd * amp);
}).add;


SynthDef(\soundbeam3, { |out, amp=0.1, pan=0, t_trig=1, sustain=1, freq=300, mul=1|
	var snd, env, trig, switch;
	freq = ((Array.fib(7).normalizeSum.scramble * mul) + 1) * freq;
	freq = Duty.kr(Drand([0.05, 0.2, 0.1] * sustain, inf), t_trig, Dseq(freq) );
	snd = LFCub.ar(freq, 0, LFTri.kr(3*mul * sustain.reciprocal));
	env = EnvGen.ar(Env.linen(0.1,0.5,0.4), timeScale:sustain, doneAction:2);
	Out.ar(out, Pan2.ar(snd, pan, amp))
	}).add;

// PERCUSSIVE

(
SynthDef(\soundbeam4,
	{arg out = 0, sustain = 0.1, ring = 0.25, noise = 40, crisp = 1000,
	freq = 405, amp = 0.3, pan=0;
	var drum_mode_sin_1, drum_mode_sin_2, drum_mode_pmosc, drum_mode_mix, drum_mode_env;
	var snare_noise, snare_brf_1, snare_brf_2, snare_brf_3, snare_brf_4, snare_reson;
	var snare_env;
	var snare_drum_mix;

	drum_mode_env = EnvGen.ar(Env.perc(0.005, sustain), 1.0, doneAction: 2);
	drum_mode_sin_1 = SinOsc.ar(freq*0.53, 0, drum_mode_env * 0.5);
	drum_mode_sin_2 = SinOsc.ar(freq, 0, drum_mode_env * 0.5);
	drum_mode_pmosc = PMOsc.ar(	Saw.ar(freq*0.85),
					184,
					0.5/1.3,
					mul: drum_mode_env*5,
					add: 0);
	drum_mode_mix = Mix.new([drum_mode_sin_1, drum_mode_sin_2, drum_mode_pmosc]) * ring;

// choose either noise source below
//	snare_noise = Crackle.ar(2.01, 1);
	snare_noise = LFNoise0.ar(20000, 0.1);
	snare_env = EnvGen.ar(Env.perc(0.005, sustain), doneAction: 2);
	snare_brf_1 = BRF.ar(in: snare_noise, freq: 8000, mul: 0.5, rq: 0.1);
	snare_brf_2 = BRF.ar(in: snare_brf_1, freq: 5000, mul: 0.5, rq: 0.1);
	snare_brf_3 = BRF.ar(in: snare_brf_2, freq: 3600, mul: 0.5, rq: 0.1);
	snare_brf_4 = BRF.ar(in: snare_brf_3, freq: 2000, mul: snare_env, rq: 0.0001);
	snare_reson = Resonz.ar(snare_brf_4, crisp, mul: noise) ;

		snare_drum_mix = Mix([drum_mode_mix, snare_reson]) * amp;
	Out.ar(out, Pan2.ar(snare_drum_mix.tanh, pan))
	}
).add
);

/*
// example timbres
Synth(\soundbeam4, [\amp, 0.1, \noise, 1, \ring, 1, \sustain, 3, \crisp, 3000]);
Synth(\soundbeam4, [\amp, 0.2, \noise, 100, \ring, 1, \sustain, 0.1, \crisp, 10000]);
Synth(\soundbeam4, [\amp, 0.3, \noise, 1000, \ring, 5, \sustain, 0.3, \crisp, 100]);
Synth(\soundbeam4, [\amp, 0.7, \noise, 100, \ring, 0, \sustain, 1.3, \crisp, 10000]);
*/


(
SynthDef(\soundbeam5, 	{ arg out = 0, sustain = 0.4, ring = 0.25, 	freq = 190, timbre = 1.0, amp = 0.1,pan=0;

	var drum_mode_sin_1, drum_mode_sin_2, drum_mode_pmosc, drum_mode_mix, drum_mode_env;
	var stick_noise, stick_env;
	var drum_reson, tom_mix;

	drum_mode_env = EnvGen.ar(Env.perc(0.1, sustain), 1.0, doneAction: 2);
	drum_mode_sin_1 = SinOsc.ar(freq*0.8, 0, drum_mode_env * 0.5);
	drum_mode_sin_2 = SinOsc.ar(freq, 0, drum_mode_env * 0.5);
	drum_mode_pmosc = PMOsc.ar(	Saw.ar(freq*0.9),
								freq*0.85,
								timbre/1.3,
								mul: drum_mode_env*5,
								add: 0);

	drum_mode_mix = Mix.new([drum_mode_sin_1, drum_mode_sin_2, drum_mode_pmosc]) * ring;
	stick_noise = Crackle.ar(2.01, 1);
	stick_env = EnvGen.ar(Env.perc(0.005, 0.01), 1.0) * 3;
	tom_mix = Mix.new([drum_mode_mix, stick_env]) * amp;
	Out.ar(out, Pan2.ar(tom_mix, pan).softclip)
	}
).add
);
/*
// Examples
Synth(\soundbeam5, [\amp, 0.4]);
Synth(\soundbeam5, [\amp, 0.6, \freq, 400, \ring, 0.13, \timbre, 5, \sustain, 3]); // metal rods?
Synth(\soundbeam5, [\amp, 0.3, \freq, 300, \ring, 1, \timbre, 1.0, \sustain, 0.8]); // metal rods?
Synth(\soundbeam5, [\amp, 0.4, \freq, 200, \ring, 0.1, \timbre, 5.0, \sustain, 0.6]); // metal rods?
Synth(\soundbeam5, [\amp, 0.4, \freq, 330, \ring, 0.1, \timbre, 2.2, \sustain, 0.2]); // metal rods?
*/


);
