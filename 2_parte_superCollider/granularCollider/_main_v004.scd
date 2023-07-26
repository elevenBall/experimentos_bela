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
	arg vPlayBackRate = 1, vDuration = 1, vPosition = 0.5, vRateTrig = 20;
	var sig;
	sig = GrainBuf.ar(
		2,
		Impulse.ar(vRateTrig.lag(0)),
		vDuration,
		b,
		vPlayBackRate,
		vPosition.lag(5),
		2,
		0,
		-1,
		512
	);
	sig = sig * 0.5;
	Out.ar(0, sig);
}).add;
)

x = Synth.new(\granulador_1);


x.free;




//-------------------------- OSC //--------------------------\\

(
OSCdef.new(
	\val1,
	{
		arg msg, time, addr, port;
		x.set(\vRateTrig, msg[1].linlin(0,1, 0.0001, 10));
		//msg[1].postln;
		//[msg, time, addr, port].postln;
	},
	'/osc/val1'
	//'/appleWatch/attitude/x'
);
)

(
OSCdef.new(
	\val2,
	{
		arg msg;
		x.set(\vPlayBackRate, msg[1].linlin(0,1, -5, 5));
		//msg[1].postln;
	},
	'/osc/val2'
);
)

(
OSCdef.new(
	\val3,
	{
		arg msg;
		x.set(\vDuration, msg[1].linlin(0,1, 0, 1));
		//msg[1].postln;
	},
	'/osc/val3'
);
)

(
OSCdef.new(
	\val4,
	{
		arg msg;
		x.set(\vPosition, msg[1].linlin(0,1, 0, 1));
		msg[1].postln;
	},
	'/osc/val4'
);
)

NetAddr.langPort;
//----------------------------------------------------------\\



s.quit;
