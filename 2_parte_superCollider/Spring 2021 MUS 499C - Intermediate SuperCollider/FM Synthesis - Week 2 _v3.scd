s.boot;

(
SynthDef(\fm, {
	var sig, env;
	env = Env([0,1,0],[\atk.ir(0.01), \rel.ir(3)], [1,-1]).ar(2);
	sig = SinOsc.ar(\freq.kr(400));
	sig = Pan2.ar(sig, \pan.kr(0), \amp.kr(0.1));
	sig = sig * env;
	Out.ar(\out.ir(0), sig);
}).add;
)


(
p = Routine({
	loop{
		Synth(\fm);
		rrand(0.001,5).wait;
	}

}).play
)

p.stop;



///////////////////////////////////////////////////
FreqScope.new;


(
SynthDef(\fm, {
	var sig, mod, env;
	env = Env([0,1,0],[\atk.ir(0.01), \rel.ir(3)], [1,-1]).ar(2);
	mod = SinOsc.ar(\modfreq.kr(7), mul: \modamp.kr(20));
	sig = SinOsc.ar(\freq.kr(400) + mod);
	sig = Pan2.ar(sig, \pan.kr(0), \amp.kr(0.1));
	sig = sig * env;
	Out.ar(\out.ir(0), sig);
}).add;
)


(
p = Routine({

	var nota, escala, modF;
	loop{
		8.do{
			escala = Scale.dorian.degrees;
			nota = {((escala.choose(0, 5) + 36) + (12*(1..3)).choose).midicps};
			//nota.value.postln;
			Synth(\fm, [
				\freq, nota,
				\ratio,  exprand(1, 50).round,
				\modamp, rrand(1005, 1200),
				\atk, rrand(0.001,0.04),
				\rel, rrand(0.1, 3)
			]);
			rrand(0,0.5).wait;
		};
		rrand(0.001,3).wait;

	}

}).play
)

p.stop;


//////////////////////

~bus1 = Bus.audio(s, 2);



(
SynthDef(\reverb, {
	var sig;
	sig = In.ar(~bus1, 2);
	sig = FreeVerb2.ar(sig[0], sig[1], mix: \rev_mix.kr(0.8), room: \rev_room.kr(0.8), damp: \rev_damp.kr(0.1));
	sig = Clip.ar(sig, -0.8,0.8);
	Out.ar(0, sig);
}).add;
)


(
SynthDef(\fm, {
	var sig, mod, env;
	env = Env([0,1,0],[\atk.ir(0.01), \rel.ir(3)], [1,-1]).ar(2);
	mod = SinOsc.ar(
		\freq.kr(400) * \ratio.kr(4),
		mul: \freq.kr(400) * \ratio.kr(4) * (\index.kr(1) + LFNoise0.ar(10, 1).varlag(0.01))
	);
	sig = SinOsc.ar(\freq.kr(400) + mod);
	sig = Pan2.ar(sig, \pan.kr(0), \amp.kr(0.1));
	sig = sig * env;
	sig = LPF.ar(sig, \filter_freq.kr(800));
	Out.ar(\out.ir(~bus1), sig);
}).add;
)



~rev1 = Synth(\reverb);
(
~rev1.set(
	\rev_mix, 0.4,
	\rev_room, 1,
	\rev_damp, 0.9,
);
)
~rev1.free;




(
p.stop;
p = Routine({

	var nota, escala, modF;
	loop{
		8.do{
			escala = Scale.dorian.degrees;
			nota = {((escala.choose(0, 5) + 36) + (12*(1..2)).choose).midicps};
			//nota.value.postln;
			Synth(\fm, [
				\freq, nota,
				\ratio, exprand(1, 50).round,
				\index, exprand(1, 5).round,
				\atk, rrand(0.001,0.04),
				\rel, rrand(0.1, 3),
				\pan, rrand(-0.8,0.8),
				\filter_freq, exprand(700, 8000).round
			]);
			rrand(0,0.5).wait;
		};
		rrand(0.001,5).wait;

	}

}).play
)

p.stop;