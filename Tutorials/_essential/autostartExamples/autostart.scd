// autostart.scd
// - a simple SuperCollider patch which receives photoresistor values from Python and uses them to change the frequency of a sine wave

(
s.waitForBoot({ // boot the server then do something
        var synth;
        SynthDef("lightFreq", { arg shift = 0.5; Out.ar([0, 1], SinOsc.ar(shift.linexp(0, 1, 440, 880)) }).add; // s
        s.sync; // wait for the synthDef to be loaded before continuing
        synth = Synth("lightFreq");
        OSCFunc({arg msg; // listen to messages from Python
                var ldrValue;
                ldrValue = msg[1];
                msg.postln;
                synth.set(\light, ldrValue);
        }, '/light');

})
)