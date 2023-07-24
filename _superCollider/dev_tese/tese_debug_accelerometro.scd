
s = Server.default;

s.options.numAnalogInChannels = 8;
s.options.numAnalogOutChannels = 2;
s.options.numDigitalChannels = 1;

s.options.blockSize = 64;
s.options.numInputBusChannels = 2;
s.options.numOutputBusChannels = 2;

s.options.belaMaxScopeChannels = 8;

s.options.postln;

s.waitForBoot{
	"Server Booted".postln;

	SynthDef(\analog_test,{
		var analog_0 = AnalogIn.ar(0).belaScope(0); //  X - RED
		var analog_1 = AnalogIn.ar(1).belaScope(1); //  Y - BLUE
		var analog_2 = AnalogIn.ar(2).belaScope(2); //  Z - GREEN

		// var analog_3 = AnalogIn.ar(3).belaScope(0);
		// var analog_4 = AnalogIn.ar(4).belaScope(0);
		// var analog_5 = AnalogIn.ar(5).belaScope(0);
		// var analog_6 = AnalogIn.ar(6).belaScope(0);
		// var analog_7 = AnalogIn.ar(7).belaScope(0);
	}).add;

	s.sync;
	Synth(\analog_test);
};



ServerQuit.add({ 0.exit }); // quit if the button is pressed
