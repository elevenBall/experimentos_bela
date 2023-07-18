//https://www.youtube.com/watch?v=WBqAM_94TW4
//SuperCollider Tutorial: 25. Granular Synthesis, Part I




(
{
	var sig;
	sig = GrainBuf.ar(
		2,
		Dust.ar(100),
		0.2,
		~b1,
		MouseX.kr(0.5,2.1),
		(
			Phasor.ar(0, MouseY.kr(0.1,2,1) * BufRateScale.ir(~b1), 0, BufSamples.ir(~b1) -1)
			+ LFNoise1.ar(100).bipolar(0.0 * SampleRate.ir)
		) / BufSamples.ir(~b1),
		2,
		0,
		-1,
		512
	);
	sig = sig * 0.4;
}.play
)


(
SynthDef(\gs, {
	arg sync=1, dens=20, dur=0.1, durRand=1, buf=~b1.bufnum,
	rate=1, pos=0, posSpeed=1, posRand=0,
	grainEnv=(-1), pan=0, panHz=0.1, panRand=0,
	atk=1, sus=2, rel=1, c0=1, c1=(-1), amp=1, out=0;

	var sig, env, densCtrl, durCtrl, posCtrl, panCtrl;

	env = EnvGen.ar(Env.new([0,1,1,0],[atk,sus,rel],[c0,0,c1]), doneAction:2);

	densCtrl = Select.ar(sync, [Dust.ar(dens), Impulse.ar(dens)]);

	durCtrl = dur * LFNoise1.kr(100).exprange(1/durRand,durRand);

	posCtrl = Phasor.ar(0, posSpeed * BufRateScale.kr(buf), 0, BufFrames.ir(buf));
	posCtrl = posCtrl + LFNoise1.kr(100).bipolar(posRand*SampleRate.ir);
	posCtrl = posCtrl / BufSamples.ir(buf);
	posCtrl = posCtrl + pos;

	panCtrl = pan + LFNoise1.kr(panHz).bipolar(panRand);

	sig = GrainBuf.ar(
		2,
		densCtrl,
		durCtrl,
		buf,
		rate,
		posCtrl,
		2,
		panCtrl,
		grainEnv
	);

	sig = sig * env * amp;

	Out.ar(out, sig);


}).add;
)



a = Synth(\gs, [\buf, ~b1]);
a.free;



/////////////////////////////////////////////////////////////////////////////////////////

(
Synth(\gs, [
	\buf, ~b1,
	\sync, 0,
	\dens, 400,
	\dur, 0.2,
	\posSpeed, 0.25,
	\pos, 0,
	\rate, 6.midiratio,
	\amp, 0.3,
	\sus, 5,
]);
)

/////////////////////////////////////////////////////////////////////////////////////////

(
~r0 = Routine.new({
	loop{
		(1..8).choose.do({
			var rate = [0,2,3,7,9,10].choose + 70;
			rate = rate.midicps * [2,1,0.5,0.25].choose;
			4.do({
				Synth(\gs, [
					\buf, ~b1,
					\sync, 1,
					\dens, rate * rrand(-0.15, 0.15).midiratio,
					\dur, 0.02,
					\pos, [0.01, 0.04, 0.05, 0.06].choose,
					\posSpeed, 0,
					\amp, exprand(0.15,0.25),
					\atk, exprand(1,4),
					\sus, 0,
					\rel, exprand(3,6),
					\pan, rrand(-0.8,0.8),
				]);
			});
			exprand(0.1,8).wait;
		});
	};
}).play;

~r1 = Routine.new({
	loop{
		(2..5).do({
			Synth(\gs, [
				\buf, ~b1,
				\sync, 1,
				\dens, [0.25,0.5,1,2,4,8].choose,
				\dur, exprand(0.001, 0.025),
				\pos, [0.1, 0.206, 0.0398, 0.0877].choose,
				\posSpeed, 0,
				\rate, [-2,0,12].choose.midiratio,
				\panHz, exprand(0.1,1),
				\panRand, 0.8,
				\atk, 3, \sus, 1, \rel, 3,
				\amp, exprand(0.25,0.6);
			]);
		});
		exprand(0.5,4).round(0.5).wait;
	};
}).play;

~r2 = Routine.new({
	loop{
		Synth(\gs,[
			\buf, b,
			\sync, 0,
			\dens, exprand(0.2,1),
			\dur, exprand(0.5,2),
			\pos, rrand(0.0,0.4),
			\posSpeed, rrand(-0.9,0.9),
			\rate, rrand(-10.0,-2.0).midiratio.neg,
			\panHz, 0.1,
			\panRand, 0.5,
			\amp, exprand(0.15, 0.4),
			\atk, 4, \sus, 0, \rel, 4,
		]);
		exprand(4,15).wait;
	};
}).play;
)


~r1.stop;
~r2.stop;
