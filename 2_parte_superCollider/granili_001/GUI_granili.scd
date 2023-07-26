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



(

~x = 0;
Window.closeAll;
w = Window(bounds:Rect(100,100,430,400))
.alwaysOnTop_(true).front;
w.view.decorator_(FlowLayout(w.view.bounds, 20@20, 10@10));

~x = 10.collect({ |i|
	Slider(w, 160@30)
	.background_(Color.fromHexString("078C8C"))
	.knobColor_(Color.fromHexString("05F2DB"))
	.action_({ |v|
		v.value.postln;
	});
	NumberBox(w, 100@30);
});
)


)

w.close;


