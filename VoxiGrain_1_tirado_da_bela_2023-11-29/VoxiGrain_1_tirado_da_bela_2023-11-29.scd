
s = Server.default;

s.options.numAnalogInChannels = 8;
s.options.numAnalogOutChannels = 2;
s.options.numDigitalChannels = 1;


s.options.blockSize = 64;
s.options.numInputBusChannels = 2;
s.options.numOutputBusChannels = 2;

s.options.postln;

s.waitForBoot{
	//
	//~platform = "desktop";
	~platform = "bela";
	//
	if( ~platform == "desktop"){
		"platform: desktop".postln;
		s.freeAll;
	};
	if( ~platform == "bela"){"platform: bela".postln};
	Routine({
		"server booted!".postln;
		// buffer allocation //////////////////////////
		b = Buffer.alloc(s, s.sampleRate * 5);
		s.sync;
		"buffer alocado!".postln;
		// open needed BUS channels ///////////////////
		~micBus = Bus.audio(s, 1);
		~ptrBus = Bus.audio(s, 1);
		~mstrBus = Bus.audio(s, 2);
		~accX_bus = Bus.audio(s, 1);
		~accY_bus = Bus.audio(s, 1);
		~accZ_bus = Bus.audio(s, 1);
		~hold_bus = Bus.audio(s, 1);
		~pot1_bus = Bus.audio(s, 1);
		~pot2_bus = Bus.audio(s, 1);
		~fader1_bus = Bus.audio(s, 1);
		~fader2_bus = Bus.audio(s, 1);
		s.sync;
		"bus abertos!".postln;
		// control functions declaration ///////////////////////////
		SynthDef(\inAnalogico_1, {
			var sig;
			if( ~platform == "desktop"){sig = \ui_in.ar(0)};
			if( ~platform == "bela"){sig = AnalogIn.ar(\in.kr(0))};
			Out.ar(\out.ar(0), sig);
		}).add;
		s.sync;
		SynthDef(\inDigital_1, {
			var sig;
			if( ~platform == "desktop"){sig = \ui_in.ar(0)};
			if( ~platform == "bela"){sig = DigitalIn.ar(\in.kr(0))};
			Out.ar(\out.ar(0), sig);
		}).add;
		s.sync;
		// audio functions declaration ///////////////////////////
		SynthDef(\mic, {
			var sig, local;
			sig = SoundIn.ar(\in.kr(0)) * \amp.kr(1);
			Out.ar(\out.kr(0), sig);
		}).add;
		s.sync;
		SynthDef(\ptr, {
			var sig, inSig=0, buf=\buf.kr(0), rate=\rate.kr(1);
			inSig = In.ar(\valBtn.ar(0));
			rate = (inSig-1) * -1;
			sig = Phasor.ar(0, BufRateScale.kr(buf)* rate, 0, BufFrames.kr(buf));
			Out.ar(\out.kr(0), sig);
		}).add;
		s.sync;
		SynthDef(\rec, {
			var ptr, sig;
			ptr = In.ar(\ptrIn.kr(0), 1);
			sig = In.ar(\micIn.kr(0), 1);
			BufWr.ar(sig, \buf.kr(0), ptr);
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
			minPtrDelay=1000, micBus_1=0;
			/////////////////////////////////////
			var sig, sigDel, env, densCtrl, durCtrl=0, rateCtrl, panCtrl=0, ptr, ptrRand,
			totalDelay, maxGrainDur, accX, accY, accZ,accXmin, accXmax, pot1, pot2, fader1, fader2, panMeu_1 = 0;
			/////////////////////////////////////
			// reading from control bus channels ///////////////////////////
			accX = In.ar(\gr_accX_bus.ar(0), 1);
			accY = In.ar(\gr_accY_bus.ar(0), 1);
			accZ = In.ar(\gr_accZ_bus.ar(0), 1);
			pot1 = In.ar(\gr_pot1_bus.ar(0), 1);
			pot2 = In.ar(\gr_pot2_bus.ar(0), 1);
			fader1 = In.ar(\gr_fader1_bus.ar(0), 1);
			fader2 = In.ar(\gr_fader2_bus.ar(0), 1);
			/////////////////////////////////////
			// mapping accelerometer sensor - descomentar para bela
			if( ~platform == "desktop"){
				accX = accX.linlin(0, 1.0, 0.0001, 1.0);
				accY = accY.linlin(0, 1.0, 0.0001, 1.0);
				accZ = accZ.linlin(0, 1.0, 0.0001, 1.0);
			};
			if( ~platform == "bela"){
				accX = accX.linlin(0.3, 0.47, 0.0001, 1.0);
				accY = accY.linlin(0.3, 0.47, 0.0001, 1.0);
				accZ = accZ.linlin(0.3, 0.47, 0.0001, 1.0);
			};
			/////////////////////////////////////
			rate = rate * (accX + 0.001) * 2; ////////////////////////////////// ACC X
			/////////////////////////////////////
			///   DENSIDADE
			env = EnvGen.kr(Env.asr(atk,1,rel), gate, doneAction:2);
			dens = dens.varlag(densLag);
			dens = dens * (fader1*10) +1; ///////////////////////////////////// FADER_1
			densCtrl = Select.ar(sync, [Dust.ar(dens), Impulse.ar(dens)]);
			rateCtrl = rate * LFNoise1.ar(100).exprange(1/rateRand, rateRand);
			panCtrl = Select.kr(accY.roundUp,
				[
					rrand(-1,1),
					rrand(-1,1),
					rrand(-1,1)
			]);
			/////////////////////////////////////
			ptrRand = (LFNoise1.ar(100).bipolar(ptrRandSamples))*(pot1*1000); /// POT 1
			/////////////////////////////////////
			totalDelay = max(ptrSampleDelay - ptrRand, minPtrDelay);
			ptr = In.ar(ptrBus, 1);
			ptr = ptr - totalDelay;
			ptr = ptr / BufFrames.kr(buf)*accX;
			maxGrainDur = (totalDelay / rateCtrl) / SampleRate.ir;
			durCtrl = (baseDur * LFNoise1.ar(100).exprange(1/durRand,durRand)) * ((pot2*3)+0.001);
			/////////////////////////////////////
			rateCtrl = rateCtrl * (fader2*3) + 0.2;
			/////////////////////////////////////
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
		}).add;
		s.sync;
		SynthDef(\mstrAudioOut, {
			var sig, sigMic, lpfFreq, revMix = 0.8, revRoom = 0.5,
			revDamp = 0.5, accX, accY, accZ, sigLow_L, sigLow_R, sigLow, inFreq;
			/////////////////////////////////////
			accX = In.ar(\gr_accX_bus.ar(0), 1);
			accY = In.ar(\gr_accY_bus.ar(0), 1);
			accZ = In.ar(\gr_accZ_bus.ar(0), 1);
			/////////////////////////////////////
			sig = In.ar(\in.kr(0), 2);
			revRoom = accZ;
			lpfFreq = accX.linexp(0, 1, 3000, 10000);
			sigMic = LPF.ar(In.ar(\micBus_1.kr(0), 1), lpfFreq);
			if( ~platform == "desktop"){sig = (sig*1.9) + (sigMic*1.3)};
			if( ~platform == "bela"){sig = (sig*4.9) + (sigMic*3)};
			sig = Clip.ar(sig, -0.9, 0.9);
			//
			/*
			inFreq = Pitch.kr(in: sig, initFreq: 440.0, minFreq: 35.0, maxFreq: 150, execFreq: 100.0,
				maxBinsPerOctave: 16, median: 1, ampThreshold: 0.01, peakThreshold: 0.5, downSample: 1, clar: 0);
			sigLow_L = Clip.ar((RLPF.ar(sig[0], inFreq, 0.2) * 3), -0.9, 0.9);
			sigLow_R = Clip.ar((RLPF.ar(sig[1], inFreq, 0.2) * 3), -0.9, 0.9);
			sig[0] = (sig[0]*0.5) + (sigLow_L*0.5);
			sig[1] = (sig[1]*0.5) + (sigLow_R*0.5);
			*/
			//
			sig = FreeVerb2.ar(sig[0], sig[1], revMix, revRoom, revDamp);
			sig = LPF.ar(sig, 16000);
			sig = HPF.ar(sig, 40);
			sig = Clip.ar(sig, -0.9, 0.9);
			Out.ar(\out.kr(0), sig);
		}).add;
		s.sync;
		"synthdefs adicionados!".postln;
		~ctrlGrp = Group.new;
		~micGrp = Group.after(~ctrlGrp);
		~ptrGrp = Group.after(~micGrp);
		~recGrp = Group.after(~ptrGrp);
		~granGrp = Group.after(~recGrp);
		~audioOutGrp = Group.after(~granGrp);
		s.sync;
		"grupos carregados!".postln;
		~x_accX = Synth(\inAnalogico_1, [\out, ~accX_bus, \in, 0], ~ctrlGrp);
		~x_accY = Synth(\inAnalogico_1, [\out, ~accY_bus, \in, 1], ~ctrlGrp);
		~x_accZ = Synth(\inAnalogico_1, [\out, ~accZ_bus, \in, 2], ~ctrlGrp);
		~x_hold = Synth(\inDigital_1, [\out, ~hold_bus, \in, 0], ~ctrlGrp);
		~x_pot1 = Synth(\inAnalogico_1, [\out, ~pot1_bus, \in, 3], ~ctrlGrp);
		~x_pot2 = Synth(\inAnalogico_1, [\out, ~pot2_bus, \in, 4], ~ctrlGrp);
		~x_fader1 = Synth(\inAnalogico_1, [\out, ~fader1_bus, \in, 5], ~ctrlGrp);
		~x_fader2 = Synth(\inAnalogico_1, [\out, ~fader2_bus, \in, 6], ~ctrlGrp);
		s.sync;
		Synth(\mic, [\in, 0, \out, ~micBus], ~micGrp);
		Synth(\ptr, [\buf, b, \out, ~ptrBus, \valBtn, ~hold_bus], ~ptrGrp);
		Synth(\rec, [\ptrIn, ~ptrBus, \micIn, ~micBus, \buf, b], ~recGrp);
		s.sync;
		"synths chamados!".postln;
		b.zero;
		~g = 2.collect({
			arg n;
			Synth(\gran, [
				\amp, n.linlin(0,-5,0,-10).dbamp, //0,4,-3,-20
				\buf, b,
				\out, ~mstrBus,
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
				\gr_accX_bus, ~accX_bus,
				\gr_accY_bus, ~accY_bus,
				\gr_accZ_bus, ~accZ_bus,
				\gr_pot1_bus, ~pot1_bus,
				\gr_pot2_bus, ~pot2_bus,
				\gr_fader1_bus, ~fader1_bus,
				\gr_fader2_bus, ~fader2_bus
			], ~granGrp);
		});
		s.sync;
		Synth(\mstrAudioOut, [
			\in, ~mstrBus,
			\out, 0,
			\gr_accX_bus, ~accX_bus,
			\gr_accY_bus, ~accY_bus,
			\gr_accZ_bus, ~accZ_bus,
			\micBus_1, ~micBus
		], ~audioOutGrp);
		s.sync;
		"a tocar!!".postln;
	}).play;
};

ServerQuit.add({ 0.exit }); // quit if the button is pressed
