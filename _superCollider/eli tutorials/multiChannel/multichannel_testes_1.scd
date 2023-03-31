s.boot;

5.do { arg item; item.postln };


(
SynthDef.new(\multi, { | out=0, freqMin=50, freqMax=1000 |
	var sig, amp;
	amp = SinOsc.kr({exprand(0.2,12)}!8).range(0,1);
	sig = SinOsc.ar({exprand(freqMin,freqMax)}!18);
	sig = sig * amp;
	sig = Splay.ar(sig) * 0.5;
	Out.ar(out, sig);
}).add;
)

x = Synth(\multi);

x.set(\freqMin, 500);
x.set(\freqMax, 800);


x.free;