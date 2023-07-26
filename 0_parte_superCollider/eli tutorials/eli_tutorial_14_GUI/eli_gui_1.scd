(
Window.closeAll;
w = Window("janela1", Rect.new(750,50,500,200))
.front
.alwaysOnTop_(true);

~slider1 = Slider(w, Rect.new(20,20,150,30))


)

~slider1.visible_(true);
~slider1.enabled_(true);
~slider1.enabled_(false);

w.view.children;

w.close;

Window.screenBounds;


~slider1.value_(rrand(0.0,1.0));
~slider1.valueAction_(rrand(0.0,1.0));


~slider1.value;

(
~slider1.action_({
	arg obj;
	w.view.background_(Color.rand);
	obj.value.postln;
});
)


~slider1.background_(Color.rand);
~slider1.thumbSize_ (20);
~slider1.knobColor_ (Color.rand);