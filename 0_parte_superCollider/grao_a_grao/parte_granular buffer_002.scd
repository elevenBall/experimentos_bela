(
SynthDef(\granulador_1, {
	arg vPlayBackRate = 1, vDuration = 1, vPosition = 0.5, vRateTrig = 20, mix = 0.25, room = 0.65, damp = 0.5;
	var sig;
	vPosition = LFNoise0.kr(100).range(0, 1).lag(3);
	vDuration = LFNoise0.kr(100).range(0.00001, 0.3);
	vRateTrig = LFNoise0.kr(100).range(20, 200);
	vPlayBackRate = LFNoise0.kr(100).range(-1, 1);

	sig = GrainBuf.ar(
		2,
		Impulse.ar(vRateTrig.lag(0)),
		vDuration,
		~b.bufnum,
		vPlayBackRate.lag(1),
		vPosition.lag(0),
		2,
		0,
		-1,
		512
	);
	sig = sig * 0.5;
	Out.ar(0, FreeVerb.ar(
            sig, // mono src
            mix, // mix 0-1
            room, // room 0-1
            damp // damp 0-1 duh
        ) ! 2 // fan out...
    );
}).add;
)

y = Synth.new(\granulador_1);


y.set(\vPlayBackRate, 0.2);
y.set(\mix, 0.6);
y.set(\room, 0.9);




y.free;


