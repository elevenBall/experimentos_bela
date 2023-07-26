s.boot;

b = Buffer.read(s, "audio/bowl_1.aiff".resolveRelative);

b = Buffer.read(s, "audio/okedo-A2.wav".resolveRelative);

~b1 = Buffer.read(s, "audio/01-230623_0958.wav".resolveRelative);

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

~sy.set(\rateMOD, 68);

(
~r = Routine({
	inf.do({
		[-3, 0, 2].do( { |n| // os valores do array passam pelo argumento aqui definido como n
			n = n + [11, 12, 0, -12, -24, -36].choose;
			Synth(
				\play,
				[
					buf: b.bufnum,
					rate: (((n.midiratio * rrand(-0.2,0.2).midiratio) * [-1,1].choose) + ~valY_s0.midiratio),
					pan: rrand( -1, 1),
					atk: exprand(0.002, 0.2),
					rel: exprand(0.3, 10),
					//spos: 0,
					spos: s.sampleRate * 3,
					amp: rrand(0.4, 0.7),
					loop: 1
				]
			);
			//wait(rrand(0.01, 7));
			0.25.yield;
		});
	});
});
)

~r.next;
~r.reset;
~r.play;
~r.stop;

(
~rt1 = Routine({
	inf.do({
		~r.next;
		wait(rrand(0.3,8));
	});
});
~rt1.play;
)
~rt1.stop;