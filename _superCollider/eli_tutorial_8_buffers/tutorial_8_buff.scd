s.boot;


(
~samples1 = Array.new;
~folder = PathName.new(thisProcess.nowExecutingPath.dirname +/+ "wav");

(
~folder.entries.do({
	arg path;
	~samples1 = ~samples1.add(Buffer.read(s, path.fullPath));
});
)
)



~samples1[0].play;
~samples1[1].play;
~samples1[2].play;

~samples1[10.rand].play;



~samples1[(~folder.entries.size.rand)].play;



~folder.entries.size.rand;




(
SynthDef.new(\playBuf, {
	arg amp=1, out=0, buf, da=2;
	var sig;
	sig = PlayBuf.ar(1, buf, doneAction:da);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

Synth.new(\playBuf, [\buf, ~samples1[(~folder.entries.size.rand)].bufnum]);





(
SynthDef.new(\bufrd_noise, {
	arg amp=1, out=0, buf=0, start=0, end=1, freq=1, revMix=0.5, revRoom=0.5, revDamp=0.5;
	var sig, ptr;
	ptr = LFDNoise1.ar(freq).range(start, end);
	sig = BufRd.ar(1, buf, ptr);
	sig = FreeVerb.ar(sig, revMix, revRoom, revDamp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)


g.set(\revMix, 0.8);
g.set(\revRoom, 0.9);

w.set(\freq, 10);


g = Group.new;
g.free;


(
var bufRnd;
bufRnd = ~folder.entries.size.rand;
w = Synth.new(\bufrd_noise, [\buf, ~samples1[bufRnd].bufnum, \start, 0, \end, ~samples1[bufRnd].numFrames-1, \freq, 0.6, \amp, 0.5],g);
)

(
var bufRnd;
bufRnd = ~folder.entries.size.rand;
x = Synth.new(\bufrd_noise, [\buf, ~samples1[bufRnd].bufnum, \start, 0, \end, ~samples1[bufRnd].numFrames-1, \freq, 0.2, \amp, 0.5],g);
)

(
var bufRnd;
bufRnd = ~folder.entries.size.rand;
y = Synth.new(\bufrd_noise, [\buf, ~samples1[bufRnd].bufnum, \start, 0, \end, ~samples1[bufRnd].numFrames-1, \freq, 1.2, \amp, 0.5],g);
)

(
var bufRnd;
bufRnd = ~folder.entries.size.rand;
z = Synth.new(\bufrd_noise, [\buf, ~samples1[bufRnd].bufnum, \start, 0, \end, ~samples1[bufRnd].numFrames-1, \freq, 0.8, \amp, 0.5],g);
)




w.set(\freq, 1);
x.set(\freq, 0.1);
y.set(\freq, 0.4);
z.set(\freq, 0.01);
z.set(\amp, 1);

g.set(\freq, 30);





w.free;



~samples1[0].numFrames