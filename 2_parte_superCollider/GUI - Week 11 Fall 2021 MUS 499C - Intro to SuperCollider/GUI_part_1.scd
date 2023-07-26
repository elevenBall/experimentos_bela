// https://www.youtube.com/watch?v=Xe19iY6PG2M
// GUI, Part I - Week 11 Fall 2021 MUS 499C - Intro to SuperCollider


// https://www.youtube.com/watch?v=mAA9Hcw1pg4
// GUI, Part II - Week 12 Fall 2021 MUS 499C - Intro to SuperCollider

(
Window.closeAll;
w = Window("window name",
	Rect(
		Window.screenBounds.width/10,
		Window.screenBounds.height/2,
		300,
		400
	)
)
.alwaysOnTop_(true)
.front
.background_(Color.fromHexString("014040"));


~sl = Slider(w, Rect( 20, 20, 30, 130))
.background_(Color.fromHexString("078C8C"))
.knobColor_(Color.fromHexString("05F2DB"))
.action_({ |v|
	v.value.postln;
});


~btn1 = Button(w, Rect( 70, 20, 50, 30))
.states_([
	["0", Color.red, Color.fromHexString("014040")],
	["1", Color.green, Color.fromHexString("078C8C")],
	["3", Color.rand, Color.fromHexString("05F2DB")]
])
.action_({ |v|
	("button primide e o valor é: " ++ v.value).postln;
	if( v.value == 0, {
		"ZEROO!!!".postln;
	});

	if( v.value == 1, {
		"UM!!!".postln;
	});
	if( v.value == 2, {"DOISSSS!!!".postln;});
});


~knb1 = Knob(w, Rect(70, 60, 50, 50))
.mode_(\vert)
.action_({ |v|
	v.value.postln;
});

)

w.close;

~btn1.valueAction_(1);



(
SynthDef(\sino1, {
	var sig;
	sig = SinOsc.ar(60) * 0.1;
	Out.ar(0, sig);
});
)

