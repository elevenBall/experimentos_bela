////////     https://www.youtube.com/watch?v=W2D_PzOVfT0&t=877s

(
Window.closeAll;
w = Window("janela1", Rect(50,600,1349,515))
.front
.alwaysOnTop_(true);

~btn1 = Button(w, Rect(1063,320,55,55))
.states_([
	["I", Color.white, Color.rand],
	["0", Color.black, Color.white],

])
.action_({ arg butt;
	var cf;
	//butt.value.postln;
	cf = butt.value;
	cf = (cf*(-1))+1;
	//~debugBtn1.set(\sig1, cf);
});


~slider1 = Slider(w, Rect.new(55,55,55,405))
.orientation_(\vertical)
.action_({
	arg obj;
	var cf;
	w.view.background_(Color.rand);
	//obj.value.postln;
	cf = obj.value;
	//~debugX.set(\sig1, cf);
});


~slider2 = Slider(w, Rect.new(165,55,55,405))
.orientation_(\vertical)
.action_({
	arg obj;
	var cf;
	~slider1.background_(Color.rand);
	~slider2.background_(Color.rand);
	~slider3.background_(Color.rand);
	//obj.value.postln;
	cf = obj.value;
	//~debugY.set(\sig1, cf);
});


~slider3 = Slider(w, Rect(888,405,405,55))
.action_({
	arg obj;
	var cf=1;
	~slider1.knobColor_ (Color.rand);
	~slider2.knobColor_ (Color.rand);
	~slider3.knobColor_ (Color.rand);
	//obj.value.postln;
	cf = obj.value;
	//~debugZ.set(\sig1, cf);
});

~slider2D_1 = Slider2D(w, Rect(888, 55, 405, 240))


)

w.view.children;

w.close;





