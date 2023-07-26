s.boot;

(

~mainOut = 0;
~micIn = 0;
~recBufSize = 0;

s.waitForBoot({

	Buffer.freeAll;
	s.sync;
	~b = Buffer.alloc(s, s.sampleRate * 30);



});
)

(
x = SynthDef(\recBUF, { |out = 0, ctrlRec_1 = 1|
	var input = SoundIn.ar(~micIn);
	RecordBuf.ar(input, ~b.bufnum,  run: ctrlRec_1);
}).play;
)

x.free;

~b.play;