(
Buffer.freeAll;
ServerTree.removeAll;
ServerQuit.removeAll;
Tdef.removeAll;
)

(
s.boot;
//Server.default.options.device_("AudioFire4 (2945)");
Server.default.options.inDevice_(3);
Server.default.options.outDevice_(4);
s.options.numOutputBusChannels = 2;
s.options.numInputBusChannels = 2;
Server.default.reboot;
)

ServerOptions.devices;

/*
ServerOptions.devices;
Server.default.options.inDevice_("Colunas (MacBook Air)");
Server.default.options.outDevice_("Microfone (MacBook Air)");
//s.options.sampleRate = 44100;
*/

(
OSCdef.new(
	\val1,
	{
		arg msg, time, addr, port;
		msg[1].postln;
	},
	'/osc/val1'
);
)

NetAddr.langPort;

(
s.meter;
s.plotTree;
s.scope;
)

(
var caminho;
caminho = thisProcess.nowExecutingPath.dirname +/+ "au1.wav";
b = Buffer.read( s, caminho);
)
b.play;
b.numChannels;
b.free;

(
SynthDef.new(\granulador_1, {
	arg vPlayBackRate = 1, vRateTrig = 20;
	var sig;
	sig = GrainBuf.ar(
		2,
		Impulse.ar(vRateTrig),
		0.9,
		b,
		vPlayBackRate,
		0.5,
		2,
		0,
		-1,
		512
	);
	sig = sig * 0.5;
	Out.ar(0, sig);
}).add;
)

x = Synth.new(\granulador_1, [\vPlayBackRate, 1]);

x.set(\vPlayBackRate, 1);
x.set(\vRateTrig, 3);
x.free;


s.quit;
