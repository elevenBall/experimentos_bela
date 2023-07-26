/////base - https://www.youtube.com/watch?v=MnD8stNB5tE

//s = Server.default;
(
s.waitForBoot{
	(
		{
			"server booted!".postln;

			b = Buffer.alloc(s, s.sampleRate * 5);

			"buffer alocado!".postln;
			(0.5).wait;

			~micBus = Bus.audio(s, 1);
			~ptrBus = Bus.audio(s, 1);

			"bus abertos!".postln;
			(0.5).wait;

			SynthDef(\mic, {
				arg in=0, out=0, amp=1;
				var sig;
				sig = SoundIn.ar(in) * amp;
				Out.ar(out, sig);
			}).add;

			SynthDef(\ptr, {
				arg out=0, buf=0, rate=1;
				var sig;
				sig = Phasor.ar(0, BufRateScale.kr(buf)*rate,0 , BufFrames.kr(buf));
				Out.ar(out, sig);
			}).add;

			SynthDef(\rec, {
				arg ptrIn=0, micIn=0, buf=0;
				var ptr, sig;
				ptr = In.ar(ptrIn, 1);
				sig = In.ar(micIn, 1);
				BufWr.ar(sig, buf, ptr);
			}).add;

			SynthDef(\gran, {
				arg amp=0.5, buf=0, out=0,
				atk=1, rel=1, gate=1,
				sync=1, dens=40, densLag=0,
				baseDur=0.05, durRand=1,
				rate=1, rateRand=1, rateLag=0,
				pan=0, panRand=0,
				grainEnv=(-1), ptrBus=0, ptrSampleDelay=20000, ptrRandSamples=5000,
				minPtrDelay=1000;

				var sig, env, densCtrl, durCtrl, rateCtrl, panCtrl, ptr, ptrRand,
				totalDelay, maxGrainDur;


				env = EnvGen.kr(Env.asr(atk,1,rel), gate, doneAction:2);
				dens = dens.varlag(densLag);
				densCtrl = Select.ar(sync, [Dust.ar(dens), Impulse.ar(dens)]);
				durCtrl = baseDur * LFNoise1.ar(100).exprange(1/durRand,durRand);
				rateCtrl = rate * LFNoise1.ar(100).exprange(1/rateRand, rateRand);
				panCtrl = pan + LFNoise1.kr(100).bipolar(panRand);

				ptrRand = LFNoise1.ar(100).bipolar(ptrRandSamples);
				totalDelay = max(ptrSampleDelay - ptrRand, minPtrDelay);

				ptr = In.ar(ptrBus, 1);
				ptr = ptr - totalDelay;
				ptr = ptr / BufFrames.kr(buf);

				maxGrainDur = (totalDelay / rateCtrl) / SampleRate.ir;
				durCtrl = min(durCtrl, maxGrainDur);

				sig = GrainBuf.ar(
					2,
					densCtrl,
					durCtrl,
					buf,
					rateCtrl.varlag(rateLag),
					ptr,
					2,
					panCtrl,
					grainEnv,
					maxGrains:10
				);

				sig = sig * env * amp;
				Out.ar(out, sig);
				//s.sync;
			}).add;

			"synthdefs adicionados!".postln;
			(0.5).wait;

			~micGrp = Group.new;
			~ptrGrp = Group.after(~micGrp);
			~recGrp = Group.after(~ptrGrp);
			~granGrp = Group.after(~recGrp);

			"grupos carregados!".postln;
			(0.5).wait;

			Synth(\mic, [\in, 0, \out, ~micBus], ~micGrp);
			Synth(\ptr, [\buf, b, \out, ~ptrBus], ~ptrGrp);
			Synth(\rec, [\ptrIn, ~ptrBus, \micIn, ~micBus, \buf, b], ~recGrp);

			"synths chamados!".postln;
			(0.5).wait;

			b.zero;
			~g = 3.collect({ // val original 25
				arg n;
				Synth(\gran, [
					\amp, n.linlin(0,-5,0,-10).dbamp, //0,4,-3,-20
					\buf, b,
					\out, 0,
					\atk, 1,
					\rel, 1,
					\gate, 1,
					\sync, 1,
					\dens, 10,//exprand(20,40), //bom de mexer
					\baseDur, 0.08,
					\durRand, 1, //min 1
					\rate, 1, // pitch bom pa mexer
					\rateRand, 1, //min 1
					\pan, 0.5,
					\panRand, 0,
					\grainEnv, -1,
					\ptrBus, ~ptrBus,
					\ptrSampleDelay, n.linlin(0,4,20000, s.sampleRate*2),//s.sampleRate/3,
					\ptrRandSamples,10000, //bom de mexer
					\minPtrDelay, 1000, //bom de mexer
				], ~granGrp);
			});


			"a tocar!!".postln;
			(0.5).wait;

		}.fork;
	)
};
)

//hold
~ptrGrp.set(\rate, 1);
~ptrGrp.set(\rate, 0);

//parameters

~granGrp.set(\dens, 1);
~granGrp.set(\densLag, 60);
~granGrp.set(\amp, -10.dbamp);


~granGrp.set(\durRand, 3);
~granGrp.set(\baseDur, 1);


~granGrp.set(\rate, 1.00);
~granGrp.set(\rateRand, 36.8);
~granGrp.set(\rateLag, 5.01);


~granGrp.set(\panRand, 0.5);


~granGrp.set(\ptrSampleDelay, 10000);


~granGrp.set(\ptrRandSamples, 9000000);

~granGrp.set(\minPtrDelay, 1000);



~granGrp.free;








r = Recorder(s);
r.record(numChannels:2);
r.stopRecording;






