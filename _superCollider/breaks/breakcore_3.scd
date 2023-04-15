//https://www.youtube.com/watch?v=KwvqoH4LPKM


s.boot;

~buffer = Buffer.read(Server.default, "/Volumes/SMC 4TB/sergiocoutinho/Documentos/Audio/Samples/Samples SMC/Jungle Jungle - 1989 to 1999 Samplepack/Breaks/Calling Break.wav".standardizePath);

(
SynthDef(\slice, {
	var snd;
	snd = PlayBuf.ar(2, \buf.kr(0), BufRateScale.kr(\buf.kr(0)) * \rate.kr(1), startPos: BufFrames.kr(\buf.kr(0)) * \slice.kr(0) / 16);
	snd = snd * Env.linen(0, BufDur.kr(\buf.kr(0)) / 16 / \rate.kr(1), 0.01).ar;
	snd = snd * Env.asr(0.001,1,0.01).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * -6.dbamp ! 2;
	//snd = HPF.ar(snd, 400);
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\fx, {
	var snd;
	snd = In.ar(\out.kr(0), 2);
	snd = ( snd * 20.dbamp).tanh * -10.dbamp;
	ReplaceOut.ar(\out.kr(0), snd);
}).add;
)

(
~string="
01234543
2347789d
abcdefef
12dacbf3
"
)

(
~string="
01234321
2347789d
abcdefef
12dacbf3
"
)

(
~string="
1
"
)


(
Routine {
	var s, bpm, beat, tatum;
	bpm = 100;
	beat = 60 / bpm;
	tatum = beat / 4;
	s = Server.default;

	Synth.tail(nil, \fx);
	s.sync;

	loop{
		~string.do { | c |
			var synth;
			if ("0123456789abcdef".includes(c)){
				c.postln;
				s.makeBundle(s.latency, {
					synth = Synth(\slice, [buf: ~buffer, slice: "0123456789abcdef".indexOf(c), rate: 1.4]);
				});
				tatum.wait;
				s.makeBundle(s.latency, {
					synth.set(\gate, 0);
				});
			};
		};
	};
}.play;
)
