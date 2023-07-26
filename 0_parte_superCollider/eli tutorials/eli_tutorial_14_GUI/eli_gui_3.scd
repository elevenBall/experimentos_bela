////////     https://www.youtube.com/watch?v=W2D_PzOVfT0&t=877s

(
Window.closeAll;
w = Window("janela1", Rect.new(750,50,500,200))
.front
.alwaysOnTop_(true);

~btn1 = Button(w, Rect(200,20,30,30))
.states_([
	["I", Color.white, Color.rand],
	["0", Color.black, Color.white],

])
.action_({ arg butt;
	var cf;
	//butt.value.postln;
	cf = butt.value;
	cf = (cf*(-1))+1;
	~debugBtn1.set(\sig1, cf);
});


~slider1 = Slider(w, Rect.new(20,20,150,30))
.action_({
	arg obj;
	var cf;
	w.view.background_(Color.rand);
	//obj.value.postln;
	cf = obj.value;
	~debugX.set(\sig1, cf);
});


~slider2 = Slider(w, Rect.new(20,70,150,30))
.action_({
	arg obj;
	var cf;
	~slider1.background_(Color.rand);
	~slider2.background_(Color.rand);
	~slider3.background_(Color.rand);
	//obj.value.postln;
	cf = obj.value;
	~debugY.set(\sig1, cf);
});


~slider3 = Slider(w, Rect.new(20,120,150,30))
.action_({
	arg obj ;
	var cf;
	~slider1.knobColor_ (Color.rand);
	~slider2.knobColor_ (Color.rand);
	~slider3.knobColor_ (Color.rand);
	//obj.value.postln;
	cf = obj.value;
	~debugZ.set(\sig1, cf);
});


)

w.view.children;

w.close;





