s.boot;

(
SynthDef.new(\sine, {
	arg freq=440, atk=0.005, rel=0.3, amp=1, pan=0;
	var sig, env;
	sig = SinOsc.ar(freq);
	env = EnvGen.kr(Env.new([0,1,0],[atk,rel],[1,-1]), doneAction:2);
	sig = sig * env;
	Out.ar(0, sig);
}).add;
)


x = Synth(\sine);

(
e = Pdef(
	\sinepat,
	Pbind(
		\instrument, \sine,
		\dur, Pwhite(0.05, 0.5, inf),
		\midinote, Pseq([38],inf),
		\harmonic, Pexprand(1, 4, inf).round,
		\atk, Pwhite(0.005, 0.01, inf),
		\rel, Pwhite(0.01, 0.4, inf),
		\amp, Pkey(\harmonic).reciprocal * 0.3,
		\pan, Pwhite(-0.8, 0.8, inf),
	);
).play;
)

e.stop;

