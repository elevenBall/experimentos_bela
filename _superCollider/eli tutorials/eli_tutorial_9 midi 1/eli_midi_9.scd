//https://www.youtube.com/watch?v=Oz4KYZ9KLc0

s.options.sampleRate = 44100;
s.boot;

MIDIClient.init;
MIDIIn.connectAll;

MIDIClient.sources;
MIDIIn.connect("Recurso IAC");

(
MIDIdef.noteOn(\noteOnTest, {
	arg nn, vel, chan, src;
	[nn, vel].postln;
});


MIDIdef.noteOff(\noteOffTest, {
	arg vel, nn, chan, src;
	[nn, "off"].postln;
});
)


MIDIIn.doNoteOnAction(







	// define a MIDI input
m = MIDIIn.new;
m.open;

// define a MIDI note on action
m.doNoteOnAction = { |vel, note, chan|
    // send a note on message to the default MIDI output
    MIDIOut.default.noteOn(chan, note, vel);
};

// define a MIDI note off action
m.doNoteOffAction = { |vel, note, chan|
    // send a note off message to the default MIDI output
    MIDIOut.default.noteOff(chan, note, vel);
};