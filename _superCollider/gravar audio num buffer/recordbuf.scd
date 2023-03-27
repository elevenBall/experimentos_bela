/*

Loopiera

*/

// 1. Record sound in a buffer

/* 1.1. Create a buffer for recording.
The buffer has a fixed size.  
Calculate the size of the buffer (number of frames = number of samples) from the duration and the current sample rate of the server.)

Note: Must boot server first, to get its ssample rate. 

numFrames = duration * Server.default.sampleRate;

*/
// Settings: 
(
~bpm = 100;
~beatDuration = 60 / ~bpm; 
~numBeatsInBar = 2;
~numBarsInPhrase = 4;
~inbufferDuration = ~beatDuration * ~numBeatsInBar * ~numBarsInPhrase;
)

// Create buffer:
~inbuffer = Buffer.alloc(Server.default, Server.default.sampleRate * ~inbufferDuration, 1);

// Record into buffer: 
(

~recorder = { | recLevel = 1, preLevel = 0, run = 1, loop = 1, trigger = 1 |
	RecordBuf.ar(
		SoundIn.ar(0, amp),
		~inbuffer.bufnum,
		0, // offset: Start in the beginning of the buffer
		recLevel, // level of input signal
		preLevel, // level of existing signal. If 0, then no overdub
		run, // switch recording on/off. 
		loop, // 0 = no loop, 1 = loop.
		trigger, // trigger with transition from 0 to 1 to (re-)start recording
		2 // free synth when done
	);
	0.0; // Silent.ar;
}.play;

)
// To stop recording do this: 

~recorder.free;


