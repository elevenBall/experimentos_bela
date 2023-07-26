(
SynthDef(\liveGrain_1, { | out = 0 |
	var sig;
	var input = SoundIn.ar(~micIn);
	sig = GrainIn.ar(
		1, //numChannels
		Impulse.kr(1), // trigger
		0.1, //dur
		input, //in
		0, //pan
		-1, //env  -1 buil-in Hann
		512 //maxGrains
	);
	sig = sig * 0.5;
	Out.ar(out, sig!2);
}).add;
)

v = Synth(\liveGrain_1);
v.free;
