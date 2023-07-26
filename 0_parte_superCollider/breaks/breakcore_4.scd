//https://www.youtube.com/watch?v=KwvqoH4LPKM


s.boot;


~folder = PathName.new(thisProcess.nowExecutingPath.dirname +/+ "wav");




~buffer = Buffer.read(Server.default, ~folder +/+ "Calling Break.wav".standardizePath);
~buffer = Buffer.read(Server.default, "/Volumes/SMC 4TB/sergiocoutinho/Documentos/Audio/Samples/Samples SMC/Jungle Jungle - 1989 to 1999 Samplepack/Breaks/Pesh Break.wav".standardizePath);




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
"/Volumes/SMC 4TB/sergiocoutinho/Documentos/BELA_BOARD/experimentos_bela/_superCollider/breaks/wav/Calling_Break.wav"
(
~string="
0,
1,
2,
3,
4,
5,
4,
3,
2,
3,
4,
7,
7,
8,
9,
d,
a,
b,
c,
d,
e,
f,
e,
f,
1,
2,
d,
a,
c,
b,
f,
3
"
)

(
~string="
0, 1, 2, 3, 4, 3, 2, 1,
2, 3, 4, 7, 7, 8, 9, d,
a, b, c, d, e, f, e, f,
1, 2,  , a, c, b, f, 3
"
)


(
~string="
0,
1,
2 repeat=4,
3 pitch=-12 repeat=2,
4,
5,
6 pitch=-3 repeat=4,
7 pitch=3
"
)





(
Routine {
	var s, bpm, bpmOri, beat, tatum;
	bpmOri = 180 /2;
	bpm = 65/2;
	beat = 60 / bpm;
	tatum = beat / 4;
	s = Server.default;

	Synth.tail(nil, \fx);
	s.sync;

	loop{
		~string.split($,).do { | line |
			var synth;
			var parts;
			var pitch = 0;
			var repeat = 1;
			parts = line.stripWhiteSpace.split($ );
			if (parts[0].size > 0){
				parts.do { |part|
					if (part[.."pitch".size - 1] == "pitch"){
						pitch = part.split($=)[1].asInteger;
					};
					if (part[.."repeat".size - 1] == "repeat"){
						repeat = part.split($=)[1].asInteger;
					};
				};

				line.postln;
				repeat.do{
					s.makeBundle(s.latency, {
						synth = Synth(\slice, [buf: ~buffer, slice: "0123456789abcdef".indexOf(parts[0][0]), rate: (bpm / bpmOri) * pitch.midiratio]);
					});
					(tatum/repeat).wait;
					s.makeBundle(s.latency, {
						synth.set(\gate, 0);
					});
				};
			};
		};
	};
}.play;
)
