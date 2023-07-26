s.boot;


SinOsc.ar(freq: 300, phase: 0, mul: 1, add: 0)





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

	Out.ar(\out.kr(0), sig);
}).add;
)



// versão sem iteração, mas se quiser tocar 5 notas?
(
Synth(
	\play,
	[
		buf: b.bufnum,
		rate: 0.midiratio,
		pan: 0,
		atk: 0.001,
		rel: 2,
		spos: 0
	]
);
)


(
r = Routine({
	[-3, 0, 2, 0, 1].do( { |n| // os valores do array passam pelo argumento aqui definido como n
		n = n + [11, 12, 0, -12, -24, -36].choose;
		Synth(
			\play,
			[
				buf: b.bufnum,
				rate: (n.midiratio * rrand(-0.2,0.2).midiratio) * [-1,1].choose,
				pan: 0,
				atk: exprand(0.002, 0.2),
				rel: exprand(0.3, 10),
				//spos: 0,
				spos: s.sampleRate * 3,
				amp: rrand(0.3, 1),
				loop: 1
			]
		);
		wait(rrand(0.01, 7));
	});
});

r.play;

)



SerialPort