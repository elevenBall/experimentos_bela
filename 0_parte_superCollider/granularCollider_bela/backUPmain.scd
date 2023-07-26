s = Server.default;

s.options.numAnalogInChannels = 4; // can only be 2, 4 or 8
s.options.numAnalogOutChannels = 2;
s.options.numDigitalChannels = 0;
s.options.maxLogins = 4;  	   // set max number of clients
s.options.bindAddress = "0.0.0.0"; // allow anyone on the network connect to this server

s.options.blockSize = 16;
s.options.numInputBusChannels = 2;
s.options.numOutputBusChannels = 2;

s.waitForBoot{
	"Server Booted".postln;
	b = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "au1.wav");
	"buffer loaded!!!!".postln;
	(
	SynthDef("AnalogIn-test",{ arg out=0;
		var vPlayBackRate = (AnalogIn.ar(0)*3).exprange( 0.0001, 10 );
	//	var vPlayBackRate = (AnalogIn.ar(0)*3).exprange( 20, 200 );
		var vDuration = AnalogIn.ar(1)*3;
		var vPosition = AnalogIn.ar(2)*3;
		var vRateTrig = AnalogIn.ar(3)*3;
		var sig = GrainBuf.ar(
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
		Out.ar(0, sig.dup);
	}).send(s);
	);

	s.sync;
	Synth.new("AnalogIn-test", target: s);
};

ServerQuit.add({ 0.exit }); // quit if the button is pressed
