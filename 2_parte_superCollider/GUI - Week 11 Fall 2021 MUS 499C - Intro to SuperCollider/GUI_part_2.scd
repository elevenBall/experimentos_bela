s.boot;




(

	~x = 0;
	Window.closeAll;
	w = Window(bounds:Rect(100,100,430,400))
	.alwaysOnTop_(true).front;
	w.view.decorator_(FlowLayout(w.view.bounds, 20@20, 10@10));
	b = 40.collect({ |i|
		Button(w, 30@30)
		.states_([
			[i+1],
			[i+1, Color.white, Color.red(0.8)]
		]);
	});
	~x = 10.collect({ |i|
		Slider(w, 30@160);
	});
)



(

~routina1 = Routine({
	inf.do({
		{~x[0].value.postln;
			0.1.wait;}.defer;
	});
});
~routina1.play;
)
//~routina1.stop;