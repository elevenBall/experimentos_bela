(
SynthDef(\granulador_1, {
	| grainDur = 1, pbRate =1, position = 0, pan = 0, trigRate = 10, posiLag = 10, trigLag = 3|
	var sig;
	sig = GrainBuf.ar(
		2, //numChannels
		Impulse.ar(trigRate.varlag(trigLag)), // trigger
		grainDur, // dur
		~b.bufnum,//buffer
		pbRate, // rate playback
		position.varlag(posiLag), //position
		2, //interpolation 2 = linear
		pan, //pan
		-1, //env  -1 buil-in Hann
		512 //maxGrains
	);
	sig = sig * 0.5;
	Out.ar(0, sig!2);
}).add;
)

y = Synth.new(\granulador_1);


y.set(\position, 0.0);
y.set(\posiLag, 45);

y.set(\grainDur, 0.666);

y.set(\trigRate, 100);
y.set(\trigLag, 40);



~recBufSize;


y.free;


