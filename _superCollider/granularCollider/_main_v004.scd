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
SynthDef(\granulador_1, {
	arg vPlayBackRate = 1, vDuration = 1, vPosition = 0.5, vRateTrig = 20, mix = 0.25, room = 0.65, damp = 0.5;
	var sig;
	vPosition = LFNoise0.kr(100).range(0, 1).lag(3);
	vDuration = LFNoise0.kr(100).range(0.00001, 0.3);
	vRateTrig = LFNoise0.kr(100).range(20, 200);
	vPlayBackRate = LFNoise0.kr(100).range(-1, 1);

	sig = GrainBuf.ar(
		2,
		Impulse.ar(vRateTrig.lag(0)),
		vDuration,
		b,
		vPlayBackRate.lag(1),
		vPosition.lag(0),
		2,
		0,
		-1,
		512
	);
	sig = sig * 0.5;
	Out.ar(0, FreeVerb.ar(
            sig, // mono src
            mix, // mix 0-1
            room, // room 0-1
            damp // damp 0-1 duh
        ) ! 2 // fan out...
    );
}).add;
)

x = Synth.new(\granulador_1);


x.set(\vPlayBackRate, 0.2);
x.set(\mix, 0.6);
x.set(\room, 0.9);

freeverb



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
	},'/osc/val1'
	//'/appleWatch/attitude/x'
);
)

(
OSCdef.new( \val2, { arg msg;
		x.set(\vPlayBackRate, msg[1].linlin(0,1, -5, 5));
	}, '/osc/val2');
)

(
OSCdef.new( \val3, { arg msg;
	x.set(\vDuration, msg[1].linlin(0,1, 0, 1));
	}, '/osc/val3');
)

(
OSCdef.new( \val4, { arg msg;
	x.set(\vPosition, msg[1].linlin(0,1, 0, 1));
	}, '/osc/val4');
)

(
OSCdef.new( \bt1, { arg msg;
	//x.set(\vPosition, msg[1].linlin(0,1, 0, 1));
	if ( msg[1] == 0, { (x = Synth.new(\granulador_1))}, {x.free});
	}, '/osc/bt1');
)




NetAddr.langPort;
//----------------------------------------------------------\\



s.quit;
