(
Buffer.freeAll;
ServerTree.removeAll;
ServerQuit.removeAll;
Tdef.removeAll;
)


(
s.boot;
//Server.default.options.device_("AudioFire4 (2945)");
//Server.default.options.inDevice_(3);
//Server.default.options.outDevice_(4);
//s.options.numOutputBusChannels = 2;
//s.options.numInputBusChannels = 2;
//Server.default.reboot;
)


Server.default.reboot;

ServerOptions.devices;



//evaluate to create empty buffer
~b = Buffer.alloc(s, s.sampleRate * 8.0, 1);

(//evaluate to record
x = SynthDef(\recBUF, { arg out = 0, bufnum = ~b, ctrlRec_1 = 1;
	var input = SoundIn.ar(0);
    RecordBuf.ar(input, bufnum, recLevel:1.0, preLevel:0.0 , run: ctrlRec_1, loop: 0);
}).play;
)

(//eavluate to stop recording
x.set(\ctrlRec_1, 0);
x.free;
)

//evaluate to play
~b.play;





//{SinOsc.kr(1).poll}.play;


(
OSCdef.new(\btnRec_1, {	arg msg;
	if (msg[1]==1) {x.set(\ctrlRec_1, 1); "recording - 1".postln} {x.set(\ctrlRec_1, 0); "recording - 0".postln};
}, "/osc/bt1");
)


(
OSCdef.new(\btnPlay_1, {	arg msg;
	if (msg[1]==1) {b.play} {b.stop};
}, "/osc/bt2");
)








(
SynthDef(\rec, {
	arg bufnum, rec = 1;
	var in = SoundIn.ar(0),	phase = Phasor.ar(0, 1, 0, BufFrames.kr(bufnum)), stopTrig = (rec <= 0);
	BufWr.ar(in, bufnum, phase);
	if(rec==0) {~b.numFrames = phase * ~b.numFrames}{};
	FreeSelf.kr(stopTrig);
}).add;
)





a = Synth(\rec, [bufnum: ~b]);  // recording...

a.set(\rec, 0);  // stop

~b.play;