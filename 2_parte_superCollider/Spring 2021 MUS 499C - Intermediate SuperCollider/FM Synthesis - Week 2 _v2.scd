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



///////////////////////////////
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
			modF = rrand(1, 15);
			escala = Scale.dorian.degrees;
			nota = {((escala.choose(0, 5) + 36) + (12*(1..3)).choose).midicps};
			//nota.value.postln;
			Synth(\fm, [
				\freq, nota,
				\modfreq, modF,
				\modamp, exprand(1, 30),
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