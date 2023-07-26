s.boot;


(
SynthDef.new(\multi, { | out=0, freqMin=90, freqMax=91 |
	var sig, amp;
	amp = SinOsc.kr({exprand(0.2,12)}!8).range(0,1);
	sig = SinOsc.ar({exprand(freqMin.clip(20,20000),freqMax.clip(20,20000))}!8);
	sig = sig * amp;
	sig = Splay.ar(sig) * \amp.kr(0.3);
	Out.ar(out, sig);
}).add;
)

x = Synth(\multi);

x.set(\freqMin, 500);
x.set(\freqMax, 500);


x.set(\amp, 0.0);




x.free;