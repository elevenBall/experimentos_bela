s.boot;

(
Buffer.freeAll;
ServerTree.removeAll;
ServerQuit.removeAll;
Tdef.removeAll;
)


Server.default.options.outDevice_(5);
Server.default.options.inDevice_(4);
Server.default.reboot;

ServerOptions.devices;

(

~mainOut s= 0;
~micIn = 0;
~recBufSize = 0;

s.waitForBoot({

	Buffer.freeAll;
	s.sync;
	~b = Buffer.alloc(s, s.sampleRate * 30);



});
)

(//record
x = SynthDef(\recBUF, { |out = 0, ctrlRec_1 = 1, trig = 1, run = 1 |
	var input = SoundIn.ar(~micIn);
	~recBufSize = Sweep.ar(trig, SampleRate.ir * run).poll;
	RecordBuf.ar(input, ~b.bufnum,  run: ctrlRec_1);
}).play;
)

(//stop record
x.set(\run, 0);
~recBufSize.postln;
x.free;
)


//play buffer
~b.play;



//supose to store recording lenght in samples but not working yet
~recBufSize.postln;