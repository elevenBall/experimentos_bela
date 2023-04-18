///////   bela board config section   /////////////
/*
s = Server.default;

s.options.numAnalogInChannels = 8;
s.options.numAnalogOutChannels = 8;
s.options.numDigitalChannels = 16;

s.options.blockSize = 16;
s.options.numInputBusChannels = 2;
s.options.numOutputBusChannels = 2;

s.options.postln;
*/
(

s.waitForBoot({
	(
		{
			"server booted!".postln;

			b = Buffer.alloc(s, s.sampleRate * 5);

			"buffer alocado!".postln;
			(0.5).wait;
			s.sync;

			~micBus = Bus.audio(s, 1);
			~ptrBus = Bus.audio(s, 1);


			//linhas novas
			//~holdBus = Bus.audio(s, 1);


			"bus abertos!".postln;
			(0.5).wait;
			s.sync;

			Routine({
			SynthDef(\mic, {
				arg in=0, out=0, amp=1;
				var sig;
				sig = SoundIn.ar(in) * amp;
				Out.ar(out, sig);
			}).add;

			SynthDef(\ptr, {
				arg out=0, buf=0, rate=1, digiPin=0;
				var sig, valBtn, ctrBtn=0, inc=0;

				//linhas novas
				valBtn = DigitalIn.ar(digiPin);

				/*
				if(ctrBtn==0 && valBtn==1)
				{
				inc=inc+1;
				rate = inc%2;
				ctrBtn = 1;
				};
				*/
				rate = valBtn;
				//rate.poll;
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
				arg amp=0.9, buf=0, out=0,
				atk=1, rel=1, gate=1,
				sync=1, dens=40, densLag=0,
				baseDur=0.05, durRand=1,
				rate=1, rateRand=1, rateLag=0,
				pan=0, panRand=0,
				grainEnv=(-1), ptrBus=0, ptrSampleDelay=20000, ptrRandSamples=5000,
				minPtrDelay=1000;

				var sig, env, densCtrl, durCtrl, rateCtrl, panCtrl, ptr, ptrRand,
				totalDelay, maxGrainDur, accX, accY, accZ,accXmin, accXmax;


				accX = AnalogIn.ar(0);
				accY = AnalogIn.ar(1);
				accZ = AnalogIn.ar(2);


				accX = accX.linlin(0.3, 0.5, 0.0, 1.0);
				accY = accY.linlin(0.3, 0.5, 0.0, 1.0);

				//accY .poll;

				rate = (rate * (accX * 0.25))+0.8;



				//accX.poll;

				env = EnvGen.kr(Env.asr(atk,1,rel), gate, doneAction:2);
				dens = dens.varlag(densLag);
				densCtrl = Select.ar(sync, [Dust.ar(dens), Impulse.ar(dens)]);
				durCtrl = baseDur * LFNoise1.ar(100).exprange(1/durRand,durRand);

				durCtrl = durCtrl * (accY * 1);

				rateCtrl = rate * LFNoise1.ar(100).exprange(1/rateRand, rateRand);
				panCtrl = pan + LFNoise1.kr(100).bipolar(panRand);

				ptrRand = (LFNoise1.ar(100).bipolar(ptrRandSamples))*accX;

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
					maxGrains:7
				);

				sig = sig * env * amp;
				Out.ar(out, sig);
				//s.sync;
			}).add;
			}).play;

			"synthdefs adicionados!".postln;
			(0.5).wait;
			s.sync;
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
			s.sync;
			b.zero;
			~g = 2.collect({ // val original 25
				arg n;
				Synth(\gran, [
					\amp, n.linlin(0,-5,0,-10).dbamp, //0,4,-3,-20
					\buf, b,
					\out, 0,
					\atk, 1,
					\rel, 1,
					\gate, 1,
					\sync, 1,
					\dens, 30,//exprand(20,40), //bom de mexer
					\baseDur, 0.5,
					\durRand, 1, //min 1
					\rate, 1, // pitch bom pa mexer
					\rateRand, 1, //min 1
					\pan, 0.5,
					\panRand, 0,
					\grainEnv, -1,
					\ptrBus, ~ptrBus,
					\ptrSampleDelay, n.linlin(0,4,20000, s.sampleRate*2),//s.sampleRate/3,
					\ptrRandSamples,100, //bom de mexer
					\minPtrDelay, 1000, //bom de mexer
				], ~granGrp);
			});


			"a tocar!!".postln;
			(0.5).wait;

		}.fork;
	)
});
)


ServerQuit.add({ 0.exit }); // quit if the button is pressed
