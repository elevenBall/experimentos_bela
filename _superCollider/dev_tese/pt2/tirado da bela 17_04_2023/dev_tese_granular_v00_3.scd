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
s.freeAll;
Routine({

	b = Buffer.alloc(s, s.sampleRate * 5);


	s.sync;


	~micBus = Bus.audio(s, 1);
	~ptrBus = Bus.audio(s, 1);

	~btn1_bus = Bus.control(s, 1);
	~accX_bus = Bus.audio(s, 1);
	~accY_bus = Bus.audio(s, 1);
	~accZ_bus = Bus.audio(s, 1);


	s.sync;

	//  sensores  //////////////////////////////////////

	SynthDef(\synthBtn1, {
		var sig = \sig1.ar(0);
		//sig = DigitalIn.ar(\digipin.kr(0));
		Out.ar(\out.kr(0), sig);
	}).add;

	SynthDef(\synthAccX, {
		var sig = \sig1.ar(0);
		//sig = AnalogIn.ar(0);
		//sig = LFNoise1.ar(100).range(0.3,0.5);
		Out.ar(\out.ar(0), sig);
	}).add;

	SynthDef(\synthAccY, {
		var sig = \sig1.ar(0);
		//sig = AnalogIn.ar(1);
		//sig = LFNoise1.ar(100).range(0.3,0.5);
		Out.ar(\out.ar(0), sig);
	}).add;

	SynthDef(\synthAccZ, {
		var sig = \sig1.ar(0);
		//sig = AnalogIn.ar(2);
		//sig = LFNoise1.ar(100).range(0.3,0.5);
		Out.ar(\out.ar(0), sig);
	}).add;



	///////////////////////////////////////////////////

	SynthDef(\mic, {
		arg in=0, out=0, amp=1;
		var sig;
		sig = SoundIn.ar(in) * amp;
		Out.ar(out, sig);
	}).add;


	SynthDef(\ptr, {
		arg out=0, buf=0;
		var sig, rate = \btn1.kr(1);

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

		//accX = AnalogIn.ar(0);
		//accY = AnalogIn.ar(1);
		//accZ = AnalogIn.ar(2);

		accX = \accXvar.ar(0);
		accY = \accYvar.ar(0);
		accZ = \accZvar.ar(0);


		accX = accX.linlin(0.3, 0.5, 0.0, 1.0);
		accY = accY.linlin(0.3, 0.5, 0.0, 1.0);
		accZ = accY.linlin(0.3, 0.5, 0.0, 1.0);

		rate = (rate * (accX * 0.25))+0.8;

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
			maxGrains:50
		);

		sig = sig * env * amp;
		Out.ar(out, sig);
		//s.sync;
	}).add;


	s.sync;




	~sensGrp = Group.new;
	~micGrp = Group.after(~sensGrp);
	~ptrGrp = Group.after(~micGrp);
	~recGrp = Group.after(~ptrGrp);
	~granGrp = Group.after(~recGrp);



	s.sync;


	~debugBtn1 = Synth(\synthBtn1, [\out, ~btn1_bus], ~sensGrp);
	~debugX = Synth(\synthAccX, [\out, ~accX_bus], ~sensGrp);
	~debugY = Synth(\synthAccY, [\out, ~accY_bus], ~sensGrp);
	~debugZ = Synth(\synthAccZ, [\out, ~accZ_bus], ~sensGrp);


	Synth(\mic, [\in, 0, \out, ~micBus], ~micGrp);
	Synth(\ptr, [\buf, b, \out, ~ptrBus, \btn1, ~btn1_bus], ~ptrGrp);
	Synth(\rec, [\ptrIn, ~ptrBus, \micIn, ~micBus, \buf, b], ~recGrp);


	s.sync;



	b.zero;
	~g = 5.collect({ // val original 25
		arg n;
		Synth(\gran, [
			\accXvar, ~accX_bus,
			\accYvar, ~accY_bus,
			\accZvar, ~accZ_bus,
			\amp, n.linlin(0,-5,0,-10).dbamp, //0,4,-3,-20
			\buf, b,
			\out, 0,
			\atk, 1,
			\rel, 1,
			\gate, 1,
			\sync, 1,
			\dens, 5,//30     exprand(20,40), //bom de mexer
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

	"playing".postln;
}).play;

)

//ServerQuit.add({ 0.exit }); // quit if the button is pressed
