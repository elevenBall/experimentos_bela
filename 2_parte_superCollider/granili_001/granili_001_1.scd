s.boot;

~bf_audio = Buffer.readChannel(s, "audio/jaci_Rua_Jacinta_Marto.wav".resolveRelative, channels:[0]);

(
SynthDef(\synth_granula_01, {
	var sig, out=0, varPos=0;

	//varPos = LFNoise1.kr(0.01, 1, 0).poll;
	varPos = Phasor.kr(	).poll;
	sig = GrainBuf.ar(
		numChannels: 2,
		trigger: Dust.kr(\trigRate.kr(20)),
		dur: \dur.kr(1),
		sndbuf: ~bf_audio,
		rate: \rate.kr(1),
		pos: varPos,//\pos.kr(0),
		pan: \pan.kr(0),
		maxGrains: 512
	);
	sig = sig * \amp.kr(0.2);
	sig = LPF.ar(sig, \lpf_1.kr(4000));
	sig = Clip.ar(sig, -0.5, 0.5);
	Out.ar(out, sig);

}).add;
)



~syVar = Synth(\synth_granula_01);

~syVar.free;