~bGranu = Buffer.readChannel(s, "audio/01-230623_0958.wav".resolveRelative, channels:[0]);
~bGranu.play;
~bGrano.stop;
(
SynthDef(\granuTeste1, {
	var sig, out=4;
	sig = GrainBuf.ar(
		numChannels: 2,
		trigger: Impulse.kr(\trigRate.kr(20)),
		dur: \dur.kr(1),
		sndbuf: ~bGranu,
		rate: \rate.kr(1),
		pos: \pos.kr(0),
		pan: \pan.kr(0),
		maxGrains: 512
	);
	sig = sig * \amp.kr(0.2);
	sig = Clip.ar(sig, -0.5, 0.5);
	Out.ar(out, sig);
}).add;
)

~graaa = Synth(\granuTeste1);
~graaa.free;


~graaa.set(\amp, 0.2);
~graaa.set(\trigRate, 10);
~graaa.set(\dur, 0.1);
~graaa.set(\pos, 0.1);
~graaa.set(\rate, 0.85);


(
var posi = 0;
~rGra = Routine({
	inf.do({
		posi = (posi+0.00009)+rrand(-0.0001,0.00009);

		if (posi > 1, {posi = 0});

		posi.postln;
		~graaa.set(\pan, rrand(-1,1));
		~graaa.set(\pos, posi);
		~graaa.set(\rate, rrand(0.75, 1.1));
		wait(0.03);//rrand(0.01));
	});
});
~rGra.play;
)
~rGra.stop;