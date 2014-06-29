## Using Bluetooth for Audio

This is a test case for using a bluetooth audio device such as a wireless headphone or a mobile phone speaker (sound dwarf / DOSS asimom) for audio playback and recording.

Testing was done in SuperCollider. 
Devices used were: 
- B-Speech JASS:
http://www.b-speech.de/de/produkt-information/headsets/b-speech_jass/
- DOSS Asimom:
http://www.optiontech.com.hk/doss/DS-1168.html


#### Testcode: 

Server.killAll;
__Note:__ In SuperCollider the server cannot reboot on the fly with new BT audio device, it needs to be shutdown properly or killed
`Server.killAll;`

Then use these lines: 
```
s.boot;
s.meter;

// AUDIO INPUT / MIC
Ndef(\audioIn, {SoundIn.ar(0, MouseY.kr(0,2))}).play
Ndef(\audioIn).stop

// SOUND PLAYBACK: SINE
Ndef(\sine, {SinOsc.ar(MouseX.kr(20,14000,1).poll(10)) * MouseY.kr(0.1,1)}).play
Ndef(\sine).end

// test Bass frequencies
Ndef(\kick, { EnvGen.kr(Env.perc(0.01,LFNoise0.kr(1,0.3,0.31)), Dust.kr(4)) * SinOsc.ar(4200 * LFNoise0.kr(1).range(1,1.1)) }).play

Ndef(\kick).end
```

#### GENERAL Observations

- Latency! Big problem. It's more than 1 sec
- speech quality is low low
- sound quality is really biased by the transmission.
- On both devices it sounds really mid-EQd

- B-Speech Jass goes down lower in a decent quality, always noisy, but less clicks
- But in higher registers the band-compression noise is really audible. sounds much more distorted than asimom

- kicks sound almost like a snaredrum! a lot of channel noise, and artefacts of compression.

- and works only from 120 Hz upwards, below it needs a lot of signal and klicks a lot

- upper band limit is 4000 Hz! @4kHz there is almost no sound! seems like the carrier freq
- above 4000 it goes down again. At 8000 it's at bottom again and then goes up. At 12kHz it's like 4kHz.etc

- to repeat: every sound has a lot of noise included!
