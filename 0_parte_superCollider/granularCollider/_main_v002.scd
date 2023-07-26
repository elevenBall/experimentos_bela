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
{
	var sig;
	sig = GrainBuf.ar(
		2,
		Impulse.ar(10),
		0.09,
		b,
		1,
		0.5,
		2,
		0,
		-1,
		512
	);
}.play
)





s.quit;
