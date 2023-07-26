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

s.boot;
(
s.waitForBoot({
	(
		{
			//s.freeAll;

			"server booted!".postln;
			b = Buffer.alloc(s, s.sampleRate * 5);


			s.sync;
			"buffer alocado!".postln;


			~micBus = Bus.audio(s, 1);
			~ptrBus = Bus.audio(s, 1);

			~accX_bus = Bus.audio(s, 1);
			~accY_bus = Bus.audio(s, 1);
			~accZ_bus = Bus.audio(s, 1);
			~hold_bus = Bus.control(s, 1);
			~pot1_bus = Bus.audio(s, 1);
			~pot2_bus = Bus.audio(s, 1);
			~fader1_bus = Bus.audio(s, 1);
			~fader2_bus = Bus.audio(s, 1);

			s.sync;
			"bus abertos!".postln;

			Routine({

				SynthDef(\synth_accX, {
					var sig;
					sig = AnalogIn.ar(0);
					Out.ar(\out.ar(0), sig);
				}).add;
				SynthDef(\synth_accY, {
					var sig;
					sig = AnalogIn.ar(1);
					Out.ar(\out.ar(0), sig);
				}).add;
				SynthDef(\synth_accZ, {
					var sig;
					sig = AnalogIn.ar(2);
					Out.ar(\out.ar(0), sig);
				}).add;


				SynthDef(\mic, {
					arg in=0, out=0, amp=1;
					var sig;
					sig = SoundIn.ar(in) * amp;
					Out.ar(out, sig);
				}).add;

				s.sync;

				SynthDef(\ptr, {
					arg out=0, buf=0, rate=1, digiPin=0;
					var sig, valBtn, ctrBtn=0, inc=0;

					//linhas novas
					valBtn = DigitalIn.ar(digiPin);
					rate = valBtn;

					sig = Phasor.ar(0, BufRateScale.kr(buf)*rate,0 , BufFrames.kr(buf));
					Out.ar(out, sig);
				}).add;


				s.sync;


				SynthDef(\rec, {
					arg ptrIn=0, micIn=0, buf=0;
					var ptr, sig;
					ptr = In.ar(ptrIn, 1);
					sig = In.ar(micIn, 1);
					BufWr.ar(sig, buf, ptr);
				}).add;


				s.sync;


				SynthDef(\gran, {
					arg amp=0.9, buf=0, out=0,
					atk=1, rel=1, gate=1,
					sync=1, dens=40, densLag=0,
					baseDur=0.05, durRand=1,
					rate=1, rateRand=1, rateLag=0,
					pan=0, panRand=0,
					grainEnv=(-1), ptrBus=0, ptrSampleDelay=20000, ptrRandSamples=5000,
					minPtrDelay=1000, micBus_1=0, gr_accX_bus=0;

					var sig, env, densCtrl, durCtrl, rateCtrl, panCtrl, ptr, ptrRand,
					totalDelay, maxGrainDur, accX, accY, accZ,accXmin, accXmax;


					accX = In.ar(gr_accX_bus, 1);
					accY = In.ar(gr_accY_bus, 1);
					accZ = In.ar(gr_accZ_bus, 1);


					//accX = AnalogIn.ar(0);
					//accY = AnalogIn.ar(1);
					//accZ = AnalogIn.ar(2);


					accX = accX.linlin(0.3, 0.5, 0.0, 1.0);
					accY = accY.linlin(0.3, 0.5, 0.0, 1.0);

					//accY .poll;

					rate = (rate * (accX * 0.25))+0.8;


					// FALTA O 3 analog in

					//accX.poll;

					env = EnvGen.kr(Env.asr(atk,1,rel), gate, doneAction:2);

					dens = dens.varlag(densLag);

					//////////////////////////////////////
					dens = dens * (AnalogIn.ar(5)*10)+1;



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

					//////////////////////////////////////
					durCtrl = durCtrl * (AnalogIn.ar(4)*10);
					//////////////////////////////////////
					rateCtrl = rateCtrl * (AnalogIn.ar(6)*2) + 0.1;


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
						maxGrains:20
					);

					sig = sig * env * amp;

					sig = sig + In.ar(micBus_1, 1);
					Out.ar(out, sig);
					s.sync
				}).add;
			}).play;


			s.sync;
			"synthdefs adicionados!".postln;

			~ctrlGrp = Group.new;
			~micGrp = Group.after(~ctrlGrp);
			~ptrGrp = Group.after(~micGrp);
			~recGrp = Group.after(~ptrGrp);
			~granGrp = Group.after(~recGrp);


			(0.5).wait; //se não tiver este dá erro
			s.sync;
			"grupos carregados!".postln;

			Synth(\synth_accX, [\out, ~accX_bus], ~ctrlGrp);
			Synth(\synth_accY, [\out, ~accY_bus], ~ctrlGrp);
			Synth(\synth_accZ, [\out, ~accZ_bus], ~ctrlGrp);


			Synth(\mic, [\in, 0, \out, ~micBus], ~micGrp);
			Synth(\ptr, [\buf, b, \out, ~ptrBus], ~ptrGrp);
			Synth(\rec, [\ptrIn, ~ptrBus, \micIn, ~micBus, \buf, b], ~recGrp);


			//(0.5).wait;
			s.sync;
			"synths chamados!".postln;



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
					\dens, 3,//exprand(20,40), //bom de mexer
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
					\micBus_1, ~micBus,
					\gr_accX_bus, ~accX_bus,
					\gr_accY_bus, ~accY_bus,
					\gr_accZ_bus, ~accZ_bus

				], ~granGrp);
			});


			s.sync;
			"a tocar!!".postln;


		}.fork;
	)
});
)


ServerQuit.add({ 0.exit }); // quit if the button is pressed
