//https://www.youtube.com/watch?v=Oz4KYZ9KLc0

s.options.sampleRate = 44100;
s.boot;

MIDIClient.init;
MIDIIn.connectAll;

MIDIClient.sources;
MIDIIn.connect("Recurso IAC");

(
MIDIdef.noteOn(\noteOnTest, {
	arg vel, nn, chan, src;
	[vel, nn].postln;
});


MIDIdef.noteOff(\noteOffTest, {
	arg vel, nn, chan, src;
	[vel, nn].postln;
});
)


