//https://www.youtube.com/watch?v=hvqPFziOw2U
//Where have I been? SuperCollider, that's where...
s.boot;

(
~bus_effeitos = Bus.audio(s, 2);
~bus_masterOut = Bus.audio(s, 2);
)



(

SynthDef(\oscilador1,{
	var sig;
	sig = LFTri.ar(\x.kr(1) + \r.kr(1), 0.005);
	sig = Pan2.ar(sig * EnvGen.kr(Env.triangle(10), doneAction: 2), \pan.kr(0));
	sig = sig * 0.2;
	Out.ar(~bus_effeitos, sig);
}).add;


SynthDef(\efeitos,{
	var sig;
	sig = In.ar(~bus_effeitos, 2);
	sig = FreeVerb2.ar(sig[0], sig[1], mix: \rev_mix.kr(0.8), room: \rev_room.kr(0.7), damp: \rev_damp.kr(0.1));
	Out.ar(~bus_masterOut, sig);
}).add;

SynthDef(\masterOut, {
	var sig, fb;
	fb = BPF.ar(LocalIn.ar(2), (\filter_freq.kr(400).varlag(3)+LFNoise0.ar(10, 100)), rq: \filter_rq.kr(1.0));
	sig = In.ar(~bus_masterOut, 2) + (fb * \feedback_1.kr(0.01).varlag(1));
	sig = Clip.ar(sig , -0.8, 0.8);
	LocalOut.ar(sig);
	sig = sig * 0.2;
	sig = Clip.ar(sig , -0.8, 0.8);
	Out.ar(0, sig);
}).add;
)


(
~mstOut = Synth(\masterOut);

~mstOut.set(\feedback_1, 1);
~mstOut.set(\filter_freq, 300);
~mstOut.set(\filter_rq, 1);
)


(
~fx = Synth(\efeitos);

~fx.set(\rev_room, 0.9);
~fx.set(\rev_mix, 1);
~fx.set(\rev_damp, 0);
)


(
~r = Routine{
	10.do{
		7.do{
			var w = Scale.major.degrees;
			var x = {(w.choose + (36, 48 .. 72).choose).midicps};
			var r = {SinOsc.ar(rrand(0.4, 4), rrand(8,20))};
			var pan = rrand(-0.8,0.8);
			Synth(\oscilador1, [\x, x, \r, r, \pan, pan]);
			rrand(0,1).wait;
		};
		7.wait;
	};
	0.1.wait;
};
~r.play;
)



~r.stop;