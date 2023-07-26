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

	//s.freeAll;

	"server booted!".postln;
	b = Buffer.alloc(s, s.sampleRate * 5);


	//s.sync;
	"buffer alocado!".postln;


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

	//s.sync;
	"bus abertos!".postln;

	(0.5).wait;
	SynthDef(\synth_accX, {
		var sig;
		sig = \ui_in.ar(0);
		//sig = AnalogIn.ar(0);
		Out.ar(\out.ar(0), sig);
	}).add;
	SynthDef(\synth_accY, {
		var sig;
		sig = \ui_in.ar(0);
		//sig = AnalogIn.ar(1);
		Out.ar(\out.ar(0), sig);
	}).add;
	SynthDef(\synth_accZ, {
		var sig;
		sig = \ui_in.ar(0);
		//sig = AnalogIn.ar(2);
		Out.ar(\out.ar(0), sig);
	}).add;

	SynthDef(\synth_hold, {
		var sig;
		sig = \ui_in.ar(0);
		//sig = DigitalIn.ar(0);
		Out.ar(\out.ar(0), sig);
	}).add;

	SynthDef(\synth_pot1, {
		var sig;
		sig = \ui_in.ar(0);
		//sig.poll;
		//sig = AnalogIn.ar(3);
		Out.ar(\out.ar(0), sig);
	}).add;
	SynthDef(\synth_pot2, {
		var sig;
		sig = \ui_in.ar(0);
		//sig = AnalogIn.ar(4);
		Out.ar(\out.ar(0), sig);
	}).add;

	SynthDef(\synth_fader1, {
		var sig;
		//sig = AnalogIn.ar(5);
		sig = \ui_in.ar(0);
		Out.ar(\out.ar(0), sig);
	}).add;
	SynthDef(\synth_fader2, {
		var sig;
		sig = \ui_in.ar(0);
		//sig = AnalogIn.ar(6);
		Out.ar(\out.ar(0), sig);
	}).add;

	//s.sync;

	SynthDef(\mic, {
		arg in=0, out=0, amp=1;
		var sig;
		sig = SoundIn.ar(in) * amp;
		Out.ar(out, sig);
	}).add;

	//s.sync;

	SynthDef(\ptr, {
		arg out=0, buf=0, rate=1;
		var sig;
		rate = In.ar(\valBtn.ar(0));
		sig = Phasor.ar(0, BufRateScale.kr(buf)*rate, 0, BufFrames.kr(buf));
		Out.ar(out, sig);
	}).add;

	//s.sync;

	SynthDef(\rec, {
		arg ptrIn=0, micIn=0, buf=0;
		var ptr, sig;
		ptr = In.ar(ptrIn, 1);
		sig = In.ar(micIn, 1);
		BufWr.ar(sig, buf, ptr);
	}).add;

	//s.sync;

	SynthDef(\gran, {
		arg amp=0.9, buf=0, out=0,
		atk=1, rel=1, gate=1,
		sync=1, dens=40, densLag=0,
		baseDur=0.05, durRand=1,
		rate=1, rateRand=1, rateLag=0,
		pan=0, panRand=0,
		grainEnv=(-1), ptrBus=0, ptrSampleDelay=20000, ptrRandSamples=5000,
		minPtrDelay=1000, micBus_1=0;

		var sig, sigDel, env, densCtrl, durCtrl=0, rateCtrl, panCtrl, ptr, ptrRand,
		totalDelay, maxGrainDur, accX, accY, accZ,accXmin, accXmax, pot1, pot2, fader1, fader2;

		accX = In.ar(\gr_accX_bus.ar(0), 1);
		accY = In.ar(\gr_accY_bus.ar(0), 1);
		accZ = In.ar(\gr_accZ_bus.ar(0), 1);

		//descomentar para bela
		//accX = accX.linlin(0.3, 0.5, 0.001, 1.0);
		//accY = accY.linlin(0.3, 0.5, 0.001, 1.0);
		//accZ = accZ.linlin(0.3, 0.5, 0.001, 1.0);

		pot1 = In.ar(\gr_pot1_bus.ar(0), 1);
		pot2 = In.ar(\gr_pot2_bus.ar(0), 1);
		fader1 = In.ar(\gr_fader1_bus.ar(0), 1);
		fader2 = In.ar(\gr_fader2_bus.ar(0), 1);


		/////////////////////////////////////
		rate = rate * (accX + 0.001) * 2;
		/////////////////////////////////////

		env = EnvGen.kr(Env.asr(atk,1,rel), gate, doneAction:2);
		dens = dens.varlag(densLag);


		/////////////////////////////////////
		///   DENSIDADE

		//FADER_1
		dens = dens * (fader1*10) +1;
		//
		densCtrl = Select.ar(sync, [Dust.ar(dens), Impulse.ar(dens)]);

		/////////////////////////////////////

		//rateRand = (accZ+0.001)*2;
		//rateRand.poll;
		rateCtrl = rate * LFNoise1.ar(100).exprange(1/rateRand, rateRand);

		panCtrl = pan + LFNoise1.kr(100).bipolar(panRand);

		/////////////////////////////////////
		ptrRand = (LFNoise1.ar(100).bipolar(ptrRandSamples))*(pot1*1000);
		/////////////////////////////////////

		totalDelay = max(ptrSampleDelay - ptrRand, minPtrDelay);

		ptr = In.ar(ptrBus, 1);
		ptr = ptr - totalDelay;
		ptr = ptr / BufFrames.kr(buf)*accX;

		maxGrainDur = (totalDelay / rateCtrl) / SampleRate.ir;


		//durRand = durRand + (accY * 2);
		//durRand.poll;


		durCtrl = (baseDur * LFNoise1.ar(100).exprange(1/durRand,durRand)) * (((pot2*3)+0.1)+(accY+0.001));



		//durCtrl = (durCtrl+0.01) * (accY * 1);

		//durCtrl = durCtrl * (pot2*10);
		//durCtrl = min(durCtrl, maxGrainDur);

		//durCtrl.poll;


		//////////////////////////////////////

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
			maxGrains:8
		);
		sig = sig * env * amp;
		Out.ar(out, sig);
		//s.sync
	}).add;

	SynthDef(\mstrAudioOut, {
		var sig, sigMic, lpfFreq, revMix = 0.8, revRoom = 0.5, revDamp = 0.5, accX, accY, accZ;

		accX = In.ar(\gr_accX_bus.ar(0), 1);
		accY = In.ar(\gr_accY_bus.ar(0), 1);
		accZ = In.ar(\gr_accZ_bus.ar(0), 1);

		sig = In.ar(\in.kr(0), 2);
		revRoom = accZ;

		lpfFreq = accX.linexp(0, 1, 200, 20000);

		sigMic = LPF.ar(In.ar(\micBus_1.kr(0), 1), lpfFreq);

		sig = (sig*0.8) + (sigMic*0.5);

		sig = FreeVerb2.ar(sig[0], sig[1], revMix, revRoom, revDamp);
		sig = Clip.ar(sig, -0.9, 0.9);
		Out.ar(\out.kr(0), sig);
	}).add;



	(0.5).wait;
	//s.sync;
	"synthdefs adicionados!".postln;


	~ctrlGrp = Group.new;
	~micGrp = Group.after(~ctrlGrp);
	~ptrGrp = Group.after(~micGrp);
	~recGrp = Group.after(~ptrGrp);
	~granGrp = Group.after(~recGrp);
	~audioOutGrp = Group.after(~granGrp);

	(0.5).wait; //se não tiver este dá erro
	//s.sync;
	"grupos carregados!".postln;


	~x_accX = Synth(\synth_accX, [\out, ~accX_bus], ~ctrlGrp);
	~x_accY = Synth(\synth_accY, [\out, ~accY_bus], ~ctrlGrp);
	~x_accZ = Synth(\synth_accZ, [\out, ~accZ_bus], ~ctrlGrp);

	~x_hold = Synth(\synth_hold, [\out, ~hold_bus], ~ctrlGrp);

	~x_pot1 = Synth(\synth_pot1, [\out, ~pot1_bus], ~ctrlGrp);
	~x_pot2 = Synth(\synth_pot2, [\out, ~pot2_bus], ~ctrlGrp);
	~x_fader1 = Synth(\synth_fader1, [\out, ~fader1_bus], ~ctrlGrp);
	~x_fader2 = Synth(\synth_fader2, [\out, ~fader2_bus], ~ctrlGrp);

	Synth(\mic, [\in, 0, \out, ~micBus], ~micGrp);
	Synth(\ptr, [\buf, b, \out, ~ptrBus, \valBtn, ~hold_bus], ~ptrGrp);
	Synth(\rec, [\ptrIn, ~ptrBus, \micIn, ~micBus, \buf, b], ~recGrp);

	//s.sync;
	(0.5).wait;
	"synths chamados!".postln;

	b.zero;
	~g = 2.collect({ // val original 25
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
	//s.sync;
	(0.5).wait;
	Synth(\mstrAudioOut, [
		\in, ~mstrBus,
		\out, 0,
		\gr_accX_bus, ~accX_bus,
		\gr_accY_bus, ~accY_bus,
		\gr_accZ_bus, ~accZ_bus,
		\micBus_1, ~micBus
	], ~audioOutGrp);

	"a tocar!!".postln;
});
)


//ServerQuit.add({ 0.exit }); // quit if the button is pressed
