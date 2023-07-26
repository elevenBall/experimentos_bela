

~b1 = Buffer.read(s, "/Users/elevenball/Documents/Audio_Som/_PERIDOS/galinhas.wav");


~bus1 = Bus.audio(s, 2);



(
~ddd = SynthDef(\audioPlayer, {
    var sig = PlayBuf.ar(2, ~b1);
	Out.ar(~bus1, sig);
}).play;
)


(
~lerBus1 = SynthDef(\leitura1, {
	var sig = In.ar(~bus1, 2);
	Out.ar(0, sig);
}).play;
)





~lerBus1.stop;


~enviarOSC.sendMsg("/testeAudio", sig);
