(
Window.closeAll;
w = Window("window name",
	Rect(
		Window.screenBounds.width/10,
		Window.screenBounds.height/2,
		500,
		600
	)
)
.alwaysOnTop_(true)
.front
.background_(Color.fromHexString("014040"));


~slider_1 = Slider(w, Rect( 20, 20, 50, 250))
.background_(Color.fromHexString("078C8C"))
.knobColor_(Color.fromHexString("05F2DB"))
.action_({ |v|
	var val = v.value * 1;
	~x_fader2.set(\ui_in, val);
});

~slider_2 = Slider(w, Rect( 120, 20, 50, 250))
.background_(Color.fromHexString("078C8C"))
.knobColor_(Color.fromHexString("05F2DB"))
.action_({ |v|
	var val = v.value * 1;
	~x_fader1.set(\ui_in, val);
});

~knb_1 = Knob(w, Rect(230, 60, 80, 80))
.mode_(\vert)
.action_({ |v|
	var val = v.value * 1;
	~x_pot2.set(\ui_in, val);
});

~knb_2 = Knob(w, Rect(370, 60, 80, 80))
.mode_(\vert)
.action_({ |v|
	var val = v.value * 1;
	~x_pot1.set(\ui_in, val);
});




~slider_X = Slider(w, Rect( 20, 320, 50, 250))
.background_(Color.fromHexString("078C8C"))
.knobColor_(Color.fromHexString("05F2DB"))
.action_({ |v|
	var val = v.value * 1;
	~x_accX.set(\ui_in, val);
});
~slider_Y = Slider(w, Rect( 90, 320, 50, 250))
.background_(Color.fromHexString("078C8C"))
.knobColor_(Color.fromHexString("05F2DB"))
.action_({ |v|
	var val = v.value * 1;
	~x_accY.set(\ui_in, val);
});
~slider_Z = Slider(w, Rect( (20+90+50), 320, 50, 250))
.background_(Color.fromHexString("078C8C"))
.knobColor_(Color.fromHexString("05F2DB"))
.action_({ |v|
	var val = v.value * 1;
	~x_accZ.set(\ui_in, val);
});

~btn1 = Button(w, Rect( 280, 420, 50, 30))
.states_([
	["0", Color.red, Color.fromHexString("014040")],
	["1", Color.green, Color.fromHexString("078C8C")]
])
.action_({ |v|
	if( v.value == 0, {
		~x_hold.set(\ui_in, 0);
	});

	if( v.value == 1, {
		~x_hold.set(\ui_in, 1);
	});
});

)