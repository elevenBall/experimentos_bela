s.boot;

b = Buffer.read(s, "audio/bowl_1.aiff".resolveRelative);


b.play;


(
SynthDef(\play, {
	var sig, env;

	sig = PlayBuf.ar(
		numChannels: 2,
		bufnum: \buf.kr(0),
		rate: BufRateScale.kr(\buf.kr(0)) * \rate.kr(1),
		startPos: \spos.kr(0),
		loop: \loop.kr(0)
	);

	env = EnvGen.kr(
		Env(
			levels: [0, 1, 0],
			times: [\atk.ir(0.02), \rel.ir(3)],
			curve: [-2, -4]
		),
		doneAction: 2
	);

	sig = Pan2.ar(sig, \pan.kr(0));
	sig = sig * env;
	sig = sig * \amp.kr(0.4);
	sig = HPF.ar(sig, 20);

	Out.ar(\out.kr(0), LPF.ar(sig, 3000));//2
}).add;
)

(
~noteGen = Routine({
	var pch;
	inf.do({
		pch = -12;
		8.do({
			pch.yield;
			pch = pch + rrand(1,6);
		});
	});
});

(
~soundGen = Routine({
	inf.do({
		Synth(\play, [buf: b, rate: ~noteGen.next.midiratio]);
		0.25.yield;
	});
});
))

~soundGen.play;
~soundGen.stop;



TempoClock.default.tempo;

t = TempoClock(72/60).permanent_(true); //permanente makes it survive to 'cmmd + period'

t.beats;

t.stop;













