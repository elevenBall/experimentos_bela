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

ServerOptions.devices;




b = Buffer.alloc(s, s.sampleRate * 8.0, 1);

(
SynthDef(\recBUF, { arg out = 0, bufnum = 0, ctrlRec_1 = 0;
	var input = SoundIn.ar(0);
    RecordBuf.ar(input, bufnum, run: ctrlRec_1, loop: 0);
}).add;
)

x = Synth(\recBUF);





b.play;


//{SinOsc.kr(1).poll}.play;


(
OSCdef.new(\btnRec_1, {	arg msg;
	if (msg[1]==1) {x.set(\ctrlRec_1, 1); "1".postln} {x.set(\ctrlRec_1, 0); "0".postlin};
}, "/osc/bt1");
)

