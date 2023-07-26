(
SynthDef(\granulador_1, {
	var sig;
	sig = GrainBuf.ar(
		2, //numChannels
		Impulse.ar(10), // trigger
		6, // dur
		~b.bufnum,//buffer
		1, // rate playback
		s.sampleRate*2, //position
		2, //interpolation 2 = linear
		0, //pan
		-1, //env  -1 buil-in Hann
		512 //maxGrains
	);
	sig = sig * 0.5;
	Out.ar(0, sig
	);
}).add;
)

y = Synth.new(\granulador_1);


y.set(\vPlayBackRate, 0.2);
y.set(\mix, 0.6);
y.set(\room, 0.9);



~recBufSize;


y.free;


