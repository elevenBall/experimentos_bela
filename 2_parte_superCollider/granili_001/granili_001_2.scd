s.boot;

~bf_audio = Buffer.readChannel(s, "audio/jaci_Rua_Jacinta_Marto.wav".resolveRelative, channels:[0]);

~bf_audio = Buffer.readChannel(s, "/Users/elevenball/Desktop/Discotecas ambulantes (Texto de Filipe Homem Fonseca)_Maria Rueff/01-230623_0958.wav".resolveRelative, channels:[0]);


(
~au_ch_1 = Bus.audio(s, 2);
~fxSnd_bus = Bus.audio(s, 2);
~master_bus = Bus.audio(s, 2);
)





(
SynthDef(\synth_granula_01, {
	var sig, varPos=0, phaRate=0;

	//varPos = LFNoise1.kr(0.01, 1, 0).poll;
	phaRate = 1 * \playRate.kr(1) / s.sampleRate ;
	varPos = Phasor.kr(rate: phaRate);
	sig = GrainBuf.ar(
		numChannels: 2,
		trigger: Dust.kr(\trigRate.kr(20)),
		dur: \dur.kr(0.01),
		sndbuf: ~bf_audio,
		rate: \rate.kr(1),
		pos: varPos + LFNoise0.kr(1).range(-0.005, 0.005),//\pos.kr(0),
		pan: \pan.kr(0),
		maxGrains: 512
	);
	sig = sig * \amp.kr(0.2);
	sig = LPF.ar(sig, \lpf_1.kr(4000));
	sig = Clip.ar(sig, -0.5, 0.5);
	Out.ar(\out.kr(0), sig);
}).add;


SynthDef(\audioOut_1, {
	var sig;
	sig = In.ar(\master_in.kr(0), 2);
	sig = FreeVerb.ar(sig, mix: \rev_Mix.kr(1), room: \rev_Room.kr(1), damp: \rev_Damp.kr(0.5))*\rev_Amp.kr(2);
	sig = LPF.ar(sig, 200);
	sig = sig + ( HPF.ar(In.ar(~au_ch_1), 1000)*\dryMaster.kr(0.4));
	sig = Clip.ar(sig, -0.8, 0.8);
	Out.ar(\out.kr(0), sig);
}).add;


)

(
~masterVar = Synth(\audioOut_1, [\master_in, ~au_ch_1]);
~syVar = Synth(\synth_granula_01, [\out, ~au_ch_1]);
)

(
~masterVar.set(\rev_Room, 0.8);
~masterVar.set(\rev_Amp, 40);
~masterVar.set(\dryMaster, 12);


~syVar.set(\dur, 1);

~syVar.set(\rate, 0.7);

~syVar.set(\amp, 0.4);

)

~syVar.free;



.defer



(

~rGra = Routine({
	inf.do({
		~syVar.set(\rate, ~arrVal[0].value*3);
		~syVar.set(\dur, ~arrVal[1].value);
		~syVar.set(\trigRate, ~arrVal[2].value*100);
		~masterVar.set(\rev_Room, ~arrVal[3]);
		~masterVar.set(\rev_Amp, ~arrVal[4]*40);
		~masterVar.set(\dryMaster, ~arrVal[5]*12);


		wait(0.03);//rrand(0.01));
	});
});
~rGra.play;
)
~rGra.stop;




